#!/usr/bin/env python3
"""
Continuous improvement flywheel for system/improved_system.dsl.

Every round:
  1. Play the deal set vs native DDS par (paired, seeded), dump worst flaws
  2. Auto-generate a patch pool from ALL improvement approaches:
       - curated anti-flaw rule patches (overcalls, takeouts, raises, ...)
       - ParDiagnosticEngine corrective families
       - ungated-rule scan  -> gated variants (is_opening=False / partner!=NONE)
       - broad-match ("junk") rule scan -> single-rule removal candidates
       - threshold mutations (tighten / loosen HCP & length bounds)
  3. Greedy paired hill-climb on the train set with guardrails
  4. Confirm on disjoint validation sets; versioned save on success

Persistent state (system/flywheel_state.json) caches failed patch signatures,
tracks the version number, and archives each accepted version under
system/history/, so the flywheel can be re-run continually without repeating work.

Usage: PYTHONPATH=.. python3 flywheel.py [--deals 48] [--rounds 3] [--pool-cap 14]
"""

import argparse
import copy
import json
import os
import random
import shutil
import time
from typing import Callable, Dict, List, Optional, Tuple

from bid.models import Strain, Seat, Call, CallType
from bid.decision_net import DecisionNetRule, RuleCondition, DecisionNet
from bid.arena import BiddingArena
from bid.pidm import PIDMEngine
from bid.sampling import RBMBMCSampler
from bid.diagnostics import ParDiagnosticEngine

from bid.eval_vs_dds import build_deals, evaluate_system, load_decision_net_dsl, SYSTEM_DIR, precompute

TARGET = os.path.join(SYSTEM_DIR, "improved_system.dsl")
STATE_PATH = os.path.join(SYSTEM_DIR, "flywheel_state.json")
HISTORY_DIR = os.path.join(SYSTEM_DIR, "history")
TRAIN_SEED = 42
VAL_SEEDS = (7, 13)
EVAL_SEED = 777

CONTEXT_KEYS = {"partner_last_call", "opp_last_call", "my_last_call", "is_opening",
                "is_balancing", "is_competitive", "last_bid_strain"}
NUMERIC_KEYS = {"hcp", "spade_len", "heart_len", "diamond_len", "club_len",
                "controls", "total_points"}


def B(level, strain):
    return Call(CallType.BID, level, strain)


# ---------------- patch primitives ----------------

def add_rules(net, rules):
    existing = {r.rule_id for r in net.rules}
    for r in rules:
        if r.rule_id not in existing:
            net.add_rule(r)


def replace_rule(net, new_rule):
    net.rules = [r for r in net.rules if r.rule_id != new_rule.rule_id]
    net.add_rule(new_rule)


def remove_ids(ids):
    def patch(net):
        net.rules = [r for r in net.rules if r.rule_id not in ids]
    return patch


# ---------------- curated patches ----------------

def p_overcalls(net):
    add_rules(net, [
        DecisionNetRule("FW_OVERCALL_1H", B(1, Strain.HEARTS), [
            RuleCondition("opp_last_call", "in", ["1C", "1D", "1S"]),
            RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 8)], description="", priority=22),
        DecisionNetRule("FW_OVERCALL_1S", B(1, Strain.SPADES), [
            RuleCondition("opp_last_call", "in", ["1C", "1D", "1H"]),
            RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 8)], description="", priority=22),
    ])


def p_balancing(net):
    add_rules(net, [
        DecisionNetRule("FW_BAL_1H", B(1, Strain.HEARTS), [
            RuleCondition("is_balancing", "==", True),
            RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 8)], description="", priority=23),
        DecisionNetRule("FW_BAL_1S", B(1, Strain.SPADES), [
            RuleCondition("is_balancing", "==", True),
            RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 8)], description="", priority=23),
    ])


def p_tko_shape(net):
    add_rules(net, [
        DecisionNetRule("FW_TKO_VS_S", Call(CallType.DOUBLE), [
            RuleCondition("is_competitive", "==", True),
            RuleCondition("last_bid_strain", "==", "S"),
            RuleCondition("spade_len", "<=", 2), RuleCondition("hcp", ">=", 11),
            RuleCondition("heart_len", ">=", 4)], description="", priority=25),
        DecisionNetRule("FW_TKO_VS_H", Call(CallType.DOUBLE), [
            RuleCondition("is_competitive", "==", True),
            RuleCondition("last_bid_strain", "==", "H"),
            RuleCondition("heart_len", "<=", 2), RuleCondition("hcp", ">=", 11),
            RuleCondition("spade_len", ">=", 4)], description="", priority=25),
    ])


def p_force_raise(net):
    add_rules(net, [
        DecisionNetRule("FW_2NT_FORCE", B(2, Strain.NT), [
            RuleCondition("partner_last_call", "in", ["1H", "1S"]),
            RuleCondition("hcp", ">=", 11)], description="", priority=24),
        DecisionNetRule("FW_2NT_ACCEPT_H", B(4, Strain.HEARTS), [
            RuleCondition("partner_last_call", "==", "2NT"),
            RuleCondition("heart_len", ">=", 5), RuleCondition("hcp", ">=", 13)], description="", priority=26),
        DecisionNetRule("FW_2NT_ACCEPT_S", B(4, Strain.SPADES), [
            RuleCondition("partner_last_call", "==", "2NT"),
            RuleCondition("spade_len", ">=", 5), RuleCondition("hcp", ">=", 13)], description="", priority=26),
        DecisionNetRule("FW_2NT_DECLINE", B(3, Strain.NT), [
            RuleCondition("partner_last_call", "==", "2NT"),
            RuleCondition("hcp", "<=", 12)], description="", priority=20),
    ])


def p_aggression(net):
    """Opponent-aggressiveness aware competition rules (#feature-addition).

    Uses the new auction features (opp_preempted, opp_strength_class,
    auction_altitude, vuln_pressure, opp_bid_count, opp_fit_shown,
    our_fit_shown) so competitiveness adapts to HOW the opponents behave
    instead of only whether they have bid at all."""
    add_rules(net, [
        # push into a preemption war only at favorable vulnerability
        DecisionNetRule("FW_PREEMPT_PUSH_S", B(3, Strain.SPADES), [
            RuleCondition("opp_preempted", "==", True),
            RuleCondition("is_favorable_vuln", "==", True),
            RuleCondition("hcp", ">=", 9),
            RuleCondition("spade_len", ">=", 6)], priority=23),
        DecisionNetRule("FW_PREEMPT_PUSH_H", B(3, Strain.HEARTS), [
            RuleCondition("opp_preempted", "==", True),
            RuleCondition("is_favorable_vuln", "==", True),
            RuleCondition("hcp", ">=", 9),
            RuleCondition("heart_len", ">=", 6)], priority=23),
        # discipline: don't stretch into game zone at unfavorable vul
        # against opponents who have shown strength
        DecisionNetRule("FW_ALTITUDE_DISCIPLINE", Call(CallType.PASS), [
            RuleCondition("auction_altitude", ">=", 3),
            RuleCondition("is_unfavorable_vuln", "==", True),
            RuleCondition("hcp", "<=", 11)], priority=25),
        # opponents preempts => their hands are weak: compete light with fit
        DecisionNetRule("FW_VS_WEAK_COMPETE", B(2, Strain.HEARTS), [
            RuleCondition("opp_strength_class", "==", "weak"),
            RuleCondition("our_fit_shown", "==", True),
            RuleCondition("hcp", ">=", 7),
            RuleCondition("heart_len", ">=", 3)], priority=21),
    ])


def p_nt_safety(net):
    """Stopper-aware NT bidding + slam controls discipline.

    Targets the OVERBID_DOWN diagnostic family: 3NT/6NT contracts reached
    without a stopper in the opponents' bid suit, and slam bids made with
    insufficient controls."""
    add_rules(net, [
        # negative guard: don't drive 3NT with no stopper against an
        # opponent suit auction at equal/unfavorable vulnerability
        DecisionNetRule("FW_3NT_NO_STOPPER", B(3, Strain.NT), [
            RuleCondition("opp_bid_count", ">=", 1),
            RuleCondition("opp_suit_stoppers", "<=", 0.0),
            RuleCondition("is_balanced", "==", True),
            RuleCondition("hcp", "<=", 18)],
            is_negative=True, priority=27),
        # penalty double of a weak preempt when strong with their suit stopped
        DecisionNetRule("FW_X_WEAK_PREEMPT", Call(CallType.DOUBLE), [
            RuleCondition("opp_preempted", "==", True),
            RuleCondition("hcp", ">=", 15),
            RuleCondition("opp_suit_stoppers", ">=", 2.0),
            RuleCondition("is_unfavorable_vuln", "==", False)], priority=26),
        # slam discipline: 6NT needs controls; keep 5-level exploration
        # instead when controls are short
        DecisionNetRule("FW_6NT_CONTROLS", B(6, Strain.NT), [
            RuleCondition("auction_altitude", ">=", 3),
            RuleCondition("controls", ">=", 6),
            RuleCondition("hcp", ">=", 22)], priority=28),
    ])


def p_support(net):
    """Support-raise competition rules using support_in_partner_suit.

    Classic competitive decisions that per-hand features cannot express:
    mixed raises (3+ support, 6-10 HCP), preemptive raises (4+ support,
    light, favorable vulnerability), and a guard against 2-trump raises."""
    add_rules(net, [
        DecisionNetRule("FW_MIXED_RAISE_H", B(2, Strain.HEARTS), [
            RuleCondition("partner_last_bid_strain", "==", "H"),
            RuleCondition("support_in_partner_suit", ">=", 3),
            RuleCondition("hcp", ">=", 6),
            RuleCondition("hcp", "<=", 10)], priority=21),
        DecisionNetRule("FW_MIXED_RAISE_S", B(2, Strain.SPADES), [
            RuleCondition("partner_last_bid_strain", "==", "S"),
            RuleCondition("support_in_partner_suit", ">=", 3),
            RuleCondition("hcp", ">=", 6),
            RuleCondition("hcp", "<=", 10)], priority=21),
        DecisionNetRule("FW_PRE_RAISE_H", B(3, Strain.HEARTS), [
            RuleCondition("partner_last_bid_strain", "==", "H"),
            RuleCondition("support_in_partner_suit", ">=", 4),
            RuleCondition("hcp", "<=", 8),
            RuleCondition("is_favorable_vuln", "==", True)], priority=22),
        DecisionNetRule("FW_NO_2_TRUMP_RAISE", B(2, Strain.HEARTS), [
            RuleCondition("partner_last_bid_strain", "==", "H"),
            RuleCondition("support_in_partner_suit", "<=", 2),
            RuleCondition("hcp", "<=", 10)],
            is_negative=True, priority=24),
    ])


CURATED = {
    "OVERCALLS": p_overcalls,
    "BALANCING": p_balancing,
    "TKO_SHAPE": p_tko_shape,
    "FORCE_RAISE_2NT": p_force_raise,
    "AGGRESSION": p_aggression,
    "NT_SAFETY": p_nt_safety,
    "SUPPORT": p_support,
}


# ---------------- auto-generated patches ----------------

def scan_ungated(net: DecisionNet) -> List[DecisionNetRule]:
    out = []
    for r in net.rules:
        if r.call.type != CallType.BID or r.call.level < 2:
            continue
        keys = {c.key for c in r.conditions}
        if not (keys & CONTEXT_KEYS):
            out.append(r)
    return out


def scan_broad_rules(net: DecisionNet) -> List[DecisionNetRule]:
    out = []
    for r in net.rules:
        keys = {c.key for c in r.conditions}
        if not (keys & CONTEXT_KEYS):
            out.append(r)
    return out


def gate_variant(rule: DecisionNetRule, mode: str) -> DecisionNetRule:
    conds = list(rule.conditions)
    if mode == "not_opening":
        conds.append(RuleCondition("is_opening", "==", False))
    else:
        conds.append(RuleCondition("partner_last_call", "!=", "NONE"))
    return DecisionNetRule(rule.rule_id, rule.call, conds,
                           description=rule.description, priority=rule.priority)


def mutate_bounds(rule: DecisionNetRule, direction: str) -> Optional[DecisionNetRule]:
    conds = []
    changed = False
    for c in rule.conditions:
        c2 = RuleCondition(c.key, c.op, c.value)
        if c.key in NUMERIC_KEYS and isinstance(c.value, (int, float)):
            if direction == "tighten":
                if c.op == ">=":
                    c2.value += 1
                    changed = True
                elif c.op == "<=":
                    c2.value -= 1
                    changed = True
            else:
                if c.op == ">=":
                    c2.value -= 1
                    changed = True
                elif c.op == "<=":
                    c2.value += 1
                    changed = True
        conds.append(c2)
    if not changed:
        return None
    return DecisionNetRule(rule.rule_id, rule.call, conds,
                           description=rule.description, priority=rule.priority)


# ---------------- flywheel ----------------

class Flywheel:
    def __init__(self, arena, n_deals, pool_cap, rng_seed=123, sds_scorer=None, sds_primary=False):
        self.arena = arena
        self.sds_scorer = sds_scorer
        self.sds_primary = sds_primary and sds_scorer is not None
        self.rng = random.Random(rng_seed)
        self.train_deals = build_deals(n_deals, seed=TRAIN_SEED)
        self.dd_train = precompute(self.train_deals)
        self.val_sets = {}
        for s in VAL_SEEDS:
            d = build_deals(n_deals, seed=s)
            self.val_sets[s] = (d, precompute(d))
        self.state = self._load_state()
        self.n_deals = n_deals
        self.pool_cap = pool_cap

    def _load_state(self) -> dict:
        if os.path.exists(STATE_PATH):
            with open(STATE_PATH) as f:
                return json.load(f)
        return {"version": 5, "failed": [], "applied": []}

    def _save_state(self):
        with open(STATE_PATH, "w") as f:
            json.dump(self.state, f, indent=2)

    def evl(self, net, deals, dd):
        return evaluate_system(self.arena, "cand", net, deals, dd,
                               run_diagnostics=True, seed=EVAL_SEED,
                               sds_scorer=self.sds_scorer)

    def sig_failed(self, sig) -> bool:
        return sig in self.state["failed"]

    def fail(self, sig):
        if sig not in self.state["failed"]:
            self.state["failed"].append(sig)

    def build_pool(self, net: DecisionNet, diagnostics: List) -> List[Tuple[str, str, Callable]]:
        entries: List[Tuple[str, str, Callable]] = []

        for name, fn in CURATED.items():
            entries.append((f"curated:{name}", name, fn))

        fams: Dict[str, List] = {}
        for r in ParDiagnosticEngine.generate_corrective_rules_for_diagnostics(diagnostics):
            fams.setdefault(r.rule_id.split("_")[0], []).append(r)
        for fam, rules in sorted(fams.items()):
            entries.append((f"diag:{fam}", f"DIAG_{fam}",
                            (lambda rl: (lambda n: add_rules(n, rl)))(rules)))

        for r in scan_ungated(net)[:6]:
            for mode in ("not_opening", "partner"):
                g = gate_variant(r, mode)
                entries.append((
                    f"gate:{r.rule_id}:{mode}", f"GATE_{r.rule_id}_{mode}",
                    (lambda rr: (lambda n: replace_rule(n, rr)))(g)))

        for r in scan_broad_rules(net)[:6]:
            entries.append((
                f"drop:{r.rule_id}", f"DROP_{r.rule_id}",
                (lambda rid: (lambda n: remove_ids({rid})))(r.rule_id)))

        mutatable = [r for r in net.rules
                     if any(c.key in NUMERIC_KEYS for c in r.conditions)]
        self.rng.shuffle(mutatable)
        for r in mutatable[:6]:
            m = mutate_bounds(r, "tighten")
            if m is not None:
                entries.append((
                    f"tighten:{r.rule_id}", f"TIGHTEN_{r.rule_id}",
                    (lambda rr: (lambda n: replace_rule(n, rr)))(m)))
        for r in mutatable[:4]:
            m = mutate_bounds(r, "loosen")
            if m is not None:
                entries.append((
                    f"loosen:{r.rule_id}", f"LOOSEN_{r.rule_id}",
                    (lambda rr: (lambda n: replace_rule(n, rr)))(m)))

        seen, capped = set(), []
        for sig, name, fn in entries:
            if sig in seen:
                continue
            seen.add(sig)
            if self.sig_failed(sig):
                continue
            capped.append((sig, name, fn))
            if len(capped) >= self.pool_cap:
                break
        return capped

    @staticmethod
    def flaw_dump(res, max_boards=6) -> List[str]:
        lines = []
        diags = sorted(res["diagnostics"], key=lambda d: -d.severity_pts)[:max_boards]
        for d in diags:
            auction = " ".join(str(c) for c in d.actual_history)
            lines.append(f"      Bd {d.board_id:<3} [{d.flaw_type.value:<15}] "
                         f"{d.par_contract:<14} loss {d.severity_pts:5.0f} | {auction}")
        return lines

    def run_round(self, round_no: int, current: DecisionNet, cur_train) -> Tuple[DecisionNet, object, List[str]]:
        metric = "avg_score_sds" if self.sds_primary else "avg_score"
        print(f"\n{'='*92}\n ROUND {round_no} | train {metric} "
              f"{cur_train[metric]:+.1f} | flaws {dict(cur_train['flaws'])}\n{'='*92}")
        print("   Worst boards:")
        for line in self.flaw_dump(cur_train):
            print(line)

        pool = self.build_pool(current, cur_train["diagnostics"])
        newly_failed = []
        applied = []

        for pass_no in (1, 2):
            if not pool:
                break
            print(f"\n   [pass {pass_no}] testing {len(pool)} generated patches:")
            best_sig, best_name, best_fn, best_delta, best_res = None, None, None, 0.0, None
            tested: List[Tuple[str, float]] = []
            for sig, name, fn in pool:
                cand = current.clone()
                fn(cand)
                res = self.evl(cand, self.train_deals, self.dd_train)
                delta = res[metric] - cur_train[metric]
                tested.append((sig, delta))
                ok = (delta > 0
                      and res["par_accuracy"] >= cur_train["par_accuracy"] - 5
                      and res["avg_imp_loss"] <= cur_train["avg_imp_loss"] + 0.15)
                if ok and delta > best_delta:
                    best_sig, best_name, best_fn, best_delta, best_res = sig, name, fn, delta, res
                print(f"     {name:<34} {delta:+8.1f}")
            for sig, delta in tested:
                if delta <= 0:
                    newly_failed.append(sig)
            if best_sig is None:
                print("     no improving patch this pass")
                break
            best_fn(current)
            applied.append({"sig": best_sig, "name": best_name, "delta": round(best_delta, 1)})
            pool = [p for p in pool if p[0] != best_sig]
            cur_train = best_res
            print(f"     APPLIED {best_name} ({best_delta:+.1f}) | rules {len(current.rules)}")

        for sig in dict.fromkeys(newly_failed):
            self.fail(sig)
        return current, cur_train, applied

    def validate_and_save(self, original, orig_train, orig_val, current, cur_train, applied):
        metric = "avg_score_sds" if self.sds_primary else "avg_score"
        final_val = {s: self.evl(current, *self.val_sets[s]) for s in VAL_SEEDS}
        train_gain = cur_train[metric] - orig_train[metric]
        print(f"\n   VALIDATION ({metric}): train {train_gain:+.1f}", end="")
        val_ok = True
        for s in VAL_SEEDS:
            d = final_val[s][metric] - orig_val[s][metric]
            val_ok = val_ok and d > -5
            print(f" | val{s} {d:+.1f}", end="")
        print()

        sds_delta = None
        if self.sds_scorer is not None:
            o = self.evl(original, self.train_deals, self.dd_train)
            c = self.evl(current, self.train_deals, self.dd_train)
            sds_delta = c["avg_score_sds"] - o["avg_score_sds"]
            print(f"   SDS two-hand check: {o['avg_score_sds']:+.1f} -> {c['avg_score_sds']:+.1f} "
                  f"({sds_delta:+.1f})")
            if sds_delta < -5:
                print("   REJECTED: DD gain is luck-based (SDS realistic-info score regressed)")
                for a in applied:
                    self.fail(a["sig"])
                return False

        if applied and train_gain > 0 and val_ok:
            v = self.state["version"]
            os.makedirs(HISTORY_DIR, exist_ok=True)
            shutil.copy(TARGET, os.path.join(HISTORY_DIR, f"improved_system_v{v}.dsl"))
            self.state["version"] = v + 1
            current.name = f"ImprovedSystem_v{self.state['version']}"
            current.save_dsl(TARGET)
            self.state["applied"].extend(applied)
            self._save_state()
            print(f"   SAVED v{self.state['version']} -> {TARGET} (archived v{v})")
            return True
        print("   NOT SAVED (validation failed or no patches)")
        for a in applied:
            self.fail(a["sig"])
        return False


def main():
    parser = argparse.ArgumentParser(description="Continuous improvement flywheel")
    parser.add_argument("--deals", type=int, default=48)
    parser.add_argument("--rounds", type=int, default=3)
    parser.add_argument("--pool-cap", type=int, default=14)
    parser.add_argument("--sds", action="store_true", help="Gate saves on SDS two-hand score")
    parser.add_argument("--sds-primary", action="store_true",
                        help="Hill-climb directly on the SDS two-hand objective")
    args = parser.parse_args()

    t0 = time.time()
    engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=2, max_iterations=6, timeout_sec=0.06),
                        max_lookahead_depth=1)
    sds_scorer = None
    if args.sds or args.sds_primary:
        from bid.sds import SDSScorer
        sds_scorer = SDSScorer(num_worlds=20, seed=2024)
        mode = "SDS-primary hill-climb" if args.sds_primary else "SDS save-gate"
        print(f"{mode} enabled")
    fw = Flywheel(BiddingArena(engine=engine), args.deals, args.pool_cap,
                  sds_scorer=sds_scorer, sds_primary=args.sds_primary)

    original = load_decision_net_dsl(TARGET)
    orig_train = fw.evl(original, fw.train_deals, fw.dd_train)
    orig_val = {s: fw.evl(original, *fw.val_sets[s]) for s in VAL_SEEDS}
    print(f"Start: train {orig_train['avg_score']:+.1f} | "
          + " | ".join(f"val{s} {orig_val[s]['avg_score']:+.1f}" for s in VAL_SEEDS)
          + f" | state v{fw.state['version']} ({len(fw.state['failed'])} cached failures)")

    current, cur_train = original.clone(), orig_train
    for rnd in range(1, args.rounds + 1):
        current, cur_train, applied = fw.run_round(rnd, current, cur_train)
        if not applied:
            print("\nFlywheel converged: no patch improved this round.")
            break
        if not fw.validate_and_save(original, orig_train, orig_val, current, cur_train, applied):
            break

    final = fw.evl(current, fw.train_deals, fw.dd_train)
    print(f"\n{'='*92}\n SESSION SUMMARY\n{'='*92}")
    print(f"  train : {orig_train['avg_score']:+.1f} -> {final['avg_score']:+.1f} "
          f"({final['avg_score'] - orig_train['avg_score']:+.1f})")
    for s in VAL_SEEDS:
        rv = fw.evl(current, *fw.val_sets[s])
        print(f"  val{s}  : {orig_val[s]['avg_score']:+.1f} -> {rv['avg_score']:+.1f} "
              f"({rv['avg_score'] - orig_val[s]['avg_score']:+.1f})")
    print(f"  state : v{fw.state['version']} | {len(fw.state['failed'])} cached failures "
          f"| {len(fw.state['applied'])} lifetime patches applied")
    print(f"  Done in {time.time() - t0:.1f}s")


if __name__ == "__main__":
    main()
