/**
 * belief.js — JS port of Engine.estimate_deal (src/bid/engine.py) plus the
 * HandConstraints.lower_bounds / cap_above machinery (src/bid/constraints.py).
 *
 * Walks the auction and maintains per-seat constraint estimates: a bid
 * intersects the matched rule's constraints; a PASS carves out the declined
 * single-binding lower-bound rules (passing over "1C: 16+" bounds hcp <= 15).
 * Legacy-engine only (DecisionNet rules carry no constraint ranges).
 */
(function (api) {
    'use strict';

    const SUITS = api.SUIT_KEYS;

    function empty() {
        return {
            hcp: {min: 0, max: 37}, majorHcp: {min: 0, max: 37},
            tp: {min: 0, max: 50}, controls: {min: 0, max: 12},
            len: {spades: {min: 0, max: 13}, hearts: {min: 0, max: 13},
                  diamonds: {min: 0, max: 13}, clubs: {min: 0, max: 13}},
        };
    }

    function intersect(a, b) {
        const out = empty();
        for (const key of ['hcp', 'majorHcp', 'tp', 'controls']) {
            out[key] = {min: Math.max(a[key].min, b[key].min),
                        max: Math.min(a[key].max, b[key].max)};
        }
        for (const k of SUITS) {
            out.len[k] = {min: Math.max(a.len[k].min, b.len[k].min),
                          max: Math.min(a.len[k].max, b.len[k].max)};
        }
        return out;
    }

    function lowerBounds(c) {
        const out = [];
        if (c.hcp.min > 0 && c.hcp.max >= 37) out.push(['hcp', c.hcp.min]);
        if (c.majorHcp.min > 0 && c.majorHcp.max >= 37) out.push(['majorHcp', c.majorHcp.min]);
        if (c.tp.min > 0 && c.tp.max >= 50) out.push(['tp', c.tp.min]);
        if (c.controls.min > 0 && c.controls.max >= 12) out.push(['controls', c.controls.min]);
        for (const k of SUITS) {
            if (c.len[k].min > 0 && c.len[k].max >= 13) out.push([k, c.len[k].min]);
        }
        return out;
    }

    function capAbove(c, field, newMax) {
        const out = empty();
        for (const key of ['hcp', 'majorHcp', 'tp', 'controls']) {
            out[key] = {min: c[key].min,
                        max: key === field ? Math.min(c[key].max, newMax) : c[key].max};
        }
        for (const k of SUITS) {
            out.len[k] = {min: c.len[k].min,
                          max: k === field ? Math.min(c.len[k].max, newMax) : c.len[k].max};
        }
        return out;
    }

    function format(c) {
        const bits = [`hcp ${c.hcp.min}-${c.hcp.max}`];
        for (const k of SUITS) {
            if (c.len[k].min > 0 || c.len[k].max < 13) {
                bits.push(`${k[0].toUpperCase()} ${c.len[k].min}-${c.len[k].max}`);
            }
        }
        if (c.controls.min > 0 || c.controls.max < 12) {
            bits.push(`ctrl ${c.controls.min}-${c.controls.max}`);
        }
        return bits.join(', ');
    }

    const SUIT_OF_LETTER = {S: 'spades', H: 'hearts', D: 'diamonds', C: 'clubs'};

    /** Declined lower-bound carving for one PASS (Engine._infer_pass port). */
    function inferPass(rules, historyBefore, current) {
        let lastBid = null;
        for (const c of historyBefore) {
            if (c.type === api.CallType.BID) lastBid = c;
        }
        for (const rule of rules) {
            if (rule.call.type !== api.CallType.BID) continue;
            if (!api.Legacy.triggerFires(rule, historyBefore)) continue;
            if (lastBid) {
                const legal = rule.call.level > lastBid.level ||
                    (rule.call.level === lastBid.level &&
                     rule.call.strain > lastBid.strain);
                if (!legal) continue;    // call unavailable; passing was forced
            }
            const binding = lowerBounds(rule.constraints);
            if (binding.length !== 1) continue;
            const [field, minv] = binding[0];
            current = capAbove(current, field, minv - 1);
        }
        return current;
    }

    /**
     * Port of Engine.estimate_deal for legacy systems.
     * Returns {seatValue: constraint} for all four seats, or null when the
     * engine is not legacy (DecisionNet rules carry no constraint ranges).
     */
    function estimateDeal(system, history, dealer) {
        if (!system || system.rules === undefined) return null;
        const estimates = {0: empty(), 1: empty(), 2: empty(), 3: empty()};
        let seat = dealer;
        for (let i = 0; i < history.length; i++) {
            const call = history[i];
            const before = history.slice(0, i);
            const matching = system.rules.filter(
                r => api.Legacy.triggerFires(r, before) && r.call.equals(call));
            if (matching.length) {
                estimates[seat] = intersect(estimates[seat], matching[0].constraints);
            } else if (call.type === api.CallType.PASS) {
                estimates[seat] = inferPass(system.rules, before, estimates[seat]);
            }
            seat = (seat + 1) % 4;
        }
        return estimates;
    }

    api.Belief = {empty, intersect, lowerBounds, capAbove, inferPass,
        estimateDeal, format};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
