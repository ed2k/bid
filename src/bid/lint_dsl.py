#!/usr/bin/env python3
"""
lint_dsl.py — static checks for DecisionNet DSL files.

Catches the duplicate/contradiction class of bugs that quietly accumulated
in improved_system.dsl (24 identical NO_D_WITH_MAJOR_HEA blocks, squared
negative rules):

  * duplicate rule bodies (same id/call/conditions/priority/negative)
  * a rule_id reused with different bodies
  * contradicted conditions inside one rule (hcp >= 15 + hcp <= 14, == clashes)
  * priority shadowing (same call, superset conditions, >= priority)

Usage:
  python3 -m bid.lint_dsl system/improved_system.dsl      # exit 1 on issues
  from bid.lint_dsl import lint_file                       # for tests
"""

import re
import sys
from collections import Counter
from typing import List, Tuple

from bid.eval_vs_dds import _split_conditions, parse_call, parse_condition

_BLOCK_HEAD = re.compile(r"^RULE\s+(.+?):$")
_ONE_LINE = re.compile(r"^RULE\s+(\S+)\s+PRIORITY\s+(-?\d+)\s+ACTION\s+(\S+)\s+WHEN\s+(.+)$")


class RuleView:
    __slots__ = ("rule_id", "call", "priority", "is_negative", "conditions", "line")

    def __init__(self, rule_id, call, priority, is_negative, conditions, line):
        self.rule_id = rule_id
        self.call = call
        self.priority = priority
        self.is_negative = is_negative
        self.conditions = conditions          # list of (key, op, str(value))
        self.line = line

    @property
    def body(self):
        return (self.rule_id, str(self.call), self.priority, self.is_negative,
                tuple(self.conditions))

    @property
    def cond_set(self):
        return frozenset(self.conditions)

    def __repr__(self):
        return f"{self.rule_id}({self.call}, prio {self.priority})"


def parse_rules(text: str) -> List[RuleView]:
    """Parse both DSL formats *without* deduplication — lint must see the
    file exactly as written (the loader silently skips exact duplicates)."""
    lines = text.splitlines()
    rules: List[RuleView] = []
    i = 0
    while i < len(lines):
        stripped = lines[i].strip()
        if not stripped or stripped.startswith("#"):
            i += 1
            continue

        one = _ONE_LINE.match(stripped)
        if one:
            rid, prio, action, conds = one.groups()
            parsed = [parse_condition(c) for c in _split_conditions(conds)]
            rules.append(RuleView(
                rid, parse_call(action), int(prio), False,
                [(c.key, c.op, str(c.value)) for c in parsed],
                i + 1))
            i += 1
            continue

        block = _BLOCK_HEAD.match(stripped)
        if block:
            rid = block.group(1).strip()
            call = prio = None
            is_neg = False
            conds = []
            i += 1
            while i < len(lines):
                sub = lines[i].strip()
                if sub.startswith("RULE ") or sub.startswith("INTERSECTION"):
                    break
                if sub.startswith("CALL:"):
                    call = parse_call(sub.split("CALL:", 1)[1])
                elif sub.startswith("PRIORITY:"):
                    prio = int(sub.split("PRIORITY:", 1)[1].strip())
                elif sub.startswith("NEGATIVE:"):
                    is_neg = sub.split("NEGATIVE:", 1)[1].strip() == "True"
                elif sub.startswith("CONDITION:"):
                    c = parse_condition(sub.split("CONDITION:", 1)[1])
                    conds.append((c.key, c.op, str(c.value)))
                i += 1
            if call is not None:
                rules.append(RuleView(rid, call, prio or 10, is_neg, conds, i + 1))
            continue
        i += 1
    return rules


def lint_rules(rules: List[RuleView]) -> Tuple[List[str], List[str]]:
    """Returns (issues, warnings).  Issues are hard defects (duplicates,
    contradictions, shadowing); warnings are informational (a rule_id
    legitimately carrying several distinct negative-rule variants)."""
    issues: List[str] = []
    warnings: List[str] = []

    # 1. exact duplicate bodies
    body_counts = Counter(r.body for r in rules)
    for body, n in body_counts.items():
        if n > 1:
            issues.append(f"duplicate rule x{n}: {body[0]} -> {body[1]}")

    # 2. same id, different bodies (informational: distinct variants that
    # share an id — e.g. a family of negative rules with different guards)
    by_id = {}
    for r in rules:
        by_id.setdefault(r.rule_id, []).append(r)
    for rid, group in by_id.items():
        if len(group) > 1 and len({r.body for r in group}) > 1:
            warnings.append(f"rule id reused with different bodies: {rid} "
                            f"({len(group)} variants)")

    # 3. contradicted conditions inside one rule
    for r in rules:
        by_key = {}
        for key, op, val in r.conditions:
            by_key.setdefault(key, []).append((op, val))
        for key, checks in by_key.items():
            gte = [float(v) for op, v in checks if op == ">=" and _is_num(v)]
            lte = [float(v) for op, v in checks if op == "<=" and _is_num(v)]
            if gte and lte and min(lte) < max(gte):
                issues.append(f"contradicted conditions in {r.rule_id}: "
                              f"{key} >= {max(gte):g} with {key} <= {min(lte):g}")
            eqs = {v for op, v in checks if op == "=="}
            if len(eqs) > 1:
                issues.append(f"contradicted conditions in {r.rule_id}: "
                              f"{key} == multiple values {sorted(eqs)}")
            for op, v in checks:
                if op == "==" and _is_num(v):
                    fv = float(v)
                    if gte and fv < max(gte):
                        issues.append(f"contradicted conditions in {r.rule_id}: "
                                      f"{key} == {v} below {key} >= {max(gte):g}")
                    if lte and fv > min(lte):
                        issues.append(f"contradicted conditions in {r.rule_id}: "
                                      f"{key} == {v} above {key} <= {min(lte):g}")

    # 4. priority shadowing: same call; the weak rule's guard is a superset
    # of the strong rule's (so strong fires everywhere weak does) and its
    # priority is not higher — the weak rule can never win the ordering
    ordered = sorted(rules, key=lambda r: -r.priority)
    for i, strong in enumerate(ordered):
        for weak in ordered[i + 1:]:
            if strong.call != weak.call or strong.body == weak.body:
                continue
            if weak.cond_set >= strong.cond_set and strong.cond_set != weak.cond_set \
                    and strong.priority >= weak.priority:
                issues.append(f"rule {weak.rule_id} is shadowed by "
                              f"{strong.rule_id} (same call {weak.call}, "
                              f"subsumed conditions, prio {strong.priority} "
                              f">= {weak.priority})")
    return issues, warnings


def _is_num(v):
    try:
        float(v)
        return True
    except (TypeError, ValueError):
        return False


def lint_file(path: str) -> Tuple[List[str], List[str]]:
    with open(path) as f:
        return lint_rules(parse_rules(f.read()))


def main():
    import argparse
    ap = argparse.ArgumentParser(description="Lint a DecisionNet DSL file")
    ap.add_argument("paths", nargs="+", help="DSL files to check")
    args = ap.parse_args()

    failed = False
    for path in args.paths:
        issues, warnings = lint_file(path)
        print(f"{path}: {len(issues)} issue(s), {len(warnings)} warning(s)")
        for issue in issues:
            print(f"  - {issue}")
        for warning in warnings:
            print(f"  · {warning}")
        failed = failed or bool(issues)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
