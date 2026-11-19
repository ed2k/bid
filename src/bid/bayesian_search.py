"""Program 4: Test-Time Bayesian Single-Dummy Rollout Search (`BayesianSingleDummyBidder`).

Combines `DiffDSLNet` symbolic rule candidates with:
  1. Auction-Consistent Bayesian World Sampling (`K` unseen 39-card deals
     filtered by exact sequence HCP/shape constraints + vectorized `TensorDecisionNet`
     past-turn consistency).
  2. Vectorized `BatchedAuctionEnv` continuation rollouts + exact 20-entry
     Double-Dummy (`DDSolver`) WBF IMP comparison.
  3. 100% Explainable Bid Output (`BidExplanation`) preserving the winning rule
     trace and attaching quantitative Single-Dummy EV (`E[ΔIMP]`).
"""
from __future__ import annotations

import math
import random
from typing import Any, Dict, List, Optional, Sequence, Set, Tuple, Union

import torch

import gpu_arena as ga
from bid.dds import DDSolver
from bid.decision_net import DecisionNet
from bid.diff_dsl_net import AtomTrace, BidExplanation, DiffDSLNet
from bid.eval_vs_dds import load_decision_net_dsl, parse_call
from bid.features import BridgeFeatures
from bid.models import Call, CallType, Card, Hand, Rank, Seat, Strain, Suit
from bid.sampling import Deal, PartialState
from bid.scoring import Vulnerability, calculate_contract_score


class BayesianSingleDummyBidder:
    """Neuro-Symbolic `DiffDSLNet` enhanced with Test-Time Bayesian Single-Dummy Rollout Search."""

    def __init__(
        self,
        dsl_or_net: Union[str, DecisionNet, DiffDSLNet],
        num_worlds: int = 8,
        pool_size: int = 160,
        min_imp_margin: float = 2.25,
        min_t_stat: float = 1.85,
        seed: int = 42,
        device: Union[str, torch.device] = "cpu",
    ):
        if isinstance(dsl_or_net, DiffDSLNet):
            self.diff_net = dsl_or_net
            self.decision_net = dsl_or_net.to_decision_net()
        elif isinstance(dsl_or_net, DecisionNet):
            self.decision_net = dsl_or_net
            self.diff_net = DiffDSLNet(dsl_or_net, device=device)
        else:
            self.decision_net = load_decision_net_dsl(dsl_or_net)
            self.diff_net = DiffDSLNet(self.decision_net, device=device)

        self.name = f"{self.diff_net.name}_bayes_sd"
        self.device = torch.device(device)
        self.t_net = self.diff_net.to_tensor_decision_net()
        self.num_worlds = int(num_worlds)
        self.pool_size = int(pool_size)
        self.min_imp_margin = float(min_imp_margin)
        self.min_t_stat = float(min_t_stat)
        self.base_seed = int(seed)
        self.last_explanation: Optional[BidExplanation] = None

    @staticmethod
    def _infer_seat_constraints(
        history: Sequence[Call],
        dealer: Seat,
    ) -> Dict[Seat, Dict[str, Any]]:
        """Infer conservative HCP bounds and minimum suit lengths for each seat from `history`."""
        cons: Dict[Seat, Dict[str, Any]] = {
            s: {"hcp_lo": 0, "hcp_hi": 37, "min_len": {0: 0, 1: 0, 2: 0, 3: 0}, "max_len": {0: 13, 1: 13, 2: 13, 3: 13}}
            for s in Seat
        }
        opening_bid: Optional[Call] = None
        opening_seat: Optional[Seat] = None
        opp_suits_by_side = {0: set(), 1: set()}

        for idx, call in enumerate(history):
            seat = Seat((dealer.value + idx) % 4)
            side = seat.value % 2
            opp_side = 1 - side
            sc = cons[seat]

            if call.type == CallType.PASS:
                if opening_bid is None:
                    # Passed hand in unopened auction -> at most 11 HCP
                    sc["hcp_hi"] = min(sc["hcp_hi"], 11)
            elif call.type == CallType.DOUBLE:
                sc["hcp_lo"] = max(sc["hcp_lo"], 10)
            elif call.type == CallType.BID and call.strain is not None:
                lvl = call.level
                st = call.strain
                st_idx = st.value  # 0=C, 1=D, 2=H, 3=S, 4=NT

                if opening_bid is None:
                    opening_bid = call
                    opening_seat = seat
                    if st == Strain.NT:
                        if lvl == 1:
                            sc["hcp_lo"] = max(sc["hcp_lo"], 15)
                            sc["hcp_hi"] = min(sc["hcp_hi"], 17)
                        elif lvl == 2:
                            sc["hcp_lo"] = max(sc["hcp_lo"], 20)
                            sc["hcp_hi"] = min(sc["hcp_hi"], 21)
                    elif lvl == 1:
                        sc["hcp_lo"] = max(sc["hcp_lo"], 11)
                        sc["hcp_hi"] = min(sc["hcp_hi"], 21)
                        min_l = 5 if st in (Strain.HEARTS, Strain.SPADES) else 3
                        sc["min_len"][st_idx] = max(sc["min_len"][st_idx], min_l)
                    elif lvl == 2:
                        if st == Strain.CLUBS:
                            sc["hcp_lo"] = max(sc["hcp_lo"], 20)
                        else:
                            sc["hcp_lo"] = max(sc["hcp_lo"], 5)
                            sc["hcp_hi"] = min(sc["hcp_hi"], 10)
                            sc["min_len"][st_idx] = max(sc["min_len"][st_idx], 6)
                    elif lvl >= 3:
                        sc["hcp_lo"] = max(sc["hcp_lo"], 5)
                        sc["hcp_hi"] = min(sc["hcp_hi"], 11)
                        sc["min_len"][st_idx] = max(sc["min_len"][st_idx], 7)
                else:
                    # Subsequent bid
                    if opening_seat == seat.partner and not opp_suits_by_side[opp_side]:
                        # Uncontested response to partner
                        if call == Call(CallType.BID, 2, Strain.NT) and opening_bid.level == 1 and opening_bid.strain in (Strain.HEARTS, Strain.SPADES):
                            sc["hcp_lo"] = max(sc["hcp_lo"], 13)
                            sc["min_len"][opening_bid.strain.value] = max(sc["min_len"][opening_bid.strain.value], 4)
                        elif st != Strain.NT and st == opening_bid.strain:
                            sc["min_len"][st_idx] = max(sc["min_len"][st_idx], 3)
                            sc["hcp_lo"] = max(sc["hcp_lo"], 6 if lvl == 2 else 10)
                        elif lvl == 1:
                            sc["hcp_lo"] = max(sc["hcp_lo"], 6)
                            if st != Strain.NT:
                                sc["min_len"][st_idx] = max(sc["min_len"][st_idx], 4)
                        elif lvl == 2 and st != Strain.NT:
                            sc["hcp_lo"] = max(sc["hcp_lo"], 10)
                            sc["min_len"][st_idx] = max(sc["min_len"][st_idx], 4)
                    elif opening_seat is not None and (opening_seat.value % 2) != side:
                        # Competitive overcall / action by opponents of opener
                        if call == Call(CallType.BID, 2, Strain.NT) and opening_bid.level == 1 and opening_bid.strain != Strain.NT:
                            # Unusual 2NT showing 5-5 in two lowest unbid suits
                            unbid = [s_i for s_i in range(4) if s_i != opening_bid.strain.value][:2]
                            for u_s in unbid:
                                sc["min_len"][u_s] = max(sc["min_len"][u_s], 5)
                            sc["hcp_lo"] = max(sc["hcp_lo"], 7)
                        elif st != Strain.NT:
                            if st_idx in opp_suits_by_side[opp_side] and lvl == 2:
                                # Michaels cuebid
                                sc["hcp_lo"] = max(sc["hcp_lo"], 8)
                            else:
                                sc["hcp_lo"] = max(sc["hcp_lo"], 7 if lvl == 1 else 9)
                                sc["min_len"][st_idx] = max(sc["min_len"][st_idx], 5 if lvl <= 2 else 6)

                if st != Strain.NT:
                    opp_suits_by_side[side].add(st_idx)

        return cons

    def _sample_consistent_worlds(
        self,
        my_seat: Seat,
        my_hand: Hand,
        history: Sequence[Call],
        dealer: Seat,
        vuln: int,
    ) -> List[Deal]:
        """Sample `self.num_worlds` unseen 39-card deals consistent with `history`."""
        my_cards = {(c.suit, c.rank) for c in my_hand.cards}
        unknown_cards = [
            Card(suit, rank)
            for suit in Suit
            for rank in Rank
            if (suit, rank) not in my_cards
        ]
        other_seats = [s for s in Seat if s != my_seat]
        cons = self._infer_seat_constraints(history, dealer)

        rng = random.Random(self.base_seed + len(history) * 131 + my_hand.hcp * 17)
        scored_pool: List[Tuple[float, int, Dict[Seat, Hand]]] = []

        for idx in range(self.pool_size):
            rng.shuffle(unknown_cards)
            h_map: Dict[Seat, Hand] = {
                my_seat: my_hand,
                other_seats[0]: Hand(unknown_cards[0:13]),
                other_seats[1]: Hand(unknown_cards[13:26]),
                other_seats[2]: Hand(unknown_cards[26:39]),
            }
            penalty = 0.0
            for s in other_seats:
                h = h_map[s]
                sc = cons[s]
                hcp = h.hcp
                if hcp < sc["hcp_lo"]:
                    penalty += (sc["hcp_lo"] - hcp) * 2.5
                elif hcp > sc["hcp_hi"]:
                    penalty += (hcp - sc["hcp_hi"]) * 2.5
                for su_idx, su in enumerate((Suit.CLUBS, Suit.DIAMONDS, Suit.HEARTS, Suit.SPADES)):
                    l_su = h.length(su)
                    min_l = sc["min_len"][su_idx]
                    if l_su < min_l:
                        penalty += (min_l - l_su) * 6.0
            scored_pool.append((penalty, idx, h_map))

        scored_pool.sort(key=lambda t: (t[0], t[1]))
        # Take top 3 * num_worlds by constraint satisfaction and score action consistency via TensorDecisionNet
        shortlist = [
            Deal(hands=h_map, dealer=dealer, vuln=vuln)
            for _, _, h_map in scored_pool[: max(self.num_worlds, min(len(scored_pool), self.num_worlds * 3))]
        ]
        if not history or len(shortlist) <= self.num_worlds:
            return shortlist[: self.num_worlds]

        # Vectorized past-auction consistency check using BatchedAuctionEnv
        sub_bundle = ga.DealBundle.from_deals(shortlist, compute_dd=False, device=self.device)
        env = ga.BatchedAuctionEnv(sub_bundle)
        env.passes_since_last_np = torch.zeros(env.B, dtype=torch.long, device=self.device)
        match_Other = torch.zeros(len(shortlist), dtype=torch.float32, device=self.device)

        for t_idx, actual_call in enumerate(history[:20]):
            X_t, seat_t = env.build_features()
            lmask_t = env.legal_mask(seat_t)
            cand_mask, best_c = self.t_net.call_scores(X_t, lmask_t)
            act_code = ga.CALL_TO_IDX.get(str(actual_call), ga.IDX_PASS)
            if int(seat_t[0].item()) != my_seat.value:
                exact_hit = (best_c == act_code).to(torch.float32)
                cand_hit = (cand_mask[:, act_code] > 0.5).to(torch.float32) * 0.5
                match_Other = match_Other + exact_hit + cand_hit
            step_c = torch.full((len(shortlist),), act_code, dtype=torch.long, device=self.device)
            env.step(step_c)

        base_penalties = torch.tensor(
            [scored_pool[i][0] for i in range(len(shortlist))],
            dtype=torch.float32,
            device=self.device,
        )
        total_score = match_Other * 3.0 - base_penalties
        top_indices = torch.argsort(total_score, descending=True)[: self.num_worlds].tolist()
        return [shortlist[i] for i in top_indices]

    @staticmethod
    def _legal_calls_set(
        history: Sequence[Call],
        my_seat: Seat,
        dealer: Seat,
    ) -> Set[Call]:
        last_bid: Optional[Call] = None
        last_np: Optional[Tuple[int, Call]] = None
        for i, call in enumerate(history):
            if call.type == CallType.BID:
                last_bid = call
            if call.type != CallType.PASS:
                last_np = (i, call)
        x_ok = False
        xx_ok = False
        if last_np is not None:
            idx, lc = last_np
            seat_of_lc = Seat((dealer.value + idx) % 4)
            opp_of_me = seat_of_lc not in (my_seat, my_seat.partner)
            if lc.type == CallType.BID:
                x_ok = opp_of_me
            elif lc.type == CallType.DOUBLE and opp_of_me:
                j = idx - 1
                while j >= 0:
                    pc = history[j]
                    if pc.type != CallType.PASS:
                        ps_seat = Seat((dealer.value + j) % 4)
                        if pc.type == CallType.BID and ps_seat in (my_seat, my_seat.partner):
                            xx_ok = True
                        break
                    j -= 1
        legal: Set[Call] = set()
        for c_name in ga.CALL_NAMES:
            c_obj = parse_call(c_name)
            if c_obj.type == CallType.PASS:
                legal.add(c_obj)
            elif c_obj.type == CallType.DOUBLE and x_ok:
                legal.add(c_obj)
            elif c_obj.type == CallType.REDOUBLE and xx_ok:
                legal.add(c_obj)
            elif c_obj.type == CallType.BID:
                if last_bid is None:
                    legal.add(c_obj)
                elif c_obj.level > last_bid.level:
                    legal.add(c_obj)
                elif c_obj.level == last_bid.level and c_obj.strain.value > last_bid.strain.value:
                    legal.add(c_obj)
        return legal

    def _generate_candidates(
        self,
        hand: Hand,
        history: Sequence[Call],
        my_seat: Seat,
        dealer: Seat,
        vuln: int,
        base_exp: BidExplanation,
    ) -> Tuple[List[Call], bool]:
        """Return `(candidate_calls, should_search)` for the current auction state."""
        legal_set = self._legal_calls_set(history, my_seat, dealer)
        default_call = parse_call(base_exp.call_str)
        if default_call not in legal_set:
            default_call = Call(CallType.PASS)

        feats = BridgeFeatures.extract_all(hand, list(history), my_seat, dealer, vuln)
        is_open = bool(feats["is_opening"])
        opps_bid = bool(feats["opponents_bid"])
        conv_state = int(feats["conv_state"])
        last_lvl = int(feats["last_bid_level"])
        hcp = int(feats["hcp"])
        comb_hcp = int(feats["seq_combined_hcp_min"])
        comb_fit = int(feats["combined_fit_len_est"])
        eff_trump = str(feats["effective_trump"])

        # Never override explicit Program 1/2 high-priority convention/DAgger rules (prio >= 900)
        if base_exp.priority >= 900.0 or conv_state in (2, 3, 4, 5, 6, 7, 8):
            return [default_call], False
        nt_unstopped_alert = (
            default_call.type == CallType.BID
            and default_call.strain == Strain.NT
            and int(feats.get("unstopped_opp_suits", 0)) >= 1
        )
        if is_open or (last_lvl <= 2 and not bool(feats.get("is_power_double_hand", False)) and not nt_unstopped_alert):
            return [default_call], False

        cands: List[Call] = [default_call]

        def _add(c_str: str) -> None:
            c_obj = parse_call(c_str)
            if c_obj in legal_set and c_obj not in cands:
                cands.append(c_obj)

        # Always consider PASS in non-opening auctions to prevent costly overbids
        if not is_open:
            _add("PASS")

        # Include other active positive rules from DecisionNet
        for c_obj in self.decision_net.actions(hand, list(history), my_seat, dealer, vuln)[:3]:
            if c_obj in legal_set and c_obj not in cands:
                cands.append(c_obj)

        # High-leverage tactical candidates:
        # 1. Competitive / Constructive Major Fit Raises & Game
        if eff_trump in ("H", "S") and comb_fit >= 8:
            for lvl in (2, 3, 4):
                if (lvl == 2 and comb_hcp >= 19) or (lvl == 3 and comb_hcp >= 22) or (lvl == 4 and comb_hcp >= 24):
                    _add(f"{lvl}{eff_trump}")
            if comb_hcp >= 30 and int(feats["rkcb_keycards"]) >= 2:
                _add(f"6{eff_trump}")

        # 2. Notrump Game / Partscore with all opponent suits stopped
        if bool(feats.get("all_opp_suits_stopped", feats["has_stopper"])):
            if 22 <= comb_hcp <= 25:
                _add("2NT")
            if comb_hcp >= 25:
                _add("3NT")

        # 3. Direct / Balancing Overcalls & Takeout/Penalty Doubles in contested auctions
        if not is_open and opps_bid:
            # Takeout or penalty X when holding values
            if hcp >= 12:
                _add("X")
            # Natural 1- or 2-level overcall in a 5+ card suit with >= 10 HCP
            if hcp >= 10:
                for su_str, su_key, opp_key in (
                    ("S", "spade_len", "opp_bid_spades"),
                    ("H", "heart_len", "opp_bid_hearts"),
                    ("D", "diamond_len", "opp_bid_diamonds"),
                    ("C", "club_len", "opp_bid_clubs"),
                ):
                    if int(feats[su_key]) >= 5 and not bool(feats[opp_key]):
                        _add(f"1{su_str}")
                        if int(feats[su_key]) >= 6 or hcp >= 12:
                            _add(f"2{su_str}")

        should_search = len(cands) >= 2 and (opps_bid or last_lvl >= 2 or len(history) >= 2)
        return cands[:5], should_search

    @torch.no_grad()
    def decide_with_explanation(
        self,
        hand: Hand,
        history: Sequence[Call],
        my_seat: Seat = Seat.SOUTH,
        dealer: Seat = Seat.NORTH,
        vuln: int = 0,
    ) -> Tuple[Call, BidExplanation]:
        """Select the best call using `DiffDSLNet` + Bayesian Single-Dummy Rollout Search."""
        base_exp = self.diff_net.explain_hand(hand, list(history), my_seat, dealer, vuln)
        cands, should_search = self._generate_candidates(hand, history, my_seat, dealer, vuln, base_exp)
        if not should_search or len(cands) <= 1:
            self.last_explanation = base_exp
            return cands[0], base_exp

        worlds = self._sample_consistent_worlds(my_seat, hand, history, dealer, vuln)
        if not worlds:
            self.last_explanation = base_exp
            return cands[0], base_exp

        bundle_k = ga.DealBundle.from_deals(worlds, compute_dd=True, device=self.device)
        K = bundle_k.num_boards
        my_side_is_ns = (my_seat.value % 2) == 0

        # Evaluate each candidate call across all K consistent worlds via BatchedAuctionEnv rollout
        cand_scores_ns: List[torch.Tensor] = []
        for cand_call in cands:
            env = ga.BatchedAuctionEnv(bundle_k)
            env.passes_since_last_np = torch.zeros(K, dtype=torch.long, device=self.device)
            for past_c in history[:19]:
                c_code = ga.CALL_TO_IDX.get(str(past_c), ga.IDX_PASS)
                env.step(torch.full((K,), c_code, dtype=torch.long, device=self.device))
            cand_code = ga.CALL_TO_IDX.get(str(cand_call), ga.IDX_PASS)
            env.step(torch.full((K,), cand_code, dtype=torch.long, device=self.device))

            # Roll out remaining auction under self.t_net
            for _ in range(max(0, 20 - len(history) - 1)):
                if bool(env.done.all().item()):
                    break
                X_r, seat_r = env.build_features()
                lmask_r = env.legal_mask(seat_r)
                _, next_calls = self.t_net.call_scores(X_r, lmask_r)
                env.step(next_calls)

            ns_sc = env.terminal_ns_scores()
            my_sc = ns_sc if my_side_is_ns else -ns_sc
            cand_scores_ns.append(my_sc)

        base_sc = cand_scores_ns[0]
        best_idx = 0
        best_mean_imp = 0.0
        best_t_stat = 0.0

        for m_i in range(1, len(cands)):
            diff_pts = cand_scores_ns[m_i] - base_sc
            imp_vec = ga.points_to_imps_tensor(diff_pts).to(torch.float32)
            mean_imp = float(imp_vec.mean().item())
            sd_imp = float(imp_vec.std(unbiased=True).item()) if K > 1 else 0.0
            se_imp = sd_imp / math.sqrt(K) if K > 0 else 0.0
            t_val = (mean_imp / se_imp) if se_imp > 1e-5 else (10.0 if mean_imp > 0 else 0.0)

            if mean_imp >= self.min_imp_margin and t_val >= self.min_t_stat and mean_imp > best_mean_imp:
                best_idx = m_i
                best_mean_imp = mean_imp
                best_t_stat = t_val

        chosen_call = cands[best_idx]
        if best_idx == 0:
            base_exp.value_est_imps = 0.0
            self.last_explanation = base_exp
            return chosen_call, base_exp

        # Construct 100% explainable BidExplanation for the Single-Dummy Search override
        feats = BridgeFeatures.extract_all(hand, list(history), my_seat, dealer, vuln)
        chosen_str = str(chosen_call)
        chosen_code = ga.CALL_TO_IDX.get(chosen_str, ga.IDX_PASS)
        sd_exp = BidExplanation(
            call_idx=chosen_code,
            call_str=chosen_str,
            rule_idx=base_exp.rule_idx,
            rule_id=f"BAYES_SD_{chosen_str}_OVER_{base_exp.rule_id}",
            priority=max(960.0, base_exp.priority + 50.0),
            conditions=list(base_exp.conditions)
            + [
                AtomTrace(
                    atom_idx=-1,
                    feature="sd_rollout_ev_imp",
                    op=">=",
                    threshold=round(self.min_imp_margin, 2),
                    actual_value=round(best_mean_imp, 2),
                    satisfied=True,
                ),
                AtomTrace(
                    atom_idx=-2,
                    feature="sd_rollout_t_stat",
                    op=">=",
                    threshold=round(self.min_t_stat, 2),
                    actual_value=round(best_t_stat, 2),
                    satisfied=True,
                ),
            ],
            vetoed_rules=list(base_exp.vetoed_rules),
            partner_hcp_est=float(feats.get("seq_partner_hcp_min", 0)),
            value_est_imps=best_mean_imp,
        )
        self.last_explanation = sd_exp
        return chosen_call, sd_exp

    def actions(
        self,
        hand: Hand,
        history: List[Call],
        my_seat: Seat = Seat.SOUTH,
        dealer: Seat = Seat.NORTH,
        vuln: int = 0,
    ) -> List[Call]:
        """Return single-element list `[chosen_call]` so `BiddingArena` / `PIDMEngine`
        executes `BayesianSingleDummyBidder`'s exact decision without random override.
        """
        call, _ = self.decide_with_explanation(hand, history, my_seat, dealer, vuln)
        return [call]

    def best_call(
        self,
        hand: Hand,
        history: List[Call],
        my_seat: Seat = Seat.SOUTH,
        dealer: Seat = Seat.NORTH,
        vuln: int = 0,
    ) -> Call:
        call, _ = self.decide_with_explanation(hand, history, my_seat, dealer, vuln)
        return call
