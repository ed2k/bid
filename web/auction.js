/**
 * auction.js — auction driver for the Bid review UI.
 *
 * Ports PartialState.is_auction_over / get_contract (src/bid/sampling.py)
 * and the play_board loop (src/bid/arena.py): seats advance clockwise from
 * the dealer; the auction ends on 4 opening passes or 3 consecutive passes
 * after any call (arena additionally caps auctions at 20 calls).
 */
(function (api) {
    'use strict';

    const C = api.CallType;
    const Call = api.Call;

    function isAuctionOver(history) {
        const h = history;
        if (h.length < 4) return false;
        if (h.length === 4 && h.every(c => c.type === C.PASS)) return true;
        if (h.length >= 4 && h.slice(-3).every(c => c.type === C.PASS)) return true;
        return false;
    }

    /** Port of PartialState.get_contract -> {level, strain, declarer, doubled}
     *  or null when passed out. */
    function getContract(history, dealer) {
        if (!isAuctionOver(history)) return null;

        let lastBid = null, lastBidSeat = null, doubled = 0;
        let curr = dealer;
        for (const call of history) {
            if (call.type === C.BID) {
                lastBid = call;
                lastBidSeat = curr;
                doubled = 0;
            } else if (call.type === C.DOUBLE) {
                doubled = 1;
            } else if (call.type === C.REDOUBLE) {
                doubled = 2;
            }
            curr = (curr + 1) % 4;
        }
        if (!lastBid) return null;

        const level = lastBid.level;
        const strain = lastBid.strain;
        // declarer: first player of the winning partnership who bid the strain
        const winningSide = [lastBidSeat, api.Seat.partner(lastBidSeat)];
        let declarer = lastBidSeat;
        curr = dealer;
        for (const call of history) {
            if (call.type === C.BID && call.strain === strain &&
                (curr === winningSide[0] || curr === winningSide[1])) {
                declarer = curr;
                break;
            }
            curr = (curr + 1) % 4;
        }
        return {level, strain, declarer, doubled};
    }

    function contractString(contract) {
        if (!contract) return 'Pass';
        const suffix = contract.doubled === 1 ? 'X' : contract.doubled === 2 ? 'XX' : '';
        return contract.level + api.STRAIN_NAMES[contract.strain] + suffix;
    }

    const MAX_CALLS = 20;   // arena.py safety cap

    /**
     * AuctionRunner drives one board. Modes:
     *   'manual'  — the reviewer picks every call via the bidding box
     *   'auto'    — deterministic priority selection (see bid_net.autoSelect)
     * step() returns the explanation of the NEXT decision, or null when the
     * auction is over. applyCall(call) appends and advances.
     */
    function AuctionRunner(deal, net, mode) {
        this.deal = deal;
        this.net = net;
        this.mode = mode || 'manual';
        this.history = [];
        this.record = [];      // [{seat, call, explanation, auto}]
    }

    AuctionRunner.prototype.currentSeat = function () {
        return (this.deal.dealer + this.history.length) % 4;
    };

    AuctionRunner.prototype.isOver = function () {
        return isAuctionOver(this.history) || this.history.length >= MAX_CALLS;
    };

    /** Explanation of the decision currently facing `seat` (defaults to turn). */
    AuctionRunner.prototype.explain = function (seat) {
        const s = (seat === undefined) ? this.currentSeat() : seat;
        return api.Net.explain(this.net, this.deal.hands[s], this.history,
            s, this.deal.dealer, this.deal.vuln);
    };

    /** Compute (but do not apply) the auto call for the current turn. */
    AuctionRunner.prototype.autoCall = function () {
        return api.Net.autoSelect(this.net, this.explain());
    };

    AuctionRunner.prototype.applyCall = function (call, explanation, auto) {
        const seat = this.currentSeat();
        this.history.push(call);
        this.record.push({seat, call, explanation, auto: !!auto});
    };

    /** Auto-bid the current turn only. Returns the record entry or null. */
    AuctionRunner.prototype.stepAuto = function () {
        if (this.isOver()) return null;
        const explanation = this.explain();
        const call = api.Net.autoSelect(this.net, explanation);
        this.applyCall(call, explanation, true);
        return this.record[this.record.length - 1];
    };

    /** Auto-bid until the auction ends (bounded by MAX_CALLS). */
    AuctionRunner.prototype.runOut = function () {
        while (!this.isOver()) this.stepAuto();
        return this.record;
    };

    AuctionRunner.prototype.contract = function () {
        return getContract(this.history, this.deal.dealer);
    };

    api.Auction = {AuctionRunner, isAuctionOver, getContract, contractString, MAX_CALLS};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
