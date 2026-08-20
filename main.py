import os
import sys
import argparse
from bid.pipeline import run_continuous_improvement_pipeline

def main():
    parser = argparse.ArgumentParser(description="Bid: Autonomous Self-Improving Contract Bridge AI")
    parser.add_argument("--iterations", type=int, default=3, help="Number of continuous improvement iterations (default: 3)")
    parser.add_argument("--states", type=int, default=8, help="States to sample per round (default: 8)")
    parser.add_argument("--deals", type=int, default=20, help="Benchmark test deals (default: 20)")
    args = parser.parse_args()

    run_continuous_improvement_pipeline(
        num_iterations=args.iterations,
        states_per_iteration=args.states,
        num_test_deals=args.deals
    )

if __name__ == "__main__":
    main()
