/**
 * system_dsl.js — JS port of the legacy bidding-system engine:
 * src/bid/translator.py (DSL parse) + src/bid/system.py (BiddingSystem) +
 * src/bid/constraints.py (HandConstraints).
 *
 * This is the SECOND engine in the repo (used by precision/blue_club/gib
 * style files): rules are `<TRIGGER> <BID>:` / `<seq> - <BID>:` headings with
 * HCP/TP/CONTROLS/LEN/SHAPE/ACES constraint fields, matched by
 * highest-priority-first over trigger(history) && constraints.matches(hand).
 *
 * Rule counts are cross-validated against Python's translator in
 * tests/web/engine_test.mjs (the exporter embeds python_rule_count).
 */
(function (api) {
    'use strict';

    const Call = api.Call;
    const SUIT_KEYS = api.SUIT_KEYS;                 // spades hearts diamonds clubs
    const SUIT_OF_LETTER = {S: 'spades', H: 'hearts', D: 'diamonds', C: 'clubs'};
    const STRAIN_OF = {C: 0, D: 1, H: 2, S: 3, NT: 4};

    function parseRange(text, defMin, defMax) {
        const s = String(text).trim();
        if (s.includes('-')) {
            const [a, b] = s.split('-');
            return {min: parseInt(a, 10), max: parseInt(b, 10)};
        }
        if (s.endsWith('+')) {
            return {min: parseInt(s.slice(0, -1), 10), max: defMax};
        }
        const v = parseInt(s, 10);
        return {min: v, max: v};
    }

    function newRuleData(bid, triggerType, sequence) {
        return {
            bid, triggerType, sequence,
            hcp: {min: 0, max: 37}, majorHcp: {min: 0, max: 37},
            tp: {min: 0, max: 50}, controls: {min: 0, max: 12},
            len: {spades: {min: 0, max: 13}, hearts: {min: 0, max: 13},
                  diamonds: {min: 0, max: 13}, clubs: {min: 0, max: 13}},
            balanced: null, aces: null, aceTopology: null,
            priorityBonus: 0, passedHand: null, partnerPassedHand: null,
            openerSeat: null, isCommon: false,
        };
    }

    /**
     * Parse a legacy DSL text into {name, rules}.  `# COMMON: <name>` marker
     * lines (inserted by the exporter for inlined convention files) mark all
     * following rules as common (overridable by system-specific rules),
     * matching translator.load_convention(is_common=True) semantics.
     */
    function parse(text, name) {
        const lines = String(text).split(/\r?\n/);
        const out = {name: name || 'LegacySystem', rules: []};
        let cur = null;
        let inConventionsBlock = false;
        let isCommon = false;

        const flush = () => {
            if (!cur) return;
            // translator._parse_call is case-insensitive ('Dbl', 'p', ...)
            const call = Call.parse(cur.bid.toUpperCase());
            let prio = 10 + cur.priorityBonus;
            if (cur.balanced === true) prio += 5;
            if (call.type === api.CallType.BID && call.level === 1 &&
                call.strain === api.Strain.NT) prio = 20;

            const steps = (cur.triggerType === 'SEQUENCE')
                ? cur.sequence.map(s => {
                    let item = s, direct = false;
                    if (item.startsWith('(') && item.endsWith(')')) {
                        direct = true;
                        item = item.slice(1, -1);
                    }
                    return {call: Call.parse(item.toUpperCase()), direct};
                })
                : null;

            out.rules.push({
                priority: prio,
                triggerType: cur.triggerType,
                sequence: cur.sequence.slice(),
                steps,
                call,
                description: `${cur.triggerType} ${cur.bid}`,
                isCommon,
                constraints: {
                    hcp: cur.hcp, majorHcp: cur.majorHcp, tp: cur.tp,
                    controls: cur.controls, len: cur.len,
                    balanced: cur.balanced, aces: cur.aces,
                    aceTopology: cur.aceTopology,
                },
                passedHand: cur.passedHand,
                partnerPassedHand: cur.partnerPassedHand,
                openerSeat: cur.openerSeat,
            });
            cur = null;
        };

        for (let raw of lines) {
            const line = raw.split('#')[0].trim();
            if (raw.trim().startsWith('# COMMON:')) { isCommon = true; continue; }
            if (!line) continue;

            if (line.toUpperCase() === 'CONVENTIONS:') {
                flush();
                inConventionsBlock = true;
                continue;
            }
            if (inConventionsBlock) {
                // convention file contents are inlined by the exporter; the
                // bare name list itself carries no rules
                if (line.endsWith(':') && !/^[0-9]/.test(line)) {
                    inConventionsBlock = false;
                }
                continue;
            }

            if (line.endsWith(':') && !/^(HCP|TP|CONTROLS|MAJOR_HCP|ACES|ACE_TOPOLOGY|SHAPE|BID_CLASS|CUEBID_TYPE|CUE_TARGET|FORCING|CONVENTION|PRIORITY_BONUS|PASSED_HAND|PARTNER_PASSED_HAND|OPENER_SEAT|LEN)/.test(line)) {
                flush();
                const heading = line.slice(0, -1);
                let triggerType, bid, sequence = [];
                if (heading.includes('-')) {
                    const parts = heading.split('-').map(p => p.trim());
                    triggerType = 'SEQUENCE';
                    bid = parts[parts.length - 1];
                    sequence = parts.slice(0, -1);
                } else {
                    const parts = heading.split(/\s+/);
                    triggerType = parts[0];
                    bid = parts[1];
                }
                cur = newRuleData(bid, triggerType, sequence);
                continue;
            }

            if (!cur) continue;
            if (line.startsWith('HCP:')) cur.hcp = parseRange(line.split(':')[1], 0, 37);
            else if (line.startsWith('MAJOR_HCP:')) cur.majorHcp = parseRange(line.split(':')[1], 0, 37);
            else if (line.startsWith('TP:')) cur.tp = parseRange(line.split(':')[1], 0, 50);
            else if (line.startsWith('CONTROLS:')) cur.controls = parseRange(line.split(':')[1], 0, 12);
            else if (line.startsWith('ACES:')) {
                cur.aces = line.split(':')[1].split(',').map(s => parseInt(s.trim(), 10));
            } else if (line.startsWith('ACE_TOPOLOGY:')) {
                cur.aceTopology = new Set([line.split(':')[1].trim()]);
            } else if (line.startsWith('SHAPE:')) {
                const v = line.split(':')[1].trim();
                cur.balanced = v === 'BALANCED' ? true : v === 'UNBALANCED' ? false : null;
            } else if (line.startsWith('PRIORITY_BONUS:')) {
                cur.priorityBonus = parseInt(line.split(':')[1].trim(), 10);
            } else if (line.startsWith('PASSED_HAND:')) {
                cur.passedHand = line.split(':')[1].trim().toUpperCase() === 'TRUE';
            } else if (line.startsWith('PARTNER_PASSED_HAND:')) {
                cur.partnerPassedHand = line.split(':')[1].trim().toUpperCase() === 'TRUE';
            } else if (line.startsWith('OPENER_SEAT:')) {
                const seats = new Set();
                const v = line.split(':')[1].trim();
                if (v.includes('1')) seats.add(0);
                if (v.includes('2')) seats.add(1);
                if (v.includes('3')) seats.add(2);
                if (v.includes('4')) seats.add(3);
                cur.openerSeat = seats;
            } else if (line.startsWith('LEN')) {
                const suitLetter = line.split(':')[0].trim().split(/\s+/)[1];
                const key = SUIT_OF_LETTER[suitLetter];
                if (key) cur.len[key] = parseRange(line.split(':')[1], 0, 13);
            }
            // BID_CLASS / CUEBID_TYPE / CUE_TARGET / FORCING / CONVENTION are
            // metadata in Python and carry no matching behaviour — ignored.
        }
        flush();

        // BiddingSystem.add_rule: system-specific rules override common rules
        // with identical (triggerType, sequence, call); keep priority-sorted.
        const rules = [];
        for (const rule of out.rules) {
            if (!rule.isCommon) {
                for (let i = rules.length - 1; i >= 0; i--) {
                    const r = rules[i];
                    if (r.isCommon && r.triggerType === rule.triggerType &&
                        r.sequence.join(' ') === rule.sequence.join(' ') &&
                        r.call.equals(rule.call)) {
                        rules.splice(i, 1);
                    }
                }
            }
            rules.push(rule);
        }
        rules.sort((a, b) => b.priority - a.priority);   // stable: ties keep order
        out.rules = rules;
        return out;
    }

    // ---- trigger (port of translator.trigger) --------------------------------

    function triggerFires(rule, history) {
        if (rule.passedHand !== null) {
            let isPassed;
            if (history.length < 4) isPassed = false;
            else isPassed = history[history.length % 4].type === api.CallType.PASS;
            if (isPassed !== rule.passedHand) return false;
        }
        if (rule.partnerPassedHand !== null) {
            const partnerSeat = (history.length + 2) % 4;
            let isPartnerPassed = false;
            if (history.length > partnerSeat) {
                isPartnerPassed = history[partnerSeat].type === api.CallType.PASS;
            }
            if (isPartnerPassed !== rule.partnerPassedHand) return false;
        }
        if (rule.openerSeat !== null) {
            let firstBidIdx = -1;
            for (let idx = 0; idx < history.length; idx++) {
                if (history[idx].type === api.CallType.BID) { firstBidIdx = idx; break; }
            }
            if (!rule.openerSeat.has(firstBidIdx)) return false;
        }

        if (rule.triggerType === 'OPEN') {
            return history.length === 0 ||
                (history.length < 4 && history.every(c => c.type === api.CallType.PASS));
        }

        if (rule.triggerType === 'SEQUENCE') {
            const steps = rule.steps;
            if (!history.length && !steps.length) return true;
            if (!history.length) return false;

            let histIdx = history.length - 1;
            let stepIdx = steps.length - 1;

            while (stepIdx >= 0) {
                if (histIdx < 0) return false;
                const step = steps[stepIdx];
                if (step.direct) {
                    if (!history[histIdx].equals(step.call)) return false;
                    histIdx--;
                } else {
                    let passFound = false;
                    while (histIdx >= 0 && history[histIdx].type === api.CallType.PASS) {
                        passFound = true;
                        histIdx--;
                    }
                    if (!passFound) return false;
                    if (histIdx < 0) return false;
                    if (!history[histIdx].equals(step.call)) return false;
                    histIdx--;
                }
                stepIdx--;
            }
            while (histIdx >= 0) {
                if (history[histIdx].type !== api.CallType.PASS) return false;
                histIdx--;
            }
            return true;
        }
        return false;   // RESPONSE etc. never fire in the Python engine either
    }

    // ---- constraints (port of HandConstraints.matches) ------------------------

    function aceTopology(hand) {
        const aceCount = hand.countRank(14);
        if (aceCount !== 2) return 'NONE';
        const aces = [];
        for (const k of SUIT_KEYS) if (hand.hasRank(k, 14)) aces.push(k);
        if (aces.length !== 2) return 'NONE';
        const isRed = k => k === 'hearts' || k === 'diamonds';
        const sameRank = isRed(aces[0]) === isRed(aces[1]);
        if (sameRank) return 'RANK';
        const bothBlack = aces.every(k => k === 'spades' || k === 'clubs');
        const bothRed = aces.every(isRed);
        if (bothBlack || bothRed) return 'COLOR';
        return 'MIXED';
    }

    function totalPoints(hand) {
        let dist = 0, penalty = 0;
        for (const k of SUIT_KEYS) {
            const len = hand.length(k);
            if (len === 0) dist += 3;
            else if (len === 1) dist += 2;
            else if (len === 2) dist += 1;
            if (len < 3 && (hand.hasRank(k, 14) || hand.hasRank(k, 13) ||
                            hand.hasRank(k, 12) || hand.hasRank(k, 11))) {
                penalty += 1;
            }
        }
        return hand.hcp() + dist - penalty;
    }

    function constraintsMatches(c, hand) {
        const hcp = hand.hcp();
        if (!(c.hcp.min <= hcp && hcp <= c.hcp.max)) return false;
        const majorHcp = hand.suitHcp('hearts') + hand.suitHcp('spades');
        if (!(c.majorHcp.min <= majorHcp && majorHcp <= c.majorHcp.max)) return false;
        const tp = totalPoints(hand);
        if (!(c.tp.min <= tp && tp <= c.tp.max)) return false;
        const controls = hand.controls();
        if (!(c.controls.min <= controls && controls <= c.controls.max)) return false;
        const aces = hand.countRank(14);
        if (c.aces !== null && !c.aces.includes(aces)) return false;
        if (c.aceTopology !== null && !c.aceTopology.has(aceTopology(hand))) return false;
        if (c.balanced !== null && hand.isBalanced() !== c.balanced) return false;
        for (const k of SUIT_KEYS) {
            const l = hand.length(k);
            if (!(c.len[k].min <= l && l <= c.len[k].max)) return false;
        }
        return true;
    }

    /** Per-check results for the review UI. */
    function constraintsDetail(c, hand) {
        const checks = [];
        const add = (label, ok, actual) => checks.push({label, ok, actual});
        const hcp = hand.hcp();
        add(`HCP ${c.hcp.min}-${c.hcp.max}`, c.hcp.min <= hcp && hcp <= c.hcp.max, hcp);
        if (c.majorHcp.min > 0 || c.majorHcp.max < 37) {
            const mh = hand.suitHcp('hearts') + hand.suitHcp('spades');
            add(`MAJOR_HCP ${c.majorHcp.min}-${c.majorHcp.max}`,
                c.majorHcp.min <= mh && mh <= c.majorHcp.max, mh);
        }
        if (c.tp.min > 0 || c.tp.max < 50) {
            const tp = totalPoints(hand);
            add(`TP ${c.tp.min}-${c.tp.max}`, c.tp.min <= tp && tp <= c.tp.max, tp);
        }
        if (c.controls.min > 0 || c.controls.max < 12) {
            const ct = hand.controls();
            add(`CONTROLS ${c.controls.min}-${c.controls.max}`,
                c.controls.min <= ct && ct <= c.controls.max, ct);
        }
        if (c.aces !== null) {
            const a = hand.countRank(14);
            add(`ACES [${c.aces.join(',')}]`, c.aces.includes(a), a);
        }
        if (c.aceTopology !== null) {
            const t = aceTopology(hand);
            add(`TOPOLOGY [${[...c.aceTopology].join(',')}]`,
                c.aceTopology.has(t), t);
        }
        if (c.balanced !== null) {
            const b = hand.isBalanced();
            add(`SHAPE ${c.balanced ? 'BALANCED' : 'UNBALANCED'}`, b === c.balanced, b);
        }
        for (const k of SUIT_KEYS) {
            const r = c.len[k];
            if (r.min > 0 || r.max < 13) {
                const l = hand.length(k);
                add(`LEN ${k[0].toUpperCase()} ${r.min}-${r.max}`,
                    r.min <= l && l <= r.max, l);
            }
        }
        return checks;
    }

    function ruleApplies(rule, history, hand) {
        return triggerFires(rule, history) && constraintsMatches(rule.constraints, hand);
    }

    /** All matching rules, priority order (BiddingSystem.get_bid takes [0]). */
    function appliedRules(system, history, hand) {
        return system.rules.filter(r => ruleApplies(r, history, hand));
    }

    /** Decision-inspector shape, parallel to bid_net.explain. */
    function explain(system, hand, history) {
        const features = api.Features.extractAll(hand, history, 2, 0, 0);
        const applied = appliedRules(system, history, hand);
        const chosen = applied.length ? applied[0] : null;
        const candidates = chosen ? [chosen.call] : [new Call(api.CallType.PASS)];
        return {
            kind: 'legacy',
            features,
            applied,
            chosen,
            candidates,
            legal: candidates.slice(),
            illegal: [],
            fallbackPass: !chosen,
            intersectionApplied: null,
            matchedIds: applied.map(r => r.description),
        };
    }

    api.Legacy = {parse, triggerFires, constraintsMatches, constraintsDetail,
        ruleApplies, appliedRules, explain, aceTopology, totalPoints};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
