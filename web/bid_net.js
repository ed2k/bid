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

        // candidate set with PASS fallback (port of decision_net.py step 2)
        let candidates;
        let fallbackPass = false;
        if (positive.length === 0) {
            candidates = [new Call(C.PASS)];
            fallbackPass = true;
        } else {
            candidates = positive.filter(c => !negative.some(n => n.equals(c)));
            if (candidates.length === 0) {
                candidates = [new Call(C.PASS)];
                fallbackPass = true;
            }
        }

        // intersection refinement (only RESOLVED_CALL classifiers exist in DSL)
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

        // legality filter (exact port of decision_net.py step 4)
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

        const legal = [];
        const illegal = [];
        for (const c of candidates) {
            let ok = false;
            if (c.type === C.PASS) ok = true;
            else if (c.type === C.DOUBLE) ok = xOk;
            else if (c.type === C.REDOUBLE) ok = xxOk;
            else if (c.type === C.BID) {
                ok = lastBid === null ||
                    c.level > lastBid.level ||
                    (c.level === lastBid.level && c.strain > lastBid.strain);
            }
            (ok ? legal : illegal).push(c);
        }
        if (legal.length === 0) legal.push(new Call(C.PASS));

        // stable ordering for deterministic display/selection
        const byStr = (a, b) => callOrderKey(a) < callOrderKey(b) ? -1 :
            callOrderKey(a) > callOrderKey(b) ? 1 : 0;
        legal.sort(byStr);
        illegal.sort(byStr);

        return {
            features, ruleResults,
            candidates: candidates.slice().sort(byStr),
            legal, illegal,
            fallbackPass, intersectionApplied, xOk, xxOk,
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

    api.Net = {explain, actions, autoSelect, conditionResult};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
