/**
 * bid_net.js — JS port of src/bid/decision_net.py DecisionNet evaluation.
 *
 * actions() reproduces decision_net.py's semantics exactly: rule matching,
 * negative rules, PASS fallback, RESOLVED_CALL intersection refinement, and
 * the double/redouble + bid-legality filter.  explain() runs the identical
 * code path while recording per-rule, per-condition results so the review UI
 * can show WHY the candidate set is what it is.
 */
(function (api) {
    'use strict';

    const C = api.CallType;
    const Call = api.Call;
    const Features = api.Features;

    function conditionResult(cond, features) {
        const present = Object.prototype.hasOwnProperty.call(features, cond.key);
        if (!present) {
            return {cond, ok: false, actual: undefined, missing: true};
        }
        const v = features[cond.key];
        const val = cond.value;
        let ok = false;
        switch (cond.op) {
            case '==': ok = v === val; break;
            case '!=': ok = v !== val; break;
            case '>=': ok = v >= val; break;
            case '<=': ok = v <= val; break;
            case '>': ok = v > val; break;
            case '<': ok = v < val; break;
            case 'in': ok = Array.isArray(val) ? val.indexOf(v) >= 0 : String(val).indexOf(String(v)) >= 0; break;
            case 'not_in': ok = Array.isArray(val) ? val.indexOf(v) < 0 : String(val).indexOf(String(v)) < 0; break;
        }
        return {cond, ok, actual: v, missing: false};
    }

    function ruleMatches(rule, features, collect) {
        const results = [];
        let ok = true;
        for (const cond of rule.conditions) {
            const r = conditionResult(cond, features);
            if (collect) results.push(r);
            if (!r.ok) { ok = false; if (!collect) break; }
        }
        return {matched: ok, conditionResults: results};
    }

    function callOrderKey(call) {
        return call.toString();
    }

    /**
     * Core evaluation with explanation. Returns:
     * { features, ruleResults: [{rule, matched, conditionResults}],
     *   candidates, legal, fallbackPass, intersectionApplied,
     *   xOk, xxOk, illegal }
     */
    /** Bridge-legality context for a seat about to call: shared by
     *  bid_net.explain and the student engine's constrained choice. */
    function legalityContext(history, mySeat, dealer) {
        let lastBid = null, lastNp = null;
        for (let i = 0; i < history.length; i++) {
            const call = history[i];
            if (call.type === C.BID) lastBid = call;
            if (call.type !== C.PASS) lastNp = {index: i, call};
        }
        let xOk = false, xxOk = false;
        if (lastNp) {
            const {index, call} = lastNp;
            const seatOfLc = (dealer + index) % 4;
            const partnerSeat = api.Seat.partner(mySeat);
            const oppOfMe = seatOfLc !== mySeat && seatOfLc !== partnerSeat;
            if (call.type === C.BID) {
                xOk = oppOfMe;
            } else if (call.type === C.DOUBLE && oppOfMe) {
                let j = index - 1;
                while (j >= 0) {
                    const pc = history[j];
                    if (pc.type !== C.PASS) {
                        const psSeat = (dealer + j) % 4;
                        if (pc.type === C.BID && (psSeat === mySeat || psSeat === partnerSeat)) {
                            xxOk = true;
                        }
                        break;
                    }
                    j--;
                }
            }
        }
        const isLegal = c => {
            if (c.type === C.PASS) return true;
            if (c.type === C.DOUBLE) return xOk;
            if (c.type === C.REDOUBLE) return xxOk;
            return lastBid === null ||
                c.level > lastBid.level ||
                (c.level === lastBid.level && c.strain > lastBid.strain);
        };
        return {lastBid, xOk, xxOk, isLegal};
    }

    function explain(net, hand, history, mySeat, dealer, vuln) {
        const features = Features.extractAll(hand, history, mySeat, dealer, vuln);

        const ruleResults = [];
        const positive = [];
        const negative = [];
        const matchedIds = [];

        for (const rule of net.rules) {
            const res = ruleMatches(rule, features, true);
            ruleResults.push({rule, matched: res.matched, conditionResults: res.conditionResults});
            if (res.matched) {
                if (rule.isNegative) negative.push(rule.call);
                else {
                    positive.push(rule.call);
                    matchedIds.push(rule.ruleId);
                }
            }
        }

        // candidate set with PASS fallback (port of decision_net.py step 2);
        // per-call max rule priority — Python orders φ(s) by priority, so
        // candidates here sort by (-priority, call string) to stay in parity
        const prioByCall = new Map();
        let candidates;
        let fallbackPass = false;
        if (positive.length === 0) {
            candidates = [new Call(C.PASS)];
            fallbackPass = true;
        } else {
            const surviving = positive.filter(c => !negative.some(n => n.equals(c)));
            if (surviving.length === 0) {
                candidates = [new Call(C.PASS)];
                fallbackPass = true;
            } else {
                candidates = surviving;
            }
        }
        if (!fallbackPass) {
            for (const rr of ruleResults) {
                if (!rr.matched || rr.rule.isNegative) continue;
                const key = rr.rule.call.toString();
                const prev = prioByCall.get(key);
                prioByCall.set(key, prev === undefined ? rr.rule.priority
                    : Math.max(prev, rr.rule.priority));
            }
            candidates.sort((a, b) => {
                const pa = prioByCall.get(a.toString()) || 0;
                const pb = prioByCall.get(b.toString()) || 0;
                if (pa !== pb) return pb - pa;
                return callOrderKey(a) < callOrderKey(b) ? -1 : 1;
            });
        }

        // intersection refinement (attached ID3 refinements first, then
        // DSL RESOLVED_CALL intersections — mirrors learner.py attach order)
        let refinementApplied = null;
        if (matchedIds.length > 1 && net.refinements) {
            const exact = matchedIds.slice().sort().join('^');
            let fn = net.refinements[exact];
            if (!fn) {
                for (const key of Object.keys(net.refinements)) {
                    const ids = key.split('^');
                    if (ids.every(id => matchedIds.indexOf(id) >= 0)) { fn = net.refinements[key]; break; }
                }
            }
            if (fn) {
                const predicted = fn(features);
                const match = candidates.find(c => c.equals(predicted));
                if (match) {
                    candidates = [match];
                    refinementApplied = exact;
                }
            }
        }
        let intersectionApplied = null;
        if (matchedIds.length > 1) {
            const exact = matchedIds.slice().sort().join('^');
            if (net.intersections[exact]) {
                const forced = net.intersections[exact];
                candidates = [forced];
                intersectionApplied = exact;
            } else {
                for (const key of Object.keys(net.intersections)) {
                    const ids = key.split('^');
                    if (ids.every(id => matchedIds.indexOf(id) >= 0)) {
                        candidates = [net.intersections[key]];
                        intersectionApplied = key;
                        break;
                    }
                }
            }
        }

        // legality filter (port of decision_net.py step 4)
        const legality = legalityContext(history, mySeat, dealer);
        const {xOk, xxOk} = legality;

        const legal = [];
        const illegal = [];
        for (const c of candidates) {
            (legality.isLegal(c) ? legal : illegal).push(c);
        }
        if (legal.length === 0) legal.push(new Call(C.PASS));

        // deterministic ordering: priority desc, then call string (Python parity)
        const byPriority = (a, b) => {
            const pa = prioByCall.get(a.toString()) || 0;
            const pb = prioByCall.get(b.toString()) || 0;
            if (pa !== pb) return pb - pa;
            return callOrderKey(a) < callOrderKey(b) ? -1 : 1;
        };
        legal.sort(byPriority);
        illegal.sort(byPriority);

        return {
            features, ruleResults,
            candidates: candidates.slice(),
            legal, illegal,
            fallbackPass, intersectionApplied, refinementApplied, xOk, xxOk,
            matchedIds
        };
    }

    /** Port of DecisionNet.actions: returns only the legal candidate calls. */
    function actions(net, hand, history, mySeat, dealer, vuln) {
        return explain(net, hand, history, mySeat, dealer, vuln).legal;
    }

    /**
     * Deterministic auto-selection used by the review UI's "auto" mode.
     * This is an APPROXIMATION of the Python PIDM search (world sampling +
     * DDS evaluation): it picks the legal call supported by the
     * highest-priority matched rule; PASS if nothing matched.
     */
    function autoSelect(net, explanation) {
        if (explanation.legal.length === 1) return explanation.legal[0];
        let best = null, bestPrio = -Infinity;
        for (const rr of explanation.ruleResults) {
            if (!rr.matched || rr.rule.isNegative) continue;
            const legalCall = explanation.legal.find(c => c.equals(rr.rule.call));
            if (!legalCall) continue;
            if (rr.rule.priority > bestPrio ||
                (rr.rule.priority === bestPrio && best &&
                 callOrderKey(legalCall) < callOrderKey(best))) {
                best = legalCall;
                bestPrio = rr.rule.priority;
            }
        }
        return best || new Call(C.PASS);
    }

    api.Net = {explain, actions, autoSelect, conditionResult, legalityContext};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
