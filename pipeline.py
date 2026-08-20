#!/usr/bin/env python3
import time
import argparse
from typing import List, Dict, Any
from bid.models import Hand, Seat, Call, CallType, Strain, Suit
from bid.decision_net import DecisionNet, DecisionNetRule, RuleCondition
from bid.sampling import Deal, PartialState, RBMBMCSampler
from bid.pidm import PIDMEngine
from bid.learner import DecisionNetLearner, ID3DecisionTree
from bid.cotrain import CoTrainer
from bid.experience import StratifiedDealGenerator, ExperienceBuffer, PrioritizedExperience
from bid.protocol import ConventionProtocol, ValueOfInformationEvaluator
from bid.invention import BidInventionEngine

def run_continuous_improvement_pipeline(num_iterations: int = 3,
                                       states_per_iteration: int = 8,
                                       num_test_deals: int = 20,
                                       sample_size: int = 3,
                                       lookahead_depth: int = 2) -> Dict[str, Any]:
    """
    Executes the multi-iteration continuous self-improvement pipeline:
    1. Active Ambiguity & Rare State Discovery
    2. Model-Conditioned RBMBMC + PIDM Teacher Tagging
    3. ID3 Local Exception Refinement
    4. Parallel Partner Co-Training & Model Exchange
    5. Protocol Synthesis & Value of Information (VOI)
    """
    print("=" * 70)
    print(" 🚀 STARTING CONTINUOUS SELF-IMPROVING BIDDING PIPELINE")
    print(f"    Iterations: {num_iterations} | States/Round: {states_per_iteration} | Test Deals: {num_test_deals}")
    print("=" * 70)

    # 1. Initialize Engine and Baseline Models
    engine = BidInventionEngine(sample_size=sample_size, max_lookahead_depth=lookahead_depth)
    models = engine.models
    fast_engine = PIDMEngine(sampler=RBMBMCSampler(sample_size=1, max_iterations=5, timeout_sec=0.05), max_lookahead_depth=1)
    cotrainer = CoTrainer(engine.pidm, models[Seat.NORTH], models[Seat.SOUTH], models[Seat.EAST], models[Seat.WEST])

    # 2. Generate Fixed Benchmark Deals for Tracking Progress
    print("\n📦 Generating evaluation benchmark deals...")
    benchmark_deals: List[Deal] = []
    # Mix of normal and stratified rare deals
    for _ in range(num_test_deals - 4):
        benchmark_deals.append(Deal.random_deal(dealer=Seat.NORTH))
    # Add rare-hand benchmark deals
    benchmark_deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, suit_stratum=(Suit.SPADES, 8)))
    benchmark_deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.NORTH, suit_stratum=(Suit.HEARTS, 8)))
    benchmark_deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, hcp_stratum=(20, 23)))
    benchmark_deals.append(StratifiedDealGenerator.generate_stratified_deal(Seat.NORTH, hcp_stratum=(0, 4)))

    # Evaluate Baseline
    t0 = time.time()
    baseline_score = cotrainer.evaluate_partnership(benchmark_deals, fast_engine)
    baseline_time = (time.time() - t0) * 1000 / len(benchmark_deals)

    print(f"📊 Baseline Partnership Avg Score: {baseline_score:+.1f} pts | Decision Latency: {baseline_time:.2f} ms/deal\n")

    history_log = []

    # 3. Multi-Iteration Improvement Loop
    for iteration in range(1, num_iterations + 1):
        iter_start = time.time()
        print("-" * 70)
        print(f"🔄 ITERATION {iteration}/{num_iterations}")
        print("-" * 70)

        # Stage 1: Active Discovery & Stratified Generation
        print("  [1/5] 🔍 Active State Discovery & Stratified Sampling...")
        discovered_states: List[PartialState] = []
        
        # A. Find ambiguous states where rules conflict (|φ(s)| > 1)
        ambiguous = cotrainer.learner.find_ambiguous_states(cotrainer.models[Seat.SOUTH], target_count=states_per_iteration // 2)
        discovered_states.extend(ambiguous)

        # B. Stratified rare hands to prevent blindspots
        rare_deal_1 = StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, suit_stratum=(Suit.SPADES, 8))
        rare_deal_2 = StratifiedDealGenerator.generate_stratified_deal(Seat.SOUTH, hcp_stratum=(21, 24))
        discovered_states.append(PartialState(Seat.SOUTH, rare_deal_1.hands[Seat.SOUTH], []))
        discovered_states.append(PartialState(Seat.SOUTH, rare_deal_2.hands[Seat.SOUTH], []))

        print(f"        -> Collected {len(discovered_states)} informative states (ambiguities + rare strata)")

        # Stage 2: Expensive Teacher Tagging (RBMBMC + PIDM)
        print("  [2/5] 🧠 Expensive PIDM Teacher Tagging (RBMBMC Sampling + Lookahead)...")
        t_tag_start = time.time()
        tagged_south = cotrainer.learner.tag_states(discovered_states, cotrainer.models)
        
        # Also tag North states
        north_states = cotrainer.learner.find_ambiguous_states(cotrainer.models[Seat.NORTH], target_count=len(discovered_states))
        for s in north_states: s.my_seat = Seat.NORTH
        tagged_north = cotrainer.learner.tag_states(north_states, cotrainer.models)
        
        tagging_time = time.time() - t_tag_start
        print(f"        -> Generated {len(tagged_south) + len(tagged_north)} labeled training examples in {tagging_time:.2f}s")

        # Stage 3: Speedup Learning & Local Intersection Refinement
        print("  [3/5] 🌲 ID3 Information Gain Refinement on Conflict Intersection Nodes...")
        cotrainer.learner.refine_decision_net(cotrainer.models[Seat.SOUTH], tagged_south)
        cotrainer.learner.refine_decision_net(cotrainer.models[Seat.NORTH], tagged_north)
        
        s_nodes = len(cotrainer.models[Seat.SOUTH].intersection_nodes)
        n_nodes = len(cotrainer.models[Seat.NORTH].intersection_nodes)
        print(f"        -> Attached local decision trees: South has {s_nodes} nodes, North has {n_nodes} nodes")

        # Stage 4: Partner Co-Training & Model Exchange
        print("  [4/5] 🤝 Parallel Co-Training & Partnership Model Exchange...")
        # Models are synchronized in the partnership
        engine.models = cotrainer.models

        # Stage 5: Protocol Synthesis & Value of Information (VOI)
        print("  [5/5] 📡 Evaluating Convention Protocols & Value of Information (VOI)...")
        stayman = ConventionProtocol.create_stayman()
        voi_eval = ValueOfInformationEvaluator(engine.pidm)
        sample_query_states = [PartialState(Seat.NORTH, Deal.random_deal().hands[Seat.NORTH], [Call(CallType.BID, 1, Strain.NT), Call(CallType.BID, 2, Strain.CLUBS)]) for _ in range(3)]
        voi_val = voi_eval.evaluate_voi(stayman.steps[0], sample_query_states, cotrainer.models)
        print(f"        -> Stayman Query VOI: +{voi_val:.2f} expected score gain")

        # Iteration Benchmark Evaluation
        t_eval = time.time()
        iter_score = cotrainer.evaluate_partnership(benchmark_deals, fast_engine)
        iter_latency = (time.time() - t_eval) * 1000 / len(benchmark_deals)
        iter_duration = time.time() - iter_start

        improvement = iter_score - baseline_score
        print(f"\n  📈 Iteration {iteration} Results:")
        print(f"     • Partnership Avg Score : {iter_score:+.1f} pts ({improvement:+.1f} pts vs baseline)")
        print(f"     • Decision Latency      : {iter_latency:.2f} ms/deal")
        print(f"     • Total Conflict Nodes  : {s_nodes + n_nodes}")
        print(f"     • Round Execution Time  : {iter_duration:.2f}s\n")

        history_log.append({
            "iteration": iteration,
            "score": iter_score,
            "improvement": improvement,
            "latency_ms": iter_latency,
            "conflict_nodes": s_nodes + n_nodes,
            "voi": voi_val
        })

    # Summary Report
    print("=" * 70)
    print(" 🏁 CONTINUOUS IMPROVEMENT SUMMARY")
    print("=" * 70)
    print(f" {'Iter':<6} | {'Avg Score':<12} | {'Improvement':<14} | {'Latency':<12} | {'Refined Nodes':<14}")
    print("-" * 70)
    print(f" {'Base':<6} | {baseline_score:<+12.1f} | {'0.0 pts':<14} | {baseline_time:<8.2f} ms | {'0':<14}")
    for h in history_log:
        print(f" {h['iteration']:<6} | {h['score']:<+12.1f} | {h['improvement']:<+10.1f} pts | {h['latency_ms']:<8.2f} ms | {h['conflict_nodes']:<14}")
    print("=" * 70)

    final_score = history_log[-1]["score"] if history_log else baseline_score
    print(f"🎉 Net Partnership Gain: {final_score - baseline_score:+.1f} points after {num_iterations} continuous iterations!\n")

    return {
        "baseline_score": baseline_score,
        "final_score": final_score,
        "history": history_log
    }

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Run Bid Continuous Self-Improving Pipeline")
    parser.add_argument("--iterations", type=int, default=3, help="Number of continuous improvement iterations (default: 3)")
    parser.add_argument("--states", type=int, default=8, help="States to sample per round (default: 8)")
    parser.add_argument("--deals", type=int, default=20, help="Benchmark test deals (default: 20)")
    args = parser.parse_args()

    run_continuous_improvement_pipeline(
        num_iterations=args.iterations,
        states_per_iteration=args.states,
        num_test_deals=args.deals
    )
