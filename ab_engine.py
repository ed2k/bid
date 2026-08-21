#!/usr/bin/env python3
"""
Paired A/B: legacy lookahead (0.0 for non-terminal states at depth cap)
vs fixed lookahead (greedy rollout to terminal + DDS eval), same process.
"""

import os
import time
from typing import Dict, List

from bid.models import Call, CallType, Seat
from bid.decision_net import DecisionNet
from bid.pidm import PIDMEngine
from bid.arena import BiddingArena
from bid.sampling import RBMBMCSampler, Deal, PartialState

from eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR
from improve_improved_system import precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
EVAL_SEED = 777


class LegacyPIDMEngine(PIDMEngine):
    def lookahead(self, deal, history, models, my_seat, dealer, vuln, depth=0):
        temp_state = PartialState(my_seat, deal.hands[my_seat], history, dealer, vuln)
        if temp_state.is_auction_over() or depth >= self.max_lookahead_depth:
            return self.evaluate_terminal_deal(deal, history, my_seat, dealer, vuln)
        next_seat = temp_state.current_turn
        next_model = models.get(next_seat)
        if next_model is None:
            next_actions = {Call(CallType.PASS)}
        else:
            next_actions = next_model.actions(deal.hands[next_seat], history, next_seat, dealer, vuln)
        if not next_actions:
            next_actions = {Call(CallType.PASS)}
        if len(next_actions) == 1:
            return self.lookahead(deal, history + [next(iter(next_actions))], models, my_seat, dealer, vuln, depth + 1)
        is_my_side = (next_seat == my_seat or next_seat == my_seat.partner)
        vals = [self.lookahead(deal, history + [a], models, my_seat, dealer, vuln, depth + 1) for a in next_actions]
        return max(vals) if is_my_side else min(vals)


def main():
    net = load_decision_net_dsl(TARGET)
    variants = {
        "legacy(0.0-ties)": LegacyPIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06), max_lookahead_depth=1),
        "fixed(rollout)": PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06), max_lookahead_depth=1),
    }
    deltas = []
    for seed in (42, 7, 13):
        deals = build_deals(64, seed=seed)
        dd = precompute(deals)
        line = f"  seed {seed:<3}"
        scores = {}
        for name, eng in variants.items():
            arena = BiddingArena(engine=eng)
            t0 = time.time()
            r = evaluate_system(arena, name, net, deals, dd, seed=EVAL_SEED)
            scores[name] = r
            line += f" | {name} {r['avg_score']:+7.1f} ({(time.time()-t0)/len(deals):.2f}s/bd)"
        deltas.append(scores["fixed(rollout)"]["avg_score"] - scores["legacy(0.0-ties)"]["avg_score"])
        print(line)
        print(f"        legacy flaws {dict(scores['legacy(0.0-ties)']['flaws'])}")
        print(f"        fixed  flaws {dict(scores['fixed(rollout)']['flaws'])}")
    print(f"\nFixed-vs-legacy deltas: {['%+.1f' % d for d in deltas]} avg {sum(deltas)/3:+.1f}")


if __name__ == "__main__":
    main()
