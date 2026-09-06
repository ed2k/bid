/**
 * features.js — JS port of src/bid/features.py BridgeFeatures.
 *
 * Only the feature subset used by the DSL rule conditions and the review UI
 * is ported, but every ported key computes exactly like Python (same values,
 * same "key absent" behaviour) so rules evaluate identically.  Cross-validated
 * against the feature dictionaries recorded in data/traces/traces.jsonl by
 * tests/web/engine_test.mjs.
 */
(function (api) {
    'use strict';

    const C = api.CallType;
    const SUIT_KEYS = api.SUIT_KEYS;   // ['spades','hearts','diamonds','clubs']
    const SUIT_FEATURE_PREFIX = {spades: 's', hearts: 'h', diamonds: 'd', clubs: 'c'};
    const SUIT_BY_STRAIN = ['clubs', 'diamonds', 'hearts', 'spades', null];

    // ---- hand features ------------------------------------------------------

    function extractHandFeatures(hand) {
        const f = {};
        const lens = SUIT_KEYS.map(k => hand.length(k));

        f['hcp'] = hand.hcp();
        f['major_hcp'] = hand.suitHcp('hearts') + hand.suitHcp('spades');
        f['minor_hcp'] = hand.suitHcp('clubs') + hand.suitHcp('diamonds');
        f['spade_hcp'] = hand.suitHcp('spades');
        f['heart_hcp'] = hand.suitHcp('hearts');
        f['diamond_hcp'] = hand.suitHcp('diamonds');
        f['club_hcp'] = hand.suitHcp('clubs');

        f['spade_len'] = lens[0];
        f['heart_len'] = lens[1];
        f['diamond_len'] = lens[2];
        f['club_len'] = lens[3];

        const sorted = lens.slice().sort((a, b) => b - a);
        f['longest_suit_len'] = sorted[0];
        f['second_longest_len'] = sorted[1];
        f['third_longest_len'] = sorted[2];
        f['shortest_suit_len'] = sorted[3];
        f['shape_pattern'] = sorted.join('');

        f['is_balanced'] = hand.isBalanced();
        f['is_semi_balanced'] = f['is_balanced'] ||
            (sorted[0] === 5 && sorted[1] === 4 && sorted[2] === 2 && sorted[3] === 2) ||
            (sorted[0] === 6 && sorted[1] === 3 && sorted[2] === 2 && sorted[3] === 2);
        f['is_unbalanced'] = !f['is_semi_balanced'];

        let voids = 0, singletons = 0, doubletons = 0;
        for (const L of lens) {
            if (L === 0) voids++;
            else if (L === 1) singletons++;
            else if (L === 2) doubletons++;
        }
        f['void_count'] = voids;
        f['singleton_count'] = singletons;
        f['doubleton_count'] = doubletons;
        f['has_void'] = voids > 0;
        f['has_singleton'] = singletons > 0;

        f['controls'] = hand.controls();
        f['ace_count'] = hand.countRank(14);
        f['king_count'] = hand.countRank(13);
        f['queen_count'] = hand.countRank(12);
        f['jack_count'] = hand.countRank(11);
        f['keycard_count_1430'] = f['ace_count'];

        for (const k of SUIT_KEYS) {
            const pre = SUIT_FEATURE_PREFIX[k];
            const len = hand.length(k);
            const hasAce = hand.hasRank(k, 14), hasKing = hand.hasRank(k, 13),
                hasQueen = hand.hasRank(k, 12), hasJack = hand.hasRank(k, 11),
                hasTen = hand.hasRank(k, 10);
            f[pre + '_has_ace'] = hasAce;
            f[pre + '_has_king'] = hasKing;
            f[pre + '_has_queen'] = hasQueen;
            f[pre + '_has_jack'] = hasJack;
            f[pre + '_has_ten'] = hasTen;
            const top2 = (hasAce ? 1 : 0) + (hasKing ? 1 : 0);
            f[pre + '_top2_honors'] = top2;
            f[pre + '_top3_honors'] = top2 + (hasQueen ? 1 : 0);

            let stopper = 0;
            if (hasAce) stopper = 2;
            else if (hasKing && len >= 2) stopper = 2;
            else if (hasQueen && len >= 3) stopper = 1;
            else if (hasJack && hasTen && len >= 3) stopper = 1;
            f[pre + '_stopper'] = stopper;
        }

        // GIB total points (models.py Hand.total_points): HCP + redistribution
        // points (void 3 / singleton 2 / doubleton 1) minus 1 per short suit
        // (length < 3) holding an honor.
        let distPoints = 0, penalty = 0;
        for (const k of SUIT_KEYS) {
            const len = hand.length(k);
            if (len === 0) distPoints += 3;
            else if (len === 1) distPoints += 2;
            else if (len === 2) distPoints += 1;
            if (len < 3 && (hand.hasRank(k, 14) || hand.hasRank(k, 13) ||
                            hand.hasRank(k, 12) || hand.hasRank(k, 11))) {
                penalty += 1;
            }
        }
        f['total_points'] = f['hcp'] + distPoints - penalty;

        // Losing Trick Count (features.py): per suit — void 0; singleton 1
        // without the ace; doubleton 1 each missing A/K; 3+ 1 each missing A/K/Q.
        let ltc = 0;
        for (const k of SUIT_KEYS) {
            const len = hand.length(k);
            if (len === 0) continue;
            const hasAce = hand.hasRank(k, 14), hasKing = hand.hasRank(k, 13),
                hasQueen = hand.hasRank(k, 12);
            if (len === 1) {
                if (!hasAce) ltc += 1;
            } else if (len === 2) {
                if (!hasAce) ltc += 1;
                if (!hasKing) ltc += 1;
            } else {
                if (!hasAce) ltc += 1;
                if (!hasKing) ltc += 1;
                if (!hasQueen) ltc += 1;
            }
        }
        f['losing_trick_count'] = ltc;

        // Quick Tricks (features.py): AK=2, AQ=1.5, A=1, KQ=1, K+guarded=0.5.
        let quickTricks = 0;
        for (const k of SUIT_KEYS) {
            const len = hand.length(k);
            const hasAce = hand.hasRank(k, 14), hasKing = hand.hasRank(k, 13),
                hasQueen = hand.hasRank(k, 12);
            if (hasAce && hasKing) quickTricks += 2.0;
            else if (hasAce && hasQueen) quickTricks += 1.5;
            else if (hasAce) quickTricks += 1.0;
            else if (hasKing && hasQueen) quickTricks += 1.0;
            else if (hasKing && len >= 2) quickTricks += 0.5;
        }
        f['quick_tricks'] = quickTricks;
        return f;
    }

    // ---- auction features ---------------------------------------------------

    function extractAuctionFeatures(history, mySeat, dealer, vuln, hand) {
        const f = {};
        const partnerSeat = api.Seat.partner(mySeat);
        const opp1 = (mySeat + 1) % 4;
        const opp2 = (mySeat + 3) % 4;

        f['auction_len'] = history.length;
        f['my_seat'] = api.SEAT_LETTERS[mySeat];                 // str(Seat) -> 'N'
        f['is_vulnerable'] = api.Vulnerability.isVulnerable(vuln, mySeat);
        f['partner_vulnerable'] = api.Vulnerability.isVulnerable(vuln, partnerSeat);

        // auction state walk (bids_by_seat collects EVERY call, passes included)
        let lastBid = null, lastBidSeat = null;
        let passesSinceLastBid = 0;
        let curr = dealer;
        const bidsBySeat = {0: [], 1: [], 2: [], 3: []};
        for (let i = 0; i < history.length; i++) {
            const call = history[i];
            bidsBySeat[curr].push(call);
            if (call.type === C.BID) {
                lastBid = call;
                lastBidSeat = curr;
                passesSinceLastBid = 0;
            } else if (call.type === C.PASS) {
                if (lastBid !== null) passesSinceLastBid++;
            }
            curr = (curr + 1) % 4;
        }

        f['is_opening'] = (lastBid === null);
        f['passes_since_last_bid'] = passesSinceLastBid;
        f['last_bid_level'] = lastBid ? lastBid.level : 0;
        f['last_bid_strain'] = (lastBid && lastBid.strain !== null)
            ? api.STRAIN_NAMES[lastBid.strain] : 'NONE';
        f['last_bid_seat'] = lastBidSeat !== null ? api.SEAT_LETTERS[lastBidSeat] : 'NONE';

        const partnerBids = bidsBySeat[partnerSeat];
        f['partner_opened'] = partnerBids.length > 0 &&
            partnerBids[0].type === C.BID &&
            (lastBidSeat === partnerSeat ||
             (history.length > 0 && history[0].equals(partnerBids[0])));
        f['partner_last_call'] = partnerBids.length
            ? partnerBids[partnerBids.length - 1].toString() : 'NONE';

        const myBids = bidsBySeat[mySeat];
        f['my_last_call'] = myBids.length ? myBids[myBids.length - 1].toString() : 'NONE';

        const oppBidsAll = bidsBySeat[opp1].concat(bidsBySeat[opp2]);
        f['opponents_bid'] = oppBidsAll.some(c => c.type === C.BID);

        let lastOppBid = null;
        for (let i = history.length - 1; i >= 0; i--) {
            const callerSeat = (dealer + i) % 4;
            if ((callerSeat === opp1 || callerSeat === opp2) && history[i].type === C.BID) {
                lastOppBid = history[i];
                break;
            }
        }
        f['opp_last_call'] = lastOppBid ? lastOppBid.toString() : 'NONE';
        f['opp_contract_level'] = lastOppBid ? lastOppBid.level : 0;
        f['opp_is_in_game'] = false;
        if (lastOppBid) {
            const lvl = lastOppBid.level, st = lastOppBid.strain;
            if ((lvl >= 4 && (st === api.Strain.HEARTS || st === api.Strain.SPADES)) ||
                (lvl >= 3 && st === api.Strain.NT) || lvl >= 5) {
                f['opp_is_in_game'] = true;
            }
        }

        const myVuln = api.Vulnerability.isVulnerable(vuln, mySeat);
        const oppVuln = api.Vulnerability.isVulnerable(vuln, opp1);
        f['is_favorable_vuln'] = (!myVuln) && oppVuln;
        f['is_equal_non_vuln'] = (!myVuln) && (!oppVuln);
        f['is_unfavorable_vuln'] = myVuln && (!oppVuln);
        f['vuln_pressure'] = f['is_favorable_vuln'] ? 'favorable'
            : (f['is_unfavorable_vuln'] ? 'unfavorable' : 'equal');

        // seat-correct competition modeling
        const seatOf = i => (dealer + i) % 4;
        const oppBidCalls = [];
        const mySideBidCalls = [];
        for (let i = 0; i < history.length; i++) {
            const s = seatOf(i);
            if (history[i].type !== C.BID) continue;
            if (s === opp1 || s === opp2) oppBidCalls.push(history[i]);
            else if (s === mySeat || s === partnerSeat) mySideBidCalls.push(history[i]);
        }
        f['opp_bid_count'] = oppBidCalls.length;
        f['my_side_bid_count'] = mySideBidCalls.length;
        f['competition_level'] = history.filter(c => c.type !== C.PASS).length;

        let altitude = 0;
        for (const c of history) if (c.type === C.BID && c.level > altitude) altitude = c.level;
        f['auction_altitude'] = altitude;
        f['auction_contested'] = oppBidCalls.length > 0 && mySideBidCalls.length > 0;

        const oppFirst = oppBidCalls.length ? oppBidCalls[0] : null;
        f['opp_preempted'] = !!(oppFirst &&
            (oppFirst.level >= 3 ||
             (oppFirst.level === 2 && oppFirst.strain !== null &&
              oppFirst.strain !== api.Strain.NT && history.length <= 4)));
        f['opp_first_bid_level'] = oppFirst ? oppFirst.level : 0;

        if (f['opp_preempted']) f['opp_strength_class'] = 'weak';
        else if (oppFirst !== null && oppFirst.level >= 4) f['opp_strength_class'] = 'strong';
        else f['opp_strength_class'] = 'unknown';

        const oppSuits = new Set(oppBidCalls
            .filter(c => c.strain !== null && c.strain !== api.Strain.NT)
            .map(c => c.strain));
        const myOwnSuits = new Set(myBids
            .filter(c => c.type === C.BID && c.strain !== null && c.strain !== api.Strain.NT)
            .map(c => c.strain));
        const partnerSuitSet = new Set(partnerBids
            .filter(c => c.type === C.BID && c.strain !== null && c.strain !== api.Strain.NT)
            .map(c => c.strain));
        f['opp_fit_shown'] = oppSuits.size >= 2;
        f['our_fit_shown'] = false;
        for (const s of myOwnSuits) if (partnerSuitSet.has(s)) f['our_fit_shown'] = true;

        f['partner_rebid'] = partnerBids.length >= 2;

        let partnerLastBid = null;
        for (let i = partnerBids.length - 1; i >= 0; i--) {
            const c = partnerBids[i];
            if (c.type === C.BID && c.strain !== null && c.strain !== api.Strain.NT) {
                partnerLastBid = c;
                break;
            }
        }
        if (partnerLastBid !== null) {
            f['partner_last_bid_strain'] = api.STRAIN_NAMES[partnerLastBid.strain];
            f['support_in_partner_suit'] = hand
                ? hand.length(SUIT_BY_STRAIN[partnerLastBid.strain])
                : -1;
        } else {
            f['partner_last_bid_strain'] = 'NONE';
            f['support_in_partner_suit'] = -1;
        }

        // NT stopper quality in opponents' bid suits
        const stopperQ = suitKey => {
            const cards = hand.suits[suitKey];
            if (hand.hasRank(suitKey, 14)) return 2.0;
            if (hand.hasRank(suitKey, 13) && cards.length >= 2) return 1.0;
            if (hand.hasRank(suitKey, 12) && cards.length >= 3) return 0.5;
            return 0.0;
        };
        const oppSuitKeys = [...oppSuits].map(s => SUIT_BY_STRAIN[s]).filter(Boolean);
        if (oppSuitKeys.length > 0 && hand) {
            f['opp_suit_stoppers'] = Math.max(...oppSuitKeys.map(stopperQ));
        } else {
            f['opp_suit_stoppers'] = 2.0;
        }
        f['has_stopper'] = f['opp_suit_stoppers'] > 0;

        f['is_balancing'] = passesSinceLastBid === 2 &&
            (lastBidSeat === opp1 || lastBidSeat === opp2);
        f['is_competitive'] = f['opponents_bid'] && !f['is_opening'];

        return f;
    }

    function extractAll(hand, history, mySeat, dealer, vuln) {
        return Object.assign(
            extractHandFeatures(hand),
            extractAuctionFeatures(history, mySeat, dealer, vuln, hand));
    }

    api.Features = {
        extractHandFeatures,
        extractAuctionFeatures,
        extractAll
    };
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
