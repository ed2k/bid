#!/usr/bin/env python3
"""Build a Stratified Competitive-Slam & Preempt Training Bundle (`data/colab_bundle_r5_strat.pt`).

Layout (10,000 boards total):
  - Train [0..4999]:
      * 2,500 uniform random boards (from `data/colab_bundle_10k.pt` [0..2499])
      * 1,250 slam-zone boards (exact DD tricks >= 12 in some strain)
      * 1,250 competitive / preempt / two-suiter boards (weak-2/3 6+ card suit with 5-10 HCP,
        5-5 two-suiter, or competitive both-sides >= 18 HCP)
  - Val   [5000..7499]: 2,500 unbiased uniform random boards (exact slice from `colab_bundle_10k.pt`)
  - Test  [7500..9999]: 2,500 unbiased uniform random boards (exact slice from `colab_bundle_10k.pt`)
"""
from __future__ import annotations

import argparse
import os
import random
import sys
import time
from typing import List

import torch

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
if os.path.join(REPO, "src") not in sys.path:
    sys.path.insert(0, os.path.join(REPO, "src"))
if os.path.join(REPO, "research") not in sys.path:
    sys.path.insert(0, os.path.join(REPO, "research"))

import gpu_arena as ga
from gpu_evolve_dsl import slice_bundle
from bid.models import Card, Hand, Rank, Seat, Suit
from bid.sampling import Deal
from bid.scoring import Vulnerability


def _concat_bundles(bundles: List[ga.DealBundle]) -> ga.DealBundle:
    return ga.DealBundle(
        hand_features=torch.cat([b.hand_features for b in bundles], dim=0),
        dealers=torch.cat([b.dealers for b in bundles], dim=0),
        vulns=torch.cat([b.vulns for b in bundles], dim=0),
        dd_tricks=torch.cat([b.dd_tricks for b in bundles], dim=0),
        suit_lengths=torch.cat([b.suit_lengths for b in bundles], dim=0),
        suit_has_king=torch.cat([b.suit_has_king for b in bundles], dim=0),
        suit_has_queen=torch.cat([b.suit_has_queen for b in bundles], dim=0),
        suit_stopper_q=torch.cat([b.suit_stopper_q for b in bundles], dim=0),
        ace_counts=torch.cat([b.ace_counts for b in bundles], dim=0),
        suit_intermediates=torch.cat([b.suit_intermediates for b in bundles], dim=0),
    )


def _random_deal(rng: random.Random, idx: int) -> Deal:
    deck = [Card(su, rk) for su in Suit for rk in Rank]
    rng.shuffle(deck)
    hands = {
        Seat.NORTH: Hand(deck[0:13]),
        Seat.EAST: Hand(deck[13:26]),
        Seat.SOUTH: Hand(deck[26:39]),
        Seat.WEST: Hand(deck[39:52]),
    }
    dealer = Seat(idx % 4)
    vuln = [Vulnerability.NONE, Vulnerability.NS, Vulnerability.EW, Vulnerability.BOTH][idx % 4]
    return Deal(hands=hands, dealer=dealer, vuln=vuln)


def _is_slam_candidate(deal: Deal) -> bool:
    ns_hcp = deal.hands[Seat.NORTH].hcp + deal.hands[Seat.SOUTH].hcp
    ew_hcp = deal.hands[Seat.EAST].hcp + deal.hands[Seat.WEST].hcp
    if max(ns_hcp, ew_hcp) >= 30:
        return True
    if max(ns_hcp, ew_hcp) >= 27:
        for side in ((Seat.NORTH, Seat.SOUTH), (Seat.EAST, Seat.WEST)):
            for su in Suit:
                if len(deal.hands[side[0]].by_suit.get(su, [])) + len(deal.hands[side[1]].by_suit.get(su, [])) >= 10:
                    return True
    return False


def _is_competitive_or_preempt(deal: Deal) -> bool:
    ns_hcp = deal.hands[Seat.NORTH].hcp + deal.hands[Seat.SOUTH].hcp
    ew_hcp = deal.hands[Seat.EAST].hcp + deal.hands[Seat.WEST].hcp
    has_preempt_or_2suiter = False
    for s in Seat:
        h = deal.hands[s]
        lens = sorted([len(h.by_suit.get(su, [])) for su in Suit], reverse=True)
        if lens[0] >= 6 and 5 <= h.hcp <= 10:
            has_preempt_or_2suiter = True
            break
        if lens[0] >= 5 and lens[1] >= 5 and h.hcp >= 7:
            has_preempt_or_2suiter = True
            break
    if has_preempt_or_2suiter:
        return True
    return (ns_hcp >= 18 and ew_hcp >= 18) and any(
        max(len(deal.hands[s].by_suit.get(su, [])) for su in Suit) >= 6 for s in Seat
    )


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--base-bundle", default="data/colab_bundle_10k.pt")
    ap.add_argument("--out", default="data/colab_bundle_r5_strat.pt")
    ap.add_argument("--n-random", type=int, default=2500)
    ap.add_argument("--n-slam", type=int, default=1250)
    ap.add_argument("--n-comp", type=int, default=1250)
    ap.add_argument("--seed", type=int, default=5050)
    args = ap.parse_args()

    t0 = time.perf_counter()
    print(f"Loading base bundle {args.base_bundle}...")
    base = ga.DealBundle.load(args.base_bundle, device="cpu")
    assert base.num_boards >= 10000, f"Expected >= 10000 boards, got {base.num_boards}"

    # 1. Unbiased slices from base bundle
    tr_rand = slice_bundle(base, torch.arange(0, args.n_random))
    val_unbiased = slice_bundle(base, torch.arange(5000, 7500))
    te_unbiased = slice_bundle(base, torch.arange(7500, 10000))

    # Reuse existing slam-zone boards from train half [0..4999] first
    tr_half = slice_bundle(base, torch.arange(0, 5000))
    slam_mask_existing = tr_half.dd_tricks.amax(dim=(1, 2)) >= 12
    slam_idx_existing = torch.where(slam_mask_existing)[0]
    slam_bundles: List[ga.DealBundle] = []
    n_slam_got = 0
    if int(slam_idx_existing.numel()) > 0:
        take = min(args.n_slam, int(slam_idx_existing.numel()))
        slam_bundles.append(slice_bundle(tr_half, slam_idx_existing[:take]))
        n_slam_got += take
    print(f"Reused {n_slam_got} slam-zone boards from base train half.")

    rng = random.Random(args.seed)
    deal_counter = 0

    # Generate additional slam-zone boards (exact DD >= 12)
    while n_slam_got < args.n_slam:
        need = args.n_slam - n_slam_got
        batch_cands: List[Deal] = []
        target_batch = min(max(need * 3, 256), 1200)
        while len(batch_cands) < target_batch:
            d = _random_deal(rng, deal_counter)
            deal_counter += 1
            if _is_slam_candidate(d):
                batch_cands.append(d)
        b_cand = ga.DealBundle.from_deals(batch_cands, compute_dd=True, device="cpu")
        ok = torch.where(b_cand.dd_tricks.amax(dim=(1, 2)) >= 12)[0]
        if int(ok.numel()) > 0:
            take = min(need, int(ok.numel()))
            slam_bundles.append(slice_bundle(b_cand, ok[:take]))
            n_slam_got += take
        print(f"  Slam-zone progress: {n_slam_got}/{args.n_slam} ({time.perf_counter() - t0:.1f}s)")

    # Generate competitive / preempt / two-suiter boards
    comp_deals: List[Deal] = []
    while len(comp_deals) < args.n_comp:
        d = _random_deal(rng, deal_counter)
        deal_counter += 1
        if _is_competitive_or_preempt(d):
            comp_deals.append(d)
    comp_bundle = ga.DealBundle.from_deals(comp_deals, compute_dd=True, device="cpu")
    print(f"Built {comp_bundle.num_boards} competitive/preempt boards ({time.perf_counter() - t0:.1f}s)")

    train_full = _concat_bundles([tr_rand] + slam_bundles + [comp_bundle])
    # Deterministic shuffle of train split [0..4999]
    gen = torch.Generator().manual_seed(args.seed)
    perm = torch.randperm(train_full.num_boards, generator=gen)
    train_full = slice_bundle(train_full, perm)

    final_bundle = _concat_bundles([train_full, val_unbiased, te_unbiased])
    final_bundle.save(args.out)

    tr_slam_rate = float((train_full.dd_tricks.amax(dim=(1, 2)) >= 12).to(torch.float32).mean().item())
    va_slam_rate = float((val_unbiased.dd_tricks.amax(dim=(1, 2)) >= 12).to(torch.float32).mean().item())
    print(
        f"Saved {final_bundle.num_boards} boards ({ga.NUM_FEATURES} features) -> {args.out} "
        f"in {time.perf_counter() - t0:.1f}s | "
        f"Train slam-rate={100*tr_slam_rate:.1f}%, Val slam-rate={100*va_slam_rate:.1f}%"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
