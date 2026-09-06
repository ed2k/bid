/**
 * sds.js — JS port of src/bid/sds.py SDSScorer: Single-Dummy Solver scoring.
 *
 * Re-scores a played contract from the declarer partnership's TWO-HAND view
 * (declarer + dummy known, opponents hidden): sample `numWorlds` opponent
 * splits (viewer holdings preserved exactly, hand lengths preserved,
 * seeded shuffle), double-dummy solve each world with the WASM DDS, and
 * report P(make) / mean tricks / expected duplicate score.
 *
 * Duplicate scoring is an exact port of src/bid/scoring.py::score.
 */
(function (api) {
    'use strict';

    const TRICK_VAL = {C: 20, D: 20, H: 30, S: 30, N: 30};

    /** Exact port of scoring.py::score for an already-parsed contract. */
    function contractScore(level, strain /* 'C','D','H','S','NT' */, doubled /*0,1,2*/,
                           isVul, tricks) {
        const key = strain === 'NT' ? 'N' : strain;
        const target = 6 + level;
        if (tricks >= target) {
            let base = level * TRICK_VAL[key];
            if (strain === 'NT') base += 10;
            let bonus = 0;
            if (doubled === 2) { base *= 4; bonus += 100; }
            else if (doubled === 1) { base *= 2; bonus += 50; }
            bonus += base < 100 ? 50 : (isVul ? 500 : 300);
            if (level === 6) bonus += isVul ? 750 : 500;
            else if (level === 7) bonus += isVul ? 1500 : 1000;
            const nOver = tricks - target;
            let over;
            if (doubled === 2) over = nOver * (isVul ? 400 : 200);
            else if (doubled === 1) over = nOver * (isVul ? 200 : 100);
            else over = nOver * TRICK_VAL[key];
            return base + over + bonus;
        }
        const nUnder = target - tricks;
        let vals;
        if (isVul) {
            if (doubled === 2) vals = [400].concat(new Array(12).fill(600));
            else if (doubled === 1) vals = [200].concat(new Array(12).fill(300));
            else vals = new Array(13).fill(100);
        } else {
            if (doubled === 2) vals = [200, 400, 400].concat(new Array(10).fill(600));
            else if (doubled === 1) vals = [100, 200, 200].concat(new Array(10).fill(300));
            else vals = new Array(13).fill(50);
        }
        return -vals.slice(0, nUnder).reduce((a, b) => a + b, 0);
    }

    /**
     * PIMC analysis of `contract` ({level, strain, declarer, doubled}) on
     * `deal`, using `mod` (the WASM DDS api module).  Seeded → deterministic.
     * Returns {meanScore, pMake, meanTricks, tricks, needed, isVul, ddTricks}.
     */
    function analyze(mod, deal, contract, numWorlds, seed, cond) {
        const declarer = contract.declarer;
        const dummy = api.Seat.partner(declarer);
        const hidden = [0, 1, 2, 3].filter(s => s !== declarer && s !== dummy);
        const rng = api.mulberry32(seed === undefined ? 7 : seed);

        const strainName = api.STRAIN_NAMES[contract.strain];
        const strainLetter = strainName === 'NT' ? 'N' : strainName;
        const trumpIdx = {S: 0, H: 1, D: 2, C: 3, NT: 4}[strainLetter];
        const isVul = api.Vulnerability.isVulnerable(deal.vuln, declarer);
        const needed = contract.level + 6;
        const leader = (declarer + 1) % 4;   // opening leader, always a defender

        // hidden card pools per non-viewer seat
        const hiddenCards = hidden.map(seat => {
            const cards = [];
            for (const k of api.SUIT_KEYS) {
                for (const r of deal.hands[seat].suits[k]) cards.push({suit: k, rank: r});
            }
            return {seat, cards};
        });

        const handFromCards = cards => {
            const h = new api.Hand();
            for (const c of cards) h.suits[c.suit].push(c.rank);
            for (const k of api.SUIT_KEYS) h.suits[k].sort((a, b) => b - a);
            return h;
        };

        // build candidate worlds (optionally auction-conditioned: sample
        // conditionFactor x worlds and keep the most auction-consistent —
        // port of SDSScorer._select_consistent via calculate_inconsistency)
        const factor = cond && cond.factor > 0 ? cond.factor : 1;
        const candidatesW = [];
        for (let w = 0; w < numWorlds * factor; w++) {
            const pool = hiddenCards[0].cards.concat(hiddenCards[1].cards);
            for (let i = pool.length - 1; i > 0; i--) {
                const j = Math.floor(rng() * (i + 1));
                const t = pool[i]; pool[i] = pool[j]; pool[j] = t;
            }
            const hands = [null, null, null, null];
            hands[declarer] = deal.hands[declarer];
            hands[dummy] = deal.hands[dummy];
            hands[hiddenCards[0].seat] =
                handFromCards(pool.slice(0, hiddenCards[0].cards.length));
            hands[hiddenCards[1].seat] =
                handFromCards(pool.slice(hiddenCards[0].cards.length));
            const world = new api.Deal(deal.dealer, deal.vuln, hands);
            let inc = 0;
            if (cond && cond.history && cond.engineFor) {
                for (let t = 0; t < cond.history.length; t++) {
                    const call = cond.history[t];
                    const seatT = (deal.dealer + t) % 4;
                    const engine = cond.engineFor(seatT);
                    if (!engine) continue;
                    let legalSet;
                    if (engine.kind === 'legacy') {
                        const expL = api.Legacy.explain(engine.system,
                            world.hands[seatT], cond.history.slice(0, t));
                        legalSet = expL.legal;
                    } else if (engine.net) {
                        const expN = api.Net.explain(engine.net,
                            world.hands[seatT], cond.history.slice(0, t),
                            seatT, deal.dealer, deal.vuln);
                        legalSet = expN.legal;
                    } else continue;
                    if (!legalSet.some(c => c.equals(call))) inc++;
                }
            }
            candidatesW.push({world, inc});
        }
        candidatesW.sort((a, b) => a.inc - b.inc);
        const kept = candidatesW.slice(0, numWorlds);

        const tricks = [];
        for (const {world} of kept) {
            const res = mod.solveBoardPBN(world.toPBN(), trumpIdx, leader,
                [], [], -1, 1, 0, null);
            // the opening leader's side is always the defence
            tricks.push(13 - res.score[0]);
        }

        const meanTricks = tricks.reduce((a, b) => a + b, 0) / tricks.length;
        const makes = tricks.filter(t => t >= needed).length;
        const meanScore = tricks.reduce(
            (a, t) => a + contractScore(contract.level, strainLetter,
                contract.doubled, isVul, t), 0) / tricks.length;
        return {meanScore, pMake: makes / tricks.length, meanTricks,
            tricks, needed, isVul};
    }

    /** WBF IMP scale — exact port of scoring.py::diff_to_imps. */
    function diffToImps(diff) {
        const a = Math.abs(diff);
        if (a <= 10) return 0;
        if (a <= 40) return 1;
        if (a <= 80) return 2;
        if (a <= 120) return 3;
        if (a <= 160) return 4;
        if (a <= 210) return 5;
        if (a <= 260) return 6;
        if (a <= 310) return 7;
        if (a <= 360) return 8;
        if (a <= 420) return 9;
        if (a <= 490) return 10;
        if (a <= 590) return 11;
        if (a <= 740) return 12;
        if (a <= 890) return 13;
        if (a <= 1090) return 14;
        if (a <= 1290) return 15;
        if (a <= 1490) return 16;
        if (a <= 1740) return 17;
        if (a <= 1990) return 18;
        if (a <= 2240) return 19;
        if (a <= 2490) return 20;
        if (a <= 2990) return 21;
        if (a <= 3490) return 22;
        if (a <= 3990) return 23;
        return 24;
    }

    function scoreToImp(diff) {
        return diff >= 0 ? diffToImps(diff) : -diffToImps(diff);
    }

    api.SDS = {contractScore, analyze, diffToImps, scoreToImp};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
