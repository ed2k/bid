/**
 * objects.js — core domain objects for the Bid review UI.
 *
 * Faithful JS port of the semantics of src/bid/models.py (Seat, Strain,
 * CallType, Call, Hand) and the vulnerability encoding of src/bid/scoring.py,
 * so that DSL rules and feature values mean exactly the same thing as the
 * Python engine.  Attaches to globalThis.BidWeb (works in browser and node).
 */
(function (api) {
    'use strict';

    // ---- enums (values match Python IntEnums exactly) ----------------------

    api.SEAT_NAMES = ['NORTH', 'EAST', 'SOUTH', 'WEST'];
    api.SEAT_LETTERS = ['N', 'E', 'S', 'W'];
    api.STRAIN_NAMES = ['C', 'D', 'H', 'S', 'NT'];
    api.STRAIN_SYMBOLS = ['\u2663', '\u2666', '\u2665', '\u2660', 'NT'];

    api.Seat = {
        NORTH: 0, EAST: 1, SOUTH: 2, WEST: 3,
        name: v => api.SEAT_NAMES[v],
        letter: v => api.SEAT_LETTERS[v],
        partner: v => (v + 2) % 4,
        fromName: n => ({NORTH: 0, EAST: 1, SOUTH: 2, WEST: 3})[String(n).replace('Seat.', '')]
    };

    api.Strain = {
        CLUBS: 0, DIAMONDS: 1, HEARTS: 2, SPADES: 3, NT: 4,
        name: v => api.STRAIN_NAMES[v],
        fromName: s => ({C: 0, D: 1, H: 2, S: 3, NT: 4})[s]
    };

    api.CallType = {BID: 1, PASS: 2, DOUBLE: 3, REDOUBLE: 4};

    // ---- calls --------------------------------------------------------------

    function Call(type, level, strain) {
        this.type = type;
        this.level = level || 0;
        this.strain = (strain === undefined || strain === null) ? null : strain;
    }

    Call.prototype.toString = function () {
        if (this.type === api.CallType.PASS) return 'PASS';
        if (this.type === api.CallType.DOUBLE) return 'X';
        if (this.type === api.CallType.REDOUBLE) return 'XX';
        return this.level + api.STRAIN_NAMES[this.strain];
    };

    Call.prototype.equals = function (other) {
        return other instanceof Call &&
            this.type === other.type &&
            this.level === other.level &&
            this.strain === other.strain;
    };

    /** Port of eval_vs_dds.parse_call: 'PASS'/'P', 'X'/'DBL', 'XX'/'RDBL', '1C'..'7NT'. */
    Call.parse = function (s) {
        s = String(s).trim();
        if (s === 'PASS' || s === 'P') return new Call(api.CallType.PASS);
        if (s === 'X' || s === 'DBL') return new Call(api.CallType.DOUBLE);
        if (s === 'XX' || s === 'RDBL') return new Call(api.CallType.REDOUBLE);
        const m = s.match(/^(\d)(C|D|H|S|NT)$/);
        if (!m) throw new Error('Bad call: ' + s);
        return new Call(api.CallType.BID, parseInt(m[1], 10), api.Strain.fromName(m[2]));
    };

    api.Call = Call;

    // ---- vulnerability (scoring.py Vulnerability) ---------------------------

    api.Vulnerability = {
        NONE: 0, NS: 1, EW: 2, BOTH: 3,
        isVulnerable: function (vuln, seat) {
            if (vuln === 3) return true;
            if (vuln === 0) return false;
            if (vuln === 1) return seat === 0 || seat === 2;   // NS
            if (vuln === 2) return seat === 1 || seat === 3;   // EW
            return false;
        },
        label: function (vuln) {
            return ['None', 'N/S', 'E/W', 'Both'][vuln];
        }
    };

    // ---- hands --------------------------------------------------------------

    const RANK_LETTERS = {A: 14, K: 13, Q: 12, J: 11, T: 10, '10': 10,
        '9': 9, '8': 8, '7': 7, '6': 6, '5': 5, '4': 4, '3': 3, '2': 2};
    const SUIT_LETTERS = {S: 'spades', H: 'hearts', D: 'diamonds', C: 'clubs'};

    function Hand() {
        // suits: {spades: [rank...desc], hearts: [...], diamonds: [...], clubs: [...]}
        this.suits = {spades: [], hearts: [], diamonds: [], clubs: []};
    }

    const SUIT_KEYS = ['spades', 'hearts', 'diamonds', 'clubs'];
    api.SUIT_KEYS = SUIT_KEYS;

    Hand.prototype.length = function (suitKey) { return this.suits[suitKey].length; };

    Hand.prototype.hcp = function () {
        let v = 0;
        for (const k of SUIT_KEYS) {
            for (const r of this.suits[k]) {
                if (r === 14) v += 4;
                else if (r === 13) v += 3;
                else if (r === 12) v += 2;
                else if (r === 11) v += 1;
            }
        }
        return v;
    };

    Hand.prototype.suitHcp = function (suitKey) {
        let v = 0;
        for (const r of this.suits[suitKey]) {
            if (r === 14) v += 4;
            else if (r === 13) v += 3;
            else if (r === 12) v += 2;
            else if (r === 11) v += 1;
        }
        return v;
    };

    /** Blue Club controls: Ace=2, King=1 (models.py Hand.controls). */
    Hand.prototype.controls = function () {
        let v = 0;
        for (const k of SUIT_KEYS) {
            for (const r of this.suits[k]) {
                if (r === 14) v += 2;
                else if (r === 13) v += 1;
            }
        }
        return v;
    };

    Hand.prototype.countRank = function (rank) {
        let v = 0;
        for (const k of SUIT_KEYS) {
            for (const r of this.suits[k]) if (r === rank) v++;
        }
        return v;
    };

    Hand.prototype.hasRank = function (suitKey, rank) {
        return this.suits[suitKey].indexOf(rank) >= 0;
    };

    /** models.py Hand.is_balanced: no singleton/void, at most one doubleton. */
    Hand.prototype.isBalanced = function () {
        const lens = SUIT_KEYS.map(k => this.suits[k].length).sort((a, b) => a - b);
        const key = lens.join(',');
        return key === '3,3,3,4' || key === '2,3,4,4' || key === '2,3,3,5';
    };

    /** Parse the hand formats found in the repo:
     *  trace corpus: 'S : 9 2 H : A 9 D : A K Q T 8 5 C : K J 5'
     *  compact:      'SAK2 HKQJ DQJ9 C432' / 'S:AK2 H:KQJ D:QJ9 C:432'   */
    Hand.parse = function (s) {
        const hand = new Hand();
        const text = String(s).trim();
        let found = 0;

        const addRanks = (suitCh, rankText) => {
            const key = SUIT_LETTERS[suitCh];
            for (const tok of rankText.split(/\s+/)) {
                if (!tok) continue;
                for (const ch of tok.replace(/^10$/, 'T')) {
                    const rank = RANK_LETTERS[ch];
                    if (rank) hand.suits[key].push(rank);
                }
            }
        };

        // corpus style: suit letter + ':' markers
        const markers = [...text.matchAll(/([SHDC])\s*:\s*/g)];
        if (markers.length === 4) {
            markers.forEach((m, i) => {
                const start = m.index + m[0].length;
                const end = i + 1 < markers.length ? markers[i + 1].index : text.length;
                addRanks(m[1], text.slice(start, end));
                found++;
            });
        } else if (markers.length === 0 && text.indexOf('.') >= 0) {
            // dotted PBN hand style: 'AKQJ.T98.765.432' (suits in S.H.D.C order)
            const parts = text.replace(/\s+/g, '').split('.');
            if (parts.length === 4) {
                const order = ['spades', 'hearts', 'diamonds', 'clubs'];
                parts.forEach((grp, i) => {
                    for (const ch of grp.replace(/^10/, 'T')) {
                        const rank = RANK_LETTERS[ch];
                        if (rank) hand.suits[order[i]].push(rank);
                    }
                });
                found = 4;
            }
        } else {
            // compact style: 'SAK2 HKQJ' groups (colon tolerated)
            for (const m of text.matchAll(/([SHDC])\s*:?\s*([AKQJT\d]*)/g)) {
                if (!m[2]) continue;
                addRanks(m[1], m[2].replace(/^10/, 'T'));
                found++;
            }
        }
        if (found !== 4) throw new Error('Cannot parse hand: ' + s);
        for (const k of SUIT_KEYS) hand.suits[k].sort((a, b) => b - a);
        return hand;
    };

    /** Card-occurrence map across a deal spec, for duplicate detection. */
    Hand.cardCounts = function (hands) {
        const counts = {};
        for (const hand of hands) {
            if (!hand) continue;
            for (const k of SUIT_KEYS) {
                for (const r of hand.suits[k]) {
                    const key = k[0].toUpperCase() + r;
                    counts[key] = (counts[key] || 0) + 1;
                }
            }
        }
        return counts;
    };

    api.Hand = Hand;

    // ---- deals --------------------------------------------------------------

    function Deal(dealer, vuln, hands) {
        this.dealer = dealer;         // seat value 0..3
        this.vuln = vuln;             // 0..3 per scoring.py Vulnerability
        this.hands = hands;           // [N, E, S, W] Hand objects
    }

    /** Seeded PRNG (mulberry32) so review sessions can share deals. */
    function mulberry32(seed) {
        let a = seed >>> 0;
        return function () {
            a |= 0; a = (a + 0x6D2B79F5) | 0;
            let t = Math.imul(a ^ (a >>> 15), 1 | a);
            t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
            return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
        };
    }
    api.mulberry32 = mulberry32;

    Deal.random = function (dealer, vuln, seed) {
        const cards = [];
        for (let suit = 0; suit < 4; suit++) {
            for (let rank = 2; rank <= 14; rank++) cards.push({suit, rank});
        }
        const rng = mulberry32(seed === undefined ? (Date.now() & 0xffffffff) : seed);
        for (let i = cards.length - 1; i > 0; i--) {
            const j = Math.floor(rng() * (i + 1));
            [cards[i], cards[j]] = [cards[j], cards[i]];
        }
        const hands = [];
        for (let seat = 0; seat < 4; seat++) {
            const hand = new Hand();
            for (let i = seat; i < 52; i += 4) {
                hand.suits[SUIT_KEYS[cards[i].suit]].push(cards[i].rank);
            }
            for (const k of SUIT_KEYS) hand.suits[k].sort((a, b) => b - a);
            hands.push(hand);
        }
        return new Deal(dealer === undefined ? 0 : dealer,
            vuln === undefined ? 0 : vuln, hands);
    };

    /** PBN for the vendored dds.js: 'N:AKQJ.xxx ... ... ...' hands in rotation
     *  from the marker seat (N: -> N E S W).  Uses 'N' marker + N,E,S,W order. */
    Deal.prototype.toPBN = function () {
        const order = [0, 1, 2, 3];   // N E S W
        const parts = order.map(seat => {
            return SUIT_KEYS.map(k => {
                const ranks = this.hands[seat].suits[k];
                return ranks.length ? ranks.map(r =>
                    r === 14 ? 'A' : r === 13 ? 'K' : r === 12 ? 'Q' :
                    r === 11 ? 'J' : r === 10 ? 'T' : String(r)).join('') : '-';
            }).join('.');
        });
        return 'N:' + parts.join(' ');
    };

    api.Deal = Deal;
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
