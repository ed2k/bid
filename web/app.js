/**
 * app.js — Bid review UI wiring.
 *
 * Two review modes:
 *   live    — generate a deal and review every decision of the current DSL
 *             system (manual bids via the bidding box, or deterministic
 *             "system call" auto-selection per seat).
 *   replay  — step through a recorded corpus board or a student-vs-teacher
 *             disagreement; the JS engine verifies each recorded call against
 *             the re-computed candidate set and feature values.
 *
 * On auction completion the vendored pure-JS DDS renders the double-dummy
 * table and par for the board.
 */
(function (BidWeb, DDS) {
    'use strict';

    const C = BidWeb.CallType;
    const Call = BidWeb.Call;
    const Strain = BidWeb.Strain;
    const Seat = BidWeb.Seat;
    const Auction = BidWeb.Auction;
    const Net = BidWeb.Net;
    const DATA = globalThis.BID_REVIEW_DATA;

    const $ = id => document.getElementById(id);

    const App = {
        net: null,
        mode: 'live',
        live: {deal: null, runner: null},
        replay: null,
        boards: [],
        boardByKey: {},
        disputes: [],
        pendingLevel: null,
        dds: null,          // WASM DDS module once DDS.init() resolves
        ddsFailed: false,
    };

    // WASM calcParPBN vulnerability codes: 0=None, 1=Both, 2=NS, 3=EW
    const WASM_VULN = {0: 0, 1: 2, 2: 3, 3: 1};

    const FEATURE_KEYS = [
        'hcp', 'controls', 'spade_len', 'heart_len', 'diamond_len', 'club_len',
        'is_balanced', 'is_opening', 'partner_last_call', 'my_last_call',
        'opp_last_call', 'is_balancing', 'is_competitive', 'last_bid_strain',
        'support_in_partner_suit', 'partner_last_bid_strain', 'is_favorable_vuln',
        'vuln_pressure', 'auction_altitude', 'auction_contested', 'opp_preempted',
        'opp_strength_class', 'opp_suit_stoppers', 'has_stopper', 'opp_fit_shown',
        'our_fit_shown',
    ];

    // ---------- helpers ----------

    function el(tag, cls, text) {
        const e = document.createElement(tag);
        if (cls) e.className = cls;
        if (text !== undefined) e.textContent = text;
        return e;
    }

    function seatHandHTML(hand, seatIdx, known) {
        const div = el('div', 'hand-cards');
        if (!known || !hand) {
            div.appendChild(el('div', 'hidden-hand', '(hidden hand)'));
            return div;
        }
        const syms = {spades: '\u2660', hearts: '\u2665', diamonds: '\u2666', clubs: '\u2663'};
        for (const key of BidWeb.SUIT_KEYS) {
            const row = el('div', 'suit-row');
            const sym = el('span', 'sym sym-' + key[0].toUpperCase(), syms[key]);
            row.appendChild(sym);
            const ranks = hand.suits[key];
            row.appendChild(document.createTextNode(
                ranks.length ? ranks.map(r =>
                    r === 14 ? 'A' : r === 13 ? 'K' : r === 12 ? 'Q' :
                    r === 11 ? 'J' : r === 10 ? 'T' : String(r)).join(' ') : '—'));
            div.appendChild(row);
        }
        return div;
    }

    function rowSeatValue(v) {
        const names = {NORTH: 0, EAST: 1, SOUTH: 2, WEST: 3,
            N: 0, E: 1, S: 2, W: 3};
        const k = String(v).replace('Seat.', '').toUpperCase();
        return names[k];
    }

    // ---------- current decision abstraction ----------

    function currentDecision() {
        if (App.mode === 'live') {
            const r = App.live.runner;
            if (!r || r.isOver()) return null;
            return {seat: r.currentSeat(), exp: r.explain(), history: r.history};
        }
        const rp = App.replay;
        if (!rp || rp.idx < 0 || rp.idx >= rp.rows.length) return null;
        const row = rp.rows[rp.idx];
        if (!row.__exp) {
            row.__exp = Net.explain(App.net, BidWeb.Hand.parse(row.input.hand),
                (row.input.auction || []).map(s => Call.parse(s)),
                rowSeatValue(row.seat), rowSeatValue(row.board.dealer), row.board.vuln);
        }
        return {seat: rowSeatValue(row.seat), exp: row.__exp,
            history: (row.input.auction || []).map(s => Call.parse(s)), row};
    }

    function knownHands() {
        if (App.mode === 'live') return App.live.deal.hands;
        const hands = [null, null, null, null];
        for (const row of App.replay.rows) {
            const s = rowSeatValue(row.seat);
            if (s !== undefined && hands[s] === null) {
                try { hands[s] = BidWeb.Hand.parse(row.input.hand); } catch (e) { /* skip */ }
            }
        }
        return hands;
    }

    function fullHistory() {
        return App.mode === 'live' ? App.live.runner.history
            : (App.replay && App.replay.idx >= 0
                ? (App.replay.rows[App.replay.idx].input.auction || []).map(s => Call.parse(s))
                    .concat([Call.parse(App.replay.rows[App.replay.idx].bid)])
                : []);
    }

    function auctionOver() {
        if (App.mode === 'live') return App.live.runner.isOver();
        if (!App.replay || App.replay.idx < 0) return false;
        return App.replay.idx >= App.replay.rows.length - 1 ||
            Auction.isAuctionOver(fullHistory());
    }

    // ---------- rendering ----------

    function render() {
        renderSeats();
        renderAuctionTable();
        renderDecision();
        renderBiddingBox();
        renderResult();
    }

    function renderSeats() {
        const hands = knownHands();
        const dec = currentDecision();
        const over = auctionOver();
        for (let s = 0; s < 4; s++) {
            const seatEl = $('seat-' + Seat.letter(s));
            const old = seatEl.querySelector('.hand-cards');
            const fresh = seatHandHTML(hands[s], s, !!hands[s]);
            fresh.id = old.id;
            old.replaceWith(fresh);
            seatEl.classList.toggle('to-call', !!dec && !over && dec.seat === s);
        }
    }

    function renderAuctionTable() {
        const tbody = $('auction-bids-tbody');
        tbody.innerHTML = '';
        const history = fullHistory();
        const dealer = App.mode === 'live' ? App.live.deal.dealer
            : rowSeatValue(App.replay.rows[0].board.dealer);
        const colOf = s => ({3: 0, 0: 1, 1: 2, 2: 3}[s]);   // columns W N E S
        const rows = [];
        let cells = [];
        for (let i = 0; i < colOf(dealer); i++) cells.push(undefined);
        for (const call of history) {
            cells.push(call);
            if (cells.length === 4) { rows.push(cells); cells = []; }
        }
        if (cells.length) rows.push(cells);
        for (let r = 0; r < Math.max(rows.length, 1); r++) {
            const tr = el('tr');
            for (let c = 0; c < 4; c++) {
                const td = el('td');
                const call = rows[r] ? rows[r][c] : undefined;
                if (call) {
                    td.className = call.type === C.PASS ? 'call-PASS'
                        : call.type === C.BID ? 'call-bid' : 'call-X';
                    td.textContent = call.toString();
                } else {
                    td.className = 'future';
                    td.textContent = '';
                }
                tr.appendChild(td);
            }
            tbody.appendChild(tr);
        }
    }

    function featureChips(features) {
        const grid = el('div', 'feature-grid');
        for (const key of FEATURE_KEYS) {
            if (!(key in features)) continue;
            const chip = el('div', 'feature-chip');
            chip.appendChild(el('span', 'k', key.replace(/_/g, ' ') + ' '));
            chip.appendChild(document.createTextNode(formatVal(features[key])));
            grid.appendChild(chip);
        }
        return grid;
    }

    function formatVal(v) {
        if (typeof v === 'boolean') return v ? 'true' : 'false';
        if (v === null || v === undefined) return '–';
        return String(v);
    }

    function renderDecision() {
        const body = $('inspector-body');
        body.innerHTML = '';
        const dec = currentDecision();
        if (auctionOver()) {
            body.appendChild(el('p', 'muted', 'Auction complete.'));
            return;
        }
        if (!dec) {
            body.appendChild(el('p', 'muted', 'Step into the replay or start a deal.'));
            return;
        }
        const exp = dec.exp;
        body.appendChild(el('p', null, 'Seat to call: ')).appendChild(
            el('strong', null, Seat.name(dec.seat)));

        body.appendChild(el('h4', 'muted small', 'features (JS port)'));
        body.appendChild(featureChips(exp.features));

        if (App.mode === 'replay') {
            body.appendChild(replayVerification(dec));
        }

        body.appendChild(el('h4', 'muted small',
            `rules matched (${exp.matchedIds.length}/${App.net.rules.length})`));
        for (const rr of exp.ruleResults.filter(r => r.matched)) {
            body.appendChild(ruleBlock(rr));
        }
        if (!exp.matchedIds.length) {
            body.appendChild(el('p', 'muted small',
                'No positive rule matched → PASS fallback.'));
        }

        body.appendChild(el('h4', 'muted small', 'candidate set φ(s) — legal'));
        const legalRow = el('div', 'candidate-row');
        for (const c of exp.legal) {
            legalRow.appendChild(el('span', 'call-chip', c.toString()));
        }
        body.appendChild(legalRow);
        if (exp.illegal.length) {
            body.appendChild(el('h4', 'muted small', 'filtered as illegal'));
            const illRow = el('div', 'candidate-row');
            for (const c of exp.illegal) {
                illRow.appendChild(el('span', 'call-chip illegal', c.toString()));
            }
            body.appendChild(illRow);
        }
        if (exp.fallbackPass) {
            body.appendChild(el('p', 'tag tag-warn', 'PASS fallback active'));
        }
        if (exp.intersectionApplied) {
            body.appendChild(el('p', 'tag tag-ok',
                'intersection override: ' + exp.intersectionApplied));
        }
        const auto = Net.autoSelect(App.net, exp);
        $('system-call-hint').textContent =
            'System priority pick: ' + auto.toString();
    }

    function ruleBlock(rr) {
        const block = el('div', 'rule-block');
        const head = el('div', 'rule-head');
        head.appendChild(document.createTextNode(rr.rule.ruleId + ' → ' + rr.rule.call));
        head.appendChild(el('span', 'prio', '  prio ' + rr.rule.priority));
        if (rr.rule.isNegative) head.appendChild(el('span', 'tag tag-bad', 'NEGATIVE'));
        block.appendChild(head);
        const ul = el('ul', 'cond-list');
        for (const cr of rr.conditionResults) {
            const li = el('li', cr.missing ? 'cond-missing'
                : (cr.ok ? 'cond-ok' : 'cond-fail'),
            `${cr.cond.key} ${cr.cond.op} ${formatVal(cr.cond.value)}` +
                (cr.missing ? '  (missing key)' : `  [${formatVal(cr.actual)}]`));
            ul.appendChild(li);
        }
        block.appendChild(ul);
        return block;
    }

    /** Verification panel for replay mode. */
    function replayVerification(dec) {
        const row = dec.row;
        const exp = dec.exp;
        const box = el('div');
        const bid = Call.parse(row.bid);
        const inLegal = exp.legal.some(c => c.equals(bid));

        const head = el('p');
        head.appendChild(el('span', null, 'Recorded call: '));
        head.appendChild(el('strong', null, row.bid));
        head.appendChild(el('span', 'tag ' + (inLegal ? 'tag-ok' : 'tag-bad'),
            inLegal ? '  in φ(s) ✓' : '  NOT in φ(s) ✗'));
        box.appendChild(head);

        if (Array.isArray(row.ev) && row.ev.length) {
            const evCalls = row.ev.map(s => Call.parse(s));
            const same = evCalls.length === exp.legal.length &&
                evCalls.every(c => exp.legal.some(l => l.equals(c)));
            box.appendChild(el('span', 'tag ' + (same ? 'tag-ok' : 'tag-warn'),
                same ? 'φ(s) == recorded candidates ✓' : 'φ(s) ≠ recorded candidates'));
            box.appendChild(document.createTextNode(' '));
        }

        // feature parity spot check
        let mismatch = 0, compared = 0, example = '';
        for (const key of Object.keys(exp.features)) {
            if (!(key in row.input.features)) continue;
            compared++;
            const py = row.input.features[key], js = exp.features[key];
            const same = (typeof py === 'number' && typeof js === 'number')
                ? Math.abs(py - js) < 1e-9 : js === py;
            if (!same) { mismatch++; if (!example) example = key; }
        }
        box.appendChild(el('span',
            'tag ' + (mismatch ? 'tag-bad' : 'tag-ok'),
            mismatch ? `features differ: ${mismatch}/${compared} (${example})`
                : `features match Python ✓ (${compared} keys)`));
        box.appendChild(document.createTextNode(' '));

        const tags = (row.explanation && row.explanation.all_matched) || [];
        if (tags.length) {
            const tag = tags[0];
            const cls = tag === 'ARB_STUDENT_LEGAL' ? 'tag-bad'
                : tag === 'ARB_THIRD' ? 'tag-warn' : 'tag-ok';
            box.appendChild(el('span', 'tag ' + cls, tag));
            if (row.explanation && row.explanation.rule) {
                box.appendChild(el('span', 'muted small',
                    '  recorded rule: ' + row.explanation.rule));
            }
        }
        return box;
    }

    // ---------- bidding box ----------

    function bridgeLegalCalls(exp) {
        const history = fullHistory();
        let lastBid = null;
        for (const c of history) if (c.type === C.BID) lastBid = c;
        const calls = [new Call(C.PASS)];
        if (exp && exp.xOk) calls.push(new Call(C.DOUBLE));
        if (exp && exp.xxOk) calls.push(new Call(C.REDOUBLE));
        for (let level = 1; level <= 7; level++) {
            for (let strain = 0; strain <= 4; strain++) {
                const bid = new Call(C.BID, level, strain);
                if (!lastBid || bid.level > lastBid.level ||
                    (bid.level === lastBid.level && bid.strain > lastBid.strain)) {
                    calls.push(bid);
                }
            }
        }
        return calls;
    }

    function renderBiddingBox() {
        const over = auctionOver();
        const dec = currentDecision();
        const liveManual = App.mode === 'live' && !over;
        const buttons = document.querySelectorAll('.bid-btn');
        const legal = liveManual ? bridgeLegalCalls(dec && dec.exp) : [];
        buttons.forEach(btn => {
            const s = btn.dataset.bid;
            let call = null;
            if (s === 'PASS') call = new Call(C.PASS);
            else if (s === 'X') call = new Call(C.DOUBLE);
            else if (s === 'XX') call = new Call(C.REDOUBLE);
            btn.disabled = !liveManual || !call ||
                !legal.some(c => c.equals(call));
        });
        // level buttons
        const levelRow = $('bidding-level-row');
        levelRow.innerHTML = '';
        for (let level = 1; level <= 7; level++) {
            const b = el('button', 'bid-btn level-btn', String(level));
            b.dataset.level = level;
            b.disabled = !liveManual;
            b.classList.toggle('btn-accent', App.pendingLevel === level);
            b.onclick = () => {
                App.pendingLevel = App.pendingLevel === level ? null : level;
                renderBiddingBox();
            };
            levelRow.appendChild(b);
        }
        const suitRow = $('bidding-suit-row');
        suitRow.innerHTML = '';
        ['C', 'D', 'H', 'S', 'NT'].forEach((name, idx) => {
            const b = el('button', 'bid-btn suit-btn',
                ['\u2663', '\u2666', '\u2665', '\u2660', 'NT'][idx]);
            b.dataset.strain = name;
            b.disabled = !liveManual || App.pendingLevel === null;
            b.onclick = () => {
                if (App.pendingLevel === null) return;
                humanBids(new Call(C.BID, App.pendingLevel, idx));
                App.pendingLevel = null;
            };
            suitRow.appendChild(b);
        });
        $('bidding-note').textContent = liveManual
            ? 'You are reviewing: pick any bridge-legal call, or use the system pick below.'
            : (App.mode === 'replay'
                ? 'Replay mode — recorded calls are stepped through and verified.'
                : 'Auction complete — start a new deal or reset.');
    }

    function humanBids(call) {
        if (App.mode !== 'live') return;
        const exp = App.live.runner.explain();
        App.live.runner.applyCall(call, exp, false);
        render();
    }

    // ---------- result / DDS ----------

    function renderResult() {
        const contract = App.mode === 'live'
            ? App.live.runner.contract()
            : (App.replay ? Auction.getContract(fullHistory(), rowSeatValue(App.replay.rows[0].board.dealer)) : null);
        $('info-contract').textContent = Auction.contractString(contract) +
            (contract ? ' by ' + Seat.name(contract.declarer) : '');

        const over = auctionOver();
        $('info-status').textContent = over ? 'Auction complete'
            : (App.mode === 'replay'
                ? `Replay step ${Math.max(App.replay.idx + 1, 0)}/${App.replay.rows.length}`
                : 'Reviewing — seat to call');
        $('info-status').className = 'val ' + (over ? '' : 'status-active');

        const panel = $('dd-panel');
        if (!over) { panel.classList.add('hidden'); return; }

        // need all four hands for the solver
        const hands = knownHands();
        if (hands.some(h => !h)) {
            panel.classList.remove('hidden');
            $('dd-table').innerHTML = '';
            $('dd-par').textContent = 'Hidden hands present — DD table unavailable.';
            return;
        }
        const dealer = App.mode === 'live' ? App.live.deal.dealer
            : rowSeatValue(App.replay.rows[0].board.dealer);
        const vuln = App.mode === 'live' ? App.live.deal.vuln
            : App.replay.rows[0].board.vuln;
        const deal = new BidWeb.Deal(dealer, vuln, hands);
        const pbn = deal.toPBN();
        const boardKey = App.mode === 'replay'
            ? App.replay.rows[0].board.seed + ':' + App.replay.rows[0].board.index
            : null;
        const embedded = boardKey ? (DATA.boards || {})[boardKey] : null;

        let table = null, parContracts = null, parScore = null, source = '';
        if (App.dds) {
            try {
                table = App.dds.calcDDTablePBN(pbn);
                const par = App.dds.calcParPBN(pbn, WASM_VULN[vuln] ?? 0);
                parContracts = (par.parContracts || []).join(', ');
                parScore = (par.parScore || []).join(' / ');
                source = 'WASM DDS';
            } catch (e) {
                $('dd-par').textContent = 'DDS error: ' + e.message;
                panel.classList.remove('hidden');
                return;
            }
        } else if (embedded) {
            table = {resTable: embedded.dd_table};
            parContracts = embedded.par_contract + ' (' + embedded.par_score + ')';
            parScore = String(embedded.par_score);
            source = 'native DDS @ export';
        } else {
            panel.classList.remove('hidden');
            $('dd-table').innerHTML = '';
            $('dd-par').textContent = App.ddsFailed
                ? 'WASM DDS unavailable here (needs http serving) — PBN: ' + pbn
                : 'Initializing WASM DDS…';
            return;
        }
        panel.classList.remove('hidden');
        const tbl = $('dd-table');
        tbl.innerHTML = '';
        const thead = el('thead');
        const hr = el('tr');
        hr.appendChild(el('th', null, 'Declarer →'));
        for (const s of ['N', 'E', 'S', 'W']) hr.appendChild(el('th', null, s));
        thead.appendChild(hr);
        tbl.appendChild(thead);
        const tb = el('tbody');
        const rows = ['S', 'H', 'D', 'C', 'NT'];
        for (let strain = 0; strain < 5; strain++) {
            const tr = el('tr');
            tr.appendChild(el('th', null, rows[strain]));
            for (let seat = 0; seat < 4; seat++) {
                const td = el('td', null, String(table.resTable[strain][seat]));
                if (contract && rows[strain] ===
                        ['C', 'D', 'H', 'S', 'NT'][contract.strain] &&
                    'NESW'[seat] === Seat.letter(contract.declarer)) {
                    td.classList.add('dd-cell-hit');
                }
                tr.appendChild(td);
            }
            tb.appendChild(tr);
        }
        tbl.appendChild(tb);
        panel.querySelector('.auction-title').textContent =
            'Double-Dummy Table (' + source + ')';
        $('dd-par').textContent = 'Par: ' + (parContracts || 'Pass out') +
            (parScore ? '  (' + parScore + ')' : '');
        $('info-par').textContent = parContracts || 'Pass out';
    }

    // ---------- sources ----------

    function newDeal() {
        const dealer = parseInt($('sel-dealer').value, 10);
        const vuln = parseInt($('sel-vuln').value, 10);
        App.mode = 'live';
        App.replay = null;
        App.pendingLevel = null;
        App.live.deal = BidWeb.Deal.random(dealer, vuln);
        App.live.runner = new Auction.AuctionRunner(App.live.deal, App.net, 'manual');
        $('info-source').textContent = 'live deal (random)';
        $('info-dealer-vuln').textContent = Seat.name(dealer) + ' / ' +
            BidWeb.Vulnerability.label(vuln);
        render();
    }

    // ---------- load-a-board modal ----------

    function openBoardModal() {
        $('board-error').textContent = '';
        document.querySelectorAll('.board-input-grid input')
            .forEach(i => i.classList.remove('bad'));
        $('board-modal').classList.remove('hidden');
        $('in-hand-N').focus();
    }

    function closeBoardModal() {
        $('board-modal').classList.add('hidden');
    }

    function loadUserBoard() {
        const errBox = $('board-error');
        errBox.textContent = '';
        const seats = ['N', 'E', 'S', 'W'];
        const raws = seats.map(s => $('in-hand-' + s).value.trim());
        document.querySelectorAll('.board-input-grid input')
            .forEach(i => i.classList.remove('bad'));

        if (raws.some(r => !r)) {
            errBox.textContent = 'All four hands are required.';
            raws.forEach((r, i) => {
                if (!r) $('in-hand-' + seats[i]).classList.add('bad');
            });
            return;
        }

        let hands;
        try {
            hands = raws.map(r => BidWeb.Hand.parse(r));
        } catch (e) {
            errBox.textContent = 'Parse error: ' + e.message;
            return;
        }

        const badCount = [];
        hands.forEach((h, i) => {
            const n = BidWeb.SUIT_KEYS.reduce((t, k) => t + h.suits[k].length, 0);
            if (n !== 13) badCount.push(`${Seat.name(i)} has ${n} cards`);
        });
        if (badCount.length) {
            errBox.textContent = 'Each hand needs exactly 13 cards — ' +
                badCount.join('; ') + '.';
            hands.forEach((h, i) => {
                const n = BidWeb.SUIT_KEYS.reduce((t, k) => t + h.suits[k].length, 0);
                if (n !== 13) $('in-hand-' + seats[i]).classList.add('bad');
            });
            return;
        }

        const counts = BidWeb.Hand.cardCounts(hands);
        const dupes = Object.entries(counts).filter(([, c]) => c > 1)
            .map(([card]) => card);
        if (dupes.length) {
            errBox.textContent = 'Duplicate card(s) across hands: ' +
                dupes.join(', ');
            return;
        }

        const dealer = parseInt($('board-dealer').value, 10);
        const vuln = parseInt($('board-vuln').value, 10);
        App.mode = 'live';
        App.replay = null;
        App.pendingLevel = null;
        App.live.deal = new BidWeb.Deal(dealer, vuln, hands);
        App.live.runner = new Auction.AuctionRunner(App.live.deal, App.net, 'manual');
        $('info-source').textContent = 'custom board (user input)';
        $('info-dealer-vuln').textContent = Seat.name(dealer) + ' / ' +
            BidWeb.Vulnerability.label(vuln);
        closeBoardModal();
        render();
    }

    function resetAuction() {
        App.pendingLevel = null;
        if (App.mode === 'live') {
            App.live.runner = new Auction.AuctionRunner(App.live.deal, App.net, 'manual');
        } else if (App.replay) {
            App.replay.idx = -1;
        }
        render();
    }

    function groupBoards(rows) {
        const groups = {};
        for (const row of rows) {
            const key = (row.board.seed ?? '?') + ':' + (row.board.index ?? '?');
            (groups[key] = groups[key] || []).push(row);
        }
        return Object.entries(groups)
            .map(([key, list]) => ({
                key,
                rows: list.slice().sort((a, b) => (a.call_index || 0) - (b.call_index || 0)),
                label: `board #${list[0].board.index} (seed ${list[0].board.seed}, ` +
                    `${list.length} calls, vuln ${BidWeb.Vulnerability.label(list[0].board.vuln)})`
            }))
            .filter(g => g.rows.length >= 4)
            .sort((a, b) => b.rows.length - a.rows.length);
    }

    function loadReplay(rows, label, jumpToCall) {
        App.mode = 'replay';
        App.pendingLevel = null;
        App.live.runner = null;
        App.replay = {rows: rows.map(r => Object.assign({}, r)), idx: -1, label};
        $('info-source').textContent = label;
        const b0 = rows[0].board;
        $('info-dealer-vuln').textContent =
            String(b0.dealer).replace('Seat.', '') + ' / ' +
            BidWeb.Vulnerability.label(b0.vuln);
        if (jumpToCall !== undefined) {
            const at = rows.findIndex(r => (r.call_index || 0) === jumpToCall);
            App.replay.idx = at >= 0 ? at : rows.length - 1;
            render();
        } else {
            replayStep(1);   // advance onto the first recorded decision
        }
    }

    function replayStep(delta) {
        if (!App.replay) return;
        const next = App.replay.idx + delta;
        if (next < -1) return;
        App.replay.idx = Math.min(next, App.replay.rows.length - 1);
        if (App.replay.idx < 0) { render(); return; }
        render();
    }

    // ---------- loop data tab ----------

    function renderDataTab() {
        renderTeacher();
        renderStudent();
        renderMining();
        renderDisputeTable();
    }

    function renderTeacher() {
        const t = DATA.teacher;
        const body = $('teacher-body');
        body.innerHTML = '';
        const head = el('p');
        head.appendChild(el('strong', null, `improved_system.dsl v${t.version}`));
        head.appendChild(el('span', 'muted small',
            `  |  sha ${DATA.dsl_sha256}  |  champion swaps ${t.champion_swaps}, holds ${t.champion_holds}`));
        body.appendChild(head);

        body.appendChild(el('h4', 'muted small', 'anchor ledger (frozen held-out set)'));
        const table = el('table', 'data-table');
        const thead = el('thead');
        const hr = el('tr');
        for (const h of ['version', 'avg score', 'IMP loss', 'par acc', 'trend'])
            hr.appendChild(el('th', null, h));
        thead.appendChild(hr);
        table.appendChild(thead);
        const tb = el('tbody');
        const versions = Object.keys(t.anchor || {}).map(Number).sort((a, b) => a - b);
        versions.forEach((v, i) => {
            const a = t.anchor[String(v)];
            const tr = el('tr');
            tr.appendChild(el('td', null, 'v' + v));
            tr.appendChild(el('td', null, a.avg_score.toFixed(2)));
            tr.appendChild(el('td', null, String(a.avg_imp_loss)));
            tr.appendChild(el('td', null, a.par_accuracy.toFixed(1) + '%'));
            if (i === 0) tr.appendChild(el('td', 'ledger-flat', 'baseline'));
            else {
                const prev = t.anchor[String(versions[i - 1])].avg_score;
                const d = a.avg_score - prev;
                tr.appendChild(el('td',
                    d > 1e-9 ? 'ledger-up' : d < -1e-9 ? 'ledger-down' : 'ledger-flat',
                    (d > 0 ? '+' : '') + d.toFixed(2)));
            }
            tb.appendChild(tr);
        });
        table.appendChild(tb);
        body.appendChild(table);
        if (!versions.length) body.appendChild(el('p', 'muted', 'No anchor entries yet.'));

        body.appendChild(el('h4', 'muted small',
            `applied patches (last 10 of ${t.applied.length}; ${t.failed_count} signatures failed/cached)`));
        const ul = el('ul', 'cond-list');
        for (const a of (t.applied || []).slice(-10).reverse()) {
            ul.appendChild(el('li', null, `${a.name} (${a.sig}) Δ${a.delta}`));
        }
        body.appendChild(ul);
    }

    function renderStudent() {
        const body = $('student-body');
        body.innerHTML = '';
        const table = el('table', 'data-table');
        const thead = el('thead');
        const hr = el('tr');
        for (const h of ['ts', 'decision', 'candidate', 'incumbent', 'reason'])
            hr.appendChild(el('th', null, h));
        thead.appendChild(hr);
        table.appendChild(thead);
        const tb = el('tbody');
        for (const rec of (DATA.student.history || []).slice(-12).reverse()) {
            const tr = el('tr');
            tr.appendChild(el('td', null, rec.ts || ''));
            tr.appendChild(el('td', rec.promoted ? 'ledger-up' : 'ledger-flat',
                rec.promoted ? 'PROMOTED' : 'kept'));
            tr.appendChild(el('td', null,
                rec.candidate ? rec.candidate.bid.toFixed(1) + '%' : '–'));
            tr.appendChild(el('td', null,
                rec.incumbent && rec.incumbent.bid !== undefined
                    ? rec.incumbent.bid.toFixed(1) + '%' : 'n/a'));
            tr.appendChild(el('td', null, rec.reason || ''));
            tb.appendChild(tr);
        }
        table.appendChild(tb);
        body.appendChild(table);
    }

    function renderMining() {
        const m = DATA.mining.meta || {};
        const body = $('mining-body');
        body.innerHTML = '';
        const head = el('p');
        const chips = [
            ['decisions', m.decisions], ['agreements', m.agreements],
            ['system right', m.arb_system_right],
            ['student right', m.arb_student_right, 'tag-bad'],
            ['new calls', m.arb_new_call, 'tag-warn'],
        ];
        for (const [label, val, cls] of chips) {
            head.appendChild(el('span', 'tag ' + (cls || 'tag-ok'),
                `${label}: ${val ?? '–'}`));
            head.appendChild(document.createTextNode(' '));
        }
        body.appendChild(head);
        body.appendChild(el('p', 'muted small',
            'arb_student_right > 0 means the student found positions where deep ' +
            'search agrees with it against the teacher — candidate teacher bugs. ' +
            `Snapshot: ${DATA.generated_ts}`));
    }

    function renderDisputeTable() {
        const table = $('dispute-table');
        table.innerHTML = '';
        const thead = el('thead');
        const hr = el('tr');
        for (const h of ['#', 'board', 'seat', 'call', 'recorded', 'arb tag', ''])
            hr.appendChild(el('th', null, h));
        thead.appendChild(hr);
        table.appendChild(thead);
        const tb = el('tbody');
        App.disputes.forEach((row, i) => {
            const tr = el('tr');
            tr.appendChild(el('td', null, String(i + 1)));
            tr.appendChild(el('td', null,
                `#${row.board.index} (seed ${row.board.seed})`));
            tr.appendChild(el('td', null, String(row.seat).replace('Seat.', '')));
            tr.appendChild(el('td', null, String(row.call_index)));
            tr.appendChild(el('td', null, row.bid));
            const tags = (row.explanation && row.explanation.all_matched) || [];
            const tag = tags[0] || '–';
            const cls = tag === 'ARB_STUDENT_LEGAL' ? 'tag-bad'
                : tag === 'ARB_THIRD' ? 'tag-warn' : 'tag-ok';
            tr.appendChild(el('td', null)).appendChild(el('span', 'tag ' + cls, tag));
            const tdBtn = el('td');
            const btn = el('button', 'btn', 'Replay');
            btn.onclick = () => {
                showTab('auction');
                const board = App.boardByKey[row.board.seed + ':' + row.board.index];
                if (board) {
                    loadReplay(board.rows, board.label, row.call_index);
                } else {
                    loadReplay([row], `dispute row #${i + 1}`, row.call_index);
                }
            };
            tdBtn.appendChild(btn);
            tr.appendChild(tdBtn);
            tb.appendChild(tr);
        });
        table.appendChild(tb);
    }

    // ---------- tabs / boot ----------

    function showTab(name) {
        $('view-auction').classList.toggle('hidden', name !== 'auction');
        $('view-data').classList.toggle('hidden', name !== 'data');
        $('tab-auction').classList.toggle('active', name === 'auction');
        $('tab-data').classList.toggle('active', name === 'data');
    }

    function boot() {
        App.net = BidWeb.DSL.parse(DATA.dsl, 'ImprovedSystem');
        $('badge-dsl').textContent =
            `v${(DATA.teacher || {}).version} · ${App.net.rules.length} rules · ${DATA.dsl_sha256}`;

        // WASM DDS (fast native C++ solver, vendored from ../dds/web).
        // Environments without SharedArrayBuffer (some webviews, file://)
        // can never initialize the pthread build — fall back after a grace
        // period to the export-time native tables embedded in the snapshot.
        if (typeof DDS !== 'undefined' && DDS.init) {
            let settled = false;
            DDS.init().then(mod => {
                settled = true;
                App.dds = mod;
                if (auctionOver()) renderResult();
            }).catch(() => {
                settled = true;
                App.ddsFailed = true;
                if (auctionOver()) renderResult();
            });
            setTimeout(() => {
                if (!settled) {
                    App.ddsFailed = true;
                    console.warn('WASM DDS did not initialize — using embedded tables');
                    if (auctionOver()) renderResult();
                }
            }, 10000);
        } else {
            App.ddsFailed = true;
        }

        App.boards = groupBoards(DATA.traces || []);
        App.boardByKey = {};
        for (const b of App.boards) App.boardByKey[b.key] = b;
        const selBoard = $('sel-board');
        for (const b of App.boards.slice(0, 60)) {
            const opt = el('option', null, b.label);
            opt.value = b.key;
            selBoard.appendChild(opt);
        }
        App.disputes = (DATA.mining.rows || []);
        const selDispute = $('sel-dispute');
        App.disputes.forEach((row, i) => {
            const tag = ((row.explanation && row.explanation.all_matched) || [])[0] || '–';
            const opt = el('option', null,
                `#${i + 1} board ${row.board.index} call ${row.call_index} ${row.seat.replace('Seat.', '')} ${row.bid} [${tag}]`);
            opt.value = String(i);
            selDispute.appendChild(opt);
        });

        $('btn-new-deal').onclick = newDeal;
        $('btn-reset').onclick = resetAuction;
        $('btn-load-board').onclick = openBoardModal;
        $('btn-board-cancel').onclick = closeBoardModal;
        $('btn-board-load').onclick = loadUserBoard;
        $('board-modal').addEventListener('click', e => {
            if (e.target === $('board-modal')) closeBoardModal();
        });
        $('btn-auto-step').onclick = () => {
            if (App.mode === 'live') { App.live.runner.stepAuto(); render(); }
            else replayStep(1);
        };
        $('btn-auto-run').onclick = () => {
            if (App.mode === 'live') { App.live.runner.runOut(); render(); }
            else replayStep(App.replay.rows.length);
        };
        selBoard.onchange = () => {
            const b = App.boardByKey[selBoard.value];
            if (b) { loadReplay(b.rows, 'corpus ' + b.label); selDispute.value = ''; }
        };
        selDispute.onchange = () => {
            const row = App.disputes[parseInt(selDispute.value, 10)];
            if (!row) return;
            const board = App.boardByKey[row.board.seed + ':' + row.board.index];
            if (board) loadReplay(board.rows, 'dispute on ' + board.label, row.call_index);
            else loadReplay([row], 'dispute row', row.call_index);
            selBoard.value = '';
        };
        $('tab-auction').onclick = () => showTab('auction');
        $('tab-data').onclick = () => { showTab('data'); renderDataTab(); };

        document.querySelectorAll('.special-bids .bid-btn').forEach(btn => {
            btn.onclick = () => {
                const s = btn.dataset.bid;
                humanBids(Call.parse(s));
            };
        });
        document.addEventListener('keydown', e => {
            if (e.key === 'Escape') { closeBoardModal(); return; }
            if (e.target.tagName === 'SELECT' || e.target.tagName === 'INPUT') return;
            if (e.key === 'a') $('btn-auto-step').click();
            if (e.key === 'r') $('btn-auto-run').click();
            if (e.key === 'n') newDeal();
        });

        renderDataTab();
        newDeal();
    }

    document.addEventListener('DOMContentLoaded', boot);
    globalThis.__bidApp = App;   // debugging / console access
})(globalThis.BidWeb, globalThis.DDS);
