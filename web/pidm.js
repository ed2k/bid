/**
 * pidm.js — PIDM-lite: Partial-Information Decision Making for the browser
 * (compact port of the pidm.py decide loop).
 *
 * For an ambiguous decision (|φ(s)| > 1): sample K completions of the hidden
 * hands (bidder's cards fixed — uniform completion, the lite version of
 * RBMBMC filtering), force each candidate call, play the auction out with
 * the deterministic priority picks, and score every resulting contract with
 * exact double-dummy tricks (WASM DDS) from the decider's side.  The
 * candidate with the best mean score wins.
 *
 * Requires the WASM DDS module.  Opt-in: it costs ~0.5 s per ambiguous
 * decision versus ~0 ms for the priority pick.
 */
(function (api) {
    'use strict';

    function sampleCompletion(deal, fixedSeat, rng) {
        const pool = [];
        for (let s = 0; s < 4; s++) {
            if (s === fixedSeat) continue;
            for (const k of api.SUIT_KEYS) {
                for (const r of deal.hands[s].suits[k]) pool.push({suit: k, rank: r});
            }
        }
        for (let i = pool.length - 1; i > 0; i--) {
            const j = Math.floor(rng() * (i + 1));
            const t = pool[i]; pool[i] = pool[j]; pool[j] = t;
        }
        const hands = [null, null, null, null];
        hands[fixedSeat] = deal.hands[fixedSeat];
        let p = 0;
        for (let s = 0; s < 4; s++) {
            if (s === fixedSeat) continue;
            const h = new api.Hand();
            for (let i = 0; i < 13; i++) h.suits[pool[p + i].suit].push(pool[p + i].rank);
            for (const k of api.SUIT_KEYS) h.suits[k].sort((a, b) => b - a);
            hands[s] = h;
            p += 13;
        }
        return new api.Deal(deal.dealer, deal.vuln, hands);
    }

    /**
     * Pick the best legal call for the runner's current decision.
     * Returns {call, scores: {bid: meanScore}, worlds}.
     */
    function pick(mod, runner, numWorlds, seed, onProgress) {
        const seat = runner.currentSeat();
        const exp = runner.explain(seat);
        if (exp.legal.length === 1) {
            return {call: exp.legal[0], scores: null, worlds: 0, trivial: true};
        }
        const rng = api.mulberry32(seed === undefined ? 11 : seed);
        const candidates = exp.legal.slice(0, 4);
        const partner = api.Seat.partner(seat);
        const scores = {};
        for (const c of candidates) scores[c.toString()] = {sum: 0, n: 0};

        for (let w = 0; w < (numWorlds || 4); w++) {
            const world = sampleCompletion(runner.deal, seat, rng);
            for (const cand of candidates) {
                const clone = new api.Auction.AuctionRunner(world, runner.models, 'manual');
                while (clone.currentSeat() !== seat && !clone.isOver()) clone.stepAuto();
                if (clone.currentSeat() !== seat) continue;
                const cexp = clone.explain(seat);
                const legal = cexp.legal.find(l => l.equals(cand));
                clone.applyCall(legal || new api.Call(api.CallType.PASS), cexp, true);
                clone.runOut();
                const contract = clone.contract();
                if (!contract) {
                    scores[cand.toString()].sum += 0;
                    scores[cand.toString()].n += 1;
                    continue;
                }
                const table = mod.calcDDTablePBN(world.toPBN()).resTable;
                const tricks = table[['S', 'H', 'D', 'C', 'NT']
                    .indexOf(['C', 'D', 'H', 'S', 'NT'][contract.strain])][contract.declarer];
                const declarerSide = contract.declarer % 2;
                const mySide = seat % 2;
                let sc = api.SDS.contractScore(contract.level,
                    api.STRAIN_NAMES[contract.strain], contract.doubled,
                    api.Vulnerability.isVulnerable(world.vuln, contract.declarer),
                    tricks);
                if (declarerSide !== mySide) sc = -sc;   // opponents bought it
                scores[cand.toString()].sum += sc;
                scores[cand.toString()].n += 1;
            }
            if (onProgress) onProgress(w + 1, numWorlds);
        }
        let best = null, bestScore = -Infinity;
        for (const cand of candidates) {
            const s = scores[cand.toString()];
            const mean = s.n ? s.sum / s.n : -Infinity;
            s.mean = mean;
            if (mean > bestScore) { bestScore = mean; best = cand; }
        }
        return {call: best || exp.legal[0], scores, worlds: numWorlds || 4,
            trivial: false};
    }

    api.PIDM = {pick, sampleCompletion};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
