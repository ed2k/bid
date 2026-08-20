import os
import sys
import argparse
from bid.pipeline import run_continuous_improvement_pipeline
from bid.optimizer import SystemOptimizer

def main():
    parser = argparse.ArgumentParser(description="Bid: Autonomous Self-Improving Contract Bridge AI")
    parser.add_argument("--tournament", action="store_true", help="Run World Championship Tournament between all competing systems")
    parser.add_argument("--boards", type=int, default=50, help="Number of boards for tournament (default: 50)")
    parser.add_argument("--iterations", type=int, default=20, help="Max continuous improvement iterations (default: 20)")
    parser.add_argument("--duration", type=float, default=60.0, help="Target duration in seconds (default: 60.0s)")
    parser.add_argument("--states", type=int, default=8, help="States to sample per round (default: 8)")
    parser.add_argument("--deals", type=int, default=25, help="Benchmark test deals (default: 25)")
    args = parser.parse_args()

    if args.tournament:
        opt = SystemOptimizer()
        opt.run_world_championship_tournament(num_boards=args.boards)
    else:
        run_continuous_improvement_pipeline(
            num_iterations=args.iterations,
            duration_seconds=args.duration,
            states_per_iteration=args.states,
            num_test_deals=args.deals
        )

if __name__ == "__main__":
    main()
