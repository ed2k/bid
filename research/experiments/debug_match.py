#!/usr/bin/env python3
"""Debug which DecisionNetRule matched at a given decision point."""
import os
import random
import sys

from bid.models import Seat
from bid.features import BridgeFeatures
from bid.sampling import PartialState
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from eval_vs_dds import build_deals, load_decision_net_dsl, SYSTEM_DIR

random.seed(0)
deals = build_deals(64, seed=42)
net = load_decision_net_dsl(os.path.join(SYSTEM_DIR, "improved_system.dsl"))

board = int(sys.argv[1])
target_seat_name = sys.argv[2]
n_calls = int(sys.argv[3])

deal = deals[board - 1]
target_seat = Seat[target_seat_name]

# Replay auction manually up to n_calls, then inspect
engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06), max_lookahead_depth=1)
arena = BiddingArena(engine=engine)
models = {s: net for s in Seat}

history = []
curr = deal.dealer
for i in range(n_calls):
    ps = PartialState(curr, deal.hands[curr], history, deal.dealer, deal.vuln)
    call, values = engine.decide(ps, models)
    print(f"turn {i}: {curr.name} bids {call}")
    if i == n_calls - 1:
        break
    history.append(call)
    curr = Seat((curr.value + 1) % 4)

print(f"\n--- {target_seat_name} to act, history={history} ---")
features = BridgeFeatures.extract_all(deal.hands[target_seat], history, target_seat, deal.dealer, deal.vuln)
print(f"partner_last_call={features['partner_last_call']!r} is_opening={features['is_opening']} "
      f"hcp={features['hcp']} spade_len={features['spade_len']} heart_len={features['heart_len']}")
matched = []
for r in net.rules:
    if r.matches(features):
        matched.append(r)
        print(f"MATCH {r.rule_id:<28} -> {r.call} (prio {r.priority}) conds: {[str(c) for c in r.conditions]}")
cands = net.actions(deal.hands[target_seat], history, target_seat, deal.dealer, deal.vuln)
print(f"\ncandidate set phi(s): {sorted(str(c) for c in cands)}")
