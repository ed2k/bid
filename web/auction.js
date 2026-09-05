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
     * AuctionRunner drives one board. `models` maps each seat (0..3) to an
     * engine: {kind:'net', net} (DecisionNet DSL) or {kind:'legacy', system}
     * (translator DSL).  A bare net/engine applies to all four seats, and
     * {ns, ew} picks engines per partnership — mirroring arena.play_board.
     * Modes:
     *   'manual'  — the reviewer picks every call via the bidding box
     *   'auto'    — deterministic selection per engine (see autoSelect)
     */
    function AuctionRunner(deal, models, mode) {
        this.deal = deal;
        this.mode = mode || 'manual';
        this.history = [];
        this.record = [];
        this.models = normalizeModels(models);
    }

    function normalizeModels(models) {
        const bySeat = {};
        if (!models) {
            for (let s = 0; s < 4; s++) bySeat[s] = null;
        } else if (models.ns !== undefined || models.ew !== undefined) {
            bySeat[0] = bySeat[2] = models.ns || null;
            bySeat[1] = bySeat[3] = models.ew || null;
        } else if (models.kind === 'net' || models.kind === 'legacy' ||
                   models.rules !== undefined) {
            for (let s = 0; s < 4; s++) bySeat[s] = models;
        } else {
            for (let s = 0; s < 4; s++) bySeat[s] = models[s] || null;
        }
        return bySeat;
    }

    AuctionRunner.prototype.modelFor = function (seat) {
        return this.models[seat];
    };

    AuctionRunner.prototype.currentSeat = function () {
        return (this.deal.dealer + this.history.length) % 4;
    };

    AuctionRunner.prototype.isOver = function () {
        return isAuctionOver(this.history) || this.history.length >= MAX_CALLS;
    };

    /** Explanation of the decision currently facing `seat` (defaults to turn). */
    AuctionRunner.prototype.explain = function (seat) {
        const s = (seat === undefined) ? this.currentSeat() : seat;
        const model = this.models[s];
        if (model && model.kind === 'legacy') {
            return api.Legacy.explain(model.system, this.deal.hands[s], this.history);
        }
        const net = model ? model.net : null;
        return api.Net.explain(net, this.deal.hands[s], this.history,
            s, this.deal.dealer, this.deal.vuln);
    };

    /** Compute (but do not apply) the auto call for the current turn. */
    AuctionRunner.prototype.autoCall = function () {
        const model = this.models[this.currentSeat()];
        if (model && model.kind === 'legacy') {
            const exp = this.explain();
            return exp.chosen ? exp.chosen.call : new Call(C.PASS);
        }
        return api.Net.autoSelect(model ? model.net : null, this.explain());
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
