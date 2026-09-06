/**
 * diagnostics.js — JS port of src/bid/diagnostics.py ParDiagnosticEngine:
 * classifies a completed auction against the double-dummy par and the full
 * DD table (NS-centric, matching the Python engine's conventions).
 *
 * Flaw types: OPTIMAL_PAR, MISSED_GAME, MISSED_SLAM, SOFT_DEFENSE,
 * OVERBID_DOWN, MISSED_PENALTY_DOUBLE (via takeout-pass structural check),
 * TAKEOUT_PASS, LUCKY_MASKED_MISS (folded into the structural slam path,
 * as in Python).
 */
(function (api) {
    'use strict';

    const FLAW = {
        OPTIMAL_PAR: 'OPTIMAL_PAR',
        MISSED_GAME: 'MISSED_GAME',
        MISSED_SLAM: 'MISSED_SLAM',
        SOFT_DEFENSE: 'SOFT_DEFENSE',
        OVERBID_DOWN: 'OVERBID_DOWN',
        TAKEOUT_PASS: 'TAKEOUT_PASS',
    };
    api.DIAG_FLAW = FLAW;

    // DD-table row letters and per-strain NS maxima
    const ROWS = ['S', 'H', 'D', 'C', 'NT'];
    const rowOf = {S: 0, H: 1, D: 2, C: 3, NT: 4};

    function nsMax(ddTable, strainLetter) {
        const row = ddTable[rowOf[strainLetter]];
        return Math.max(row[0], row[2]);   // N, S
    }

    /** Port of _ns_missed_potential: points NS left vs best makable game/slam. */
    function missedPotential(SDSScore, ddTable, contract, actualScore) {
        const games = [['S', 4], ['H', 4], ['NT', 3], ['D', 5], ['C', 5]];
        let best = 0;
        for (const [letter, gameLvl] of games) {
            const tricks = nsMax(ddTable, letter);
            if (tricks < gameLvl + 6) continue;
            const lvl = Math.min(7, Math.max(gameLvl, tricks - 6));
            const made = SDSScore(lvl, letter, 0, false, tricks);
            if (contract && contract.level >= lvl &&
                api.STRAIN_NAMES[contract.strain] === letter) continue;
            best = Math.max(best, made - actualScore);
        }
        return best;
    }

    /**
     * Classify one completed auction.  Inputs:
     *   deal        BidWeb.Deal (all four hands)
     *   contract    {level, strain, declarer, doubled} or null (passed out)
     *   actualScore NS-perspective score of the auction's own contract
     *   parScore    NS-perspective par score
     *   parContract par contract string (display)
     *   ddTable     5x4 resTable (rows S,H,D,C,NT; cols N,E,S,W)
     *   history     array of Call
     *   vuln        0..3
     */
    function diagnose(deal, contract, actualScore, parScore, parContract,
                      ddTable, history, vuln) {
        const regret = actualScore - parScore;
        const maxNsS = nsMax(ddTable, 'S'), maxNsH = nsMax(ddTable, 'H');
        const maxNsNT = nsMax(ddTable, 'NT');
        const maxNsMinor = Math.max(nsMax(ddTable, 'C'), nsMax(ddTable, 'D'));
        const declIsNS = contract && (contract.declarer === 0 || contract.declarer === 2);
        const declIsEW = contract && (contract.declarer === 1 || contract.declarer === 3);
        const nsCanSlam = Math.max(maxNsS, maxNsH, maxNsNT, maxNsMinor) >= 12;
        const nsCanGame = maxNsS >= 10 || maxNsH >= 10 || maxNsNT >= 9 || maxNsMinor >= 11;
        const score = api.SDS.contractScore;

        const mk = (flaw, severity, advice) =>
            ({flaw, severity: Math.max(0, severity), advice, regret,
              parScore, parContract});

        const potential = () => missedPotential(score, ddTable, contract, actualScore);

        // declarer tricks for the ACTUAL contract from the DD table
        const actualTricks = contract
            ? ddTable[rowOf[api.STRAIN_NAMES[contract.strain]]][contract.declarer]
            : null;

        // ---- structural checks first (score can mask auction-quality flaws) --

        // A. passing partner's takeout double with real values
        for (let t = 1; t < history.length; t++) {
            if (history[t].type !== api.CallType.PASS) continue;
            const player = (deal.dealer + t) % 4;
            const feats = api.Features.extractAll(deal.hands[player],
                history.slice(0, t), player, deal.dealer, vuln);
            if (feats['partner_last_call'] === 'X' &&
                (feats['hcp'] || 0) >= 10) {
                return mk(FLAW.TAKEOUT_PASS,
                    Math.max(Math.abs(Math.min(regret, 0)), potential(), 300),
                    `${api.SEAT_NAMES[player]} passed partner's takeout double holding ` +
                    `${feats['hcp']} HCP. Add advancer rules: lift with 5+ suit or ` +
                    `bid 2NT with stoppers.`);
            }
        }

        // B. missed slam regardless of score
        if (nsCanSlam && contract && contract.level < 6) {
            const target = maxNsS >= 12 ? '6S' : maxNsH >= 12 ? '6H'
                : maxNsNT >= 12 ? '6NT' : '6m';
            return mk(FLAW.MISSED_SLAM,
                Math.max(Math.abs(Math.min(regret, 0)), potential()),
                `Missed ${target} despite score masking. Add Blackwood 4NT / cuebids ` +
                `on 20+ combined HCP and controls.`);
        }

        // C. missed game regardless of score
        if (nsCanGame && contract && declIsNS && contract.level <= 2) {
            const target = maxNsS >= 10 ? '4S' : maxNsH >= 10 ? '4H'
                : maxNsNT >= 9 ? '3NT' : '5m';
            return mk(FLAW.MISSED_GAME,
                Math.max(Math.abs(Math.min(regret, 0)), potential()),
                `Underbid Game (${target} makable) despite score masking. ` +
                `Add game-forcing continuations & acceptance rules.`);
        }

        // D. own side doubled and set 2+
        if (contract && declIsNS && contract.doubled >= 1 &&
            actualTricks !== null && actualTricks <= contract.level + 4) {
            return mk(FLAW.OVERBID_DOWN,
                Math.abs(Math.min(regret, -50)) + 100,
                'Own doubled contract set 2+. Tighten competitive minimums; do not ' +
                'double for penalties without defensive tricks.');
        }

        // E. optimal
        if (actualScore >= parScore - 10 && regret >= -10) {
            return mk(FLAW.OPTIMAL_PAR, 0,
                'Optimal auction reached. No correction required.');
        }

        const loss = Math.abs(regret);

        // 1. score-driven missed slam
        if (nsCanSlam && contract && contract.level < 6) {
            let target = maxNsS >= 12 ? '6S' : maxNsH >= 12 ? '6H' : '6NT';
            if (maxNsS >= 13 || maxNsH >= 13 || maxNsNT >= 13) {
                target = '7NT / 7M Grand Slam';
            }
            return mk(FLAW.MISSED_SLAM, loss,
                `Missed ${target}. Add Blackwood 4NT / Splinter cuebids to explore ` +
                `slam on 20+ combined HCP and controls.`);
        }

        // 2. missed game
        if (nsCanGame && contract && contract.level <= 2 && declIsNS) {
            const target = maxNsS >= 10 ? '4S' : maxNsH >= 10 ? '4H' : '3NT';
            return mk(FLAW.MISSED_GAME, loss,
                `Underbid Game. System stopped in partscore while ${target} was ` +
                `makable. Add Game Forcing 2/1 continuations & Opener Maximum ` +
                `Acceptance.`);
        }

        // 3. soft defense / failure to compete
        if (declIsEW || !contract) {
            return mk(FLAW.SOFT_DEFENSE, loss,
                'Defense too soft. Opponents stole the contract or the board was ' +
                'passed out. Add Balancing 1NT/Overcalls, Takeout Doubles, and ' +
                'Competitive Overcalls.');
        }

        // 4. overbid down
        if (contract && declIsNS &&
            actualTricks !== null && actualTricks < contract.level + 6) {
            return mk(FLAW.OVERBID_DOWN, loss,
                `Overbid contract down ${contract.level + 6 - actualTricks} tricks. ` +
                `Tighten minimum opening requirements and enforce safe partscore ` +
                `signoffs.`);
        }

        return mk(FLAW.SOFT_DEFENSE, loss,
            'Suboptimal auction trajectory. Refine competitive bidding rules.');
    }

    api.Diagnostics = {diagnose, missedPotential, nsMax};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
