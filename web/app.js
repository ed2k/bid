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
        systems: {ns: 'improved', ew: 'improved'},
        engines: {},        // key -> engine (parsed once)
    };

    /** Parse and cache a reviewable system from the snapshot. */
    function engineFor(key) {
        if (App.engines[key]) return App.engines[key];
        const spec = (DATA.systems || {})[key];
        if (!spec) return null;
        let engine;
        if (spec.format === 'legacy') {
            engine = {kind: 'legacy', system: BidWeb.Legacy.parse(spec.text, key)};
        } else {
            engine = {kind: 'net', net: BidWeb.DSL.parse(spec.text, key)};
        }
        engine.key = key;
        engine.label = spec.label;
        engine.ruleCount = spec.python_rule_count;
        App.engines[key] = engine;
        return engine;
    }

    /** Register a student as a reviewable system and refresh team selects. */
    function registerStudentEngine(key, loaded, label) {
        const eng = BidWeb.StudentEngine.make(loaded, label);
        eng.key = key;
        App.engines[key] = eng;
        refreshSystemSelects();
        return eng;
    }

    /** Rebuild the N/S and E/W selects: snapshot systems + edited + students. */
    function refreshSystemSelects() {
        for (const side of ['ns', 'ew']) {
            const sel = $('sel-system-' + side);
            const prev = sel.value;
            sel.innerHTML = '';
            const add = (value, label) => {
                const opt = el('option', null, label);
                opt.value = value;
                sel.appendChild(opt);
            };
            for (const [key, spec] of Object.entries(DATA.systems || {})) {
                add(key, `${spec.label} (${spec.python_rule_count ?? '?'} rules)`);
            }
            for (const [key, eng] of Object.entries(App.engines)) {
                if (key.startsWith('edited:')) add(key, eng.label);
                if (key.startsWith('student:')) add(key, eng.label);
            }
            if ([...sel.options].some(o => o.value === prev)) sel.value = prev;
            sel.onchange = () => {
                App.systems[side] = sel.value;
                if (App.mode === 'live') resetAuction();   // restart with new systems
            };
        }
    }

    function buildModels() {
        return {ns: engineFor(App.systems.ns), ew: engineFor(App.systems.ew)};
    }

    function teamLabel(seat) {
        const key = (seat === 0 || seat === 2) ? App.systems.ns : App.systems.ew;
        const eng = App.engines[key];
        if (eng) return eng.label;
        const spec = (DATA.systems || {})[key];
        return spec ? spec.label : key;
    }

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
            seatEl.querySelector('.seat-name').textContent = Seat.name(s);
            const sysEl = seatEl.querySelector('.seat-system');
            if (sysEl) sysEl.textContent = teamLabel(s);
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
            el('strong', null, Seat.name(dec.seat) + '  (' + teamLabel(dec.seat) + ')'));

        body.appendChild(el('h4', 'muted small', 'features (JS port)'));
        body.appendChild(featureChips(exp.features));

        if (App.mode === 'replay') {
            body.appendChild(replayVerification(dec));
        }

        if (exp.kind === 'legacy') {
            renderLegacyRules(body, exp, dec);
        } else if (exp.kind === 'student') {
            renderStudentRanking(body, exp);
        } else {
            const model = App.mode === 'live'
                ? App.live.runner.modelFor(dec.seat) : null;
            const total = (model && model.net) ? model.net.rules.length
                : App.net.rules.length;
            body.appendChild(el('h4', 'muted small',
                `rules matched (${exp.matchedIds.length}/${total})`));
            for (const rr of exp.ruleResults.filter(r => r.matched)) {
                body.appendChild(ruleBlock(rr));
            }
            if (!exp.matchedIds.length) {
                body.appendChild(el('p', 'muted small',
                    'No positive rule matched → PASS fallback.'));
            }
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
        const auto = App.mode === 'live'
            ? App.live.runner.autoCall()
            : Net.autoSelect(App.net, exp);
        $('system-call-hint').textContent =
            'System pick: ' + auto.toString();
    }

    /** Inspector section for the neural student: probability ranking with
     *  legality marks and the constrained choice. */
    function renderStudentRanking(body, exp) {
        body.appendChild(el('h4', 'muted small',
            `bid probability ranking (${exp.label || 'student'})`));
        const top = exp.ranking.slice(0, 8);
        const maxP = Math.max(...top.map(r => r.prob), 0.0001);
        for (const r of top) {
            const row = el('div', 'candidate-row');
            row.style.margin = '2px 0';
            const bid = el('span', 'call-chip' +
                (r.legal ? '' : ' illegal') +
                (exp.chosen && exp.chosen.bid === r.bid ? ' chosen' : ''),
                r.bid + '  ' + (r.prob * 100).toFixed(1) + '%');
            bid.style.flex = '0 0 110px';
            row.appendChild(bid);
            const bar = el('div');
            bar.style.cssText = `flex:1;height:8px;border-radius:4px;` +
                `background:rgba(56,189,248,${0.15 + 0.55 * (r.prob / maxP)})`;
            row.appendChild(bar);
            if (!r.legal) {
                row.appendChild(el('span', 'tag tag-bad', 'illegal'));
            }
            body.appendChild(row);
        }
        if (exp.chosen) {
            const line = el('p');
            line.appendChild(el('span', 'tag tag-ok', 'CHOSEN (legality-constrained)'));
            line.appendChild(document.createTextNode('  ' + exp.chosen.bid +
                (exp.chosen.prob !== null ? `  p=${(exp.chosen.prob * 100).toFixed(1)}%` : '')));
            body.appendChild(line);
        }
        if (exp.suppressed) {
            body.appendChild(el('p', 'tag tag-warn',
                `highest-ranked illegal call ${exp.suppressed} → vetoed by constrained decoding`));
        }
        if (exp.fallbackPass) {
            body.appendChild(el('p', 'tag tag-warn', 'no legal bid in vocab → PASS'));
        }
    }

    /** Inspector section for legacy (translator) systems. */
    function renderLegacyRules(body, exp, dec) {
        const hand = App.live.deal.hands[dec.seat];
        body.appendChild(el('h4', 'muted small',
            `rules matched (${exp.applied.length}, priority order)`));
        if (!exp.applied.length) {
            body.appendChild(el('p', 'muted small',
                'No rule triggered → PASS.'));
            return;
        }
        exp.applied.forEach((rule, i) => {
            const block = el('div', 'rule-block' + (i === 0 ? '' : ' rule-unmatched'));
            if (i === 0) {
                const sel = el('span', 'tag tag-ok', 'SELECTED');
                block.appendChild(sel);
                block.appendChild(document.createTextNode(' '));
            }
            const head = el('div', 'rule-head');
            head.appendChild(document.createTextNode(
                rule.description + ' → ' + rule.call.toString()));
            head.appendChild(el('span', 'prio', '  prio ' + rule.priority));
            block.appendChild(head);
            const ul = el('ul', 'cond-list');
            for (const chk of BidWeb.Legacy.constraintsDetail(rule.constraints, hand)) {
                ul.appendChild(el('li', chk.ok ? 'cond-ok' : 'cond-fail',
                    `${chk.label}  [${formatVal(chk.actual)}]`));
            }
            block.appendChild(ul);
            body.appendChild(block);
        });
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
        App.live.runner = new Auction.AuctionRunner(App.live.deal, buildModels(), 'manual');
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
        App.live.runner = new Auction.AuctionRunner(App.live.deal, buildModels(), 'manual');
        $('info-source').textContent = 'custom board (user input)';
        $('info-dealer-vuln').textContent = Seat.name(dealer) + ' / ' +
            BidWeb.Vulnerability.label(vuln);
        closeBoardModal();
        render();
    }

    function resetAuction() {
        App.pendingLevel = null;
        if (App.mode === 'live') {
            App.live.runner = new Auction.AuctionRunner(App.live.deal, buildModels(), 'manual');
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

    // ---------- rules editor ----------

    const Rules = {key: null, baseline: '', edited: {}};

    function rulesStatus(text, cls) {
        const elx = $('rules-status-text');
        elx.textContent = text;
        elx.className = 'val ' + (cls || '');
    }

    function rulesSourceText(key) {
        return Rules.edited[key] !== undefined
            ? Rules.edited[key] : (DATA.systems[key] || {}).text || '';
    }

    function selectRulesSystem(key) {
        Rules.key = key;
        const spec = DATA.systems[key] || {};
        $('sel-rules-system').value = key;
        $('rules-text').value = rulesSourceText(key);
        const edited = Rules.edited[key] !== undefined;
        rulesStatus(`${spec.label || key} — ${spec.format} engine, ` +
            `${spec.python_rule_count ?? '?'} rules in snapshot` +
            (edited ? ' · LOCAL EDITS ACTIVE' : ''), edited ? 'dirty' : '');
    }

    function rulesTextChanged() {
        if (!Rules.key) return;
        const cur = $('rules-text').value;
        const hasEdits = cur !== (DATA.systems[Rules.key] || {}).text;
        if (hasEdits) Rules.edited[Rules.key] = cur;
        else delete Rules.edited[Rules.key];
        rulesStatus(hasEdits ? 'edited (not yet applied)'
            : `${Rules.key} — matches snapshot`, hasEdits ? 'dirty' : '');
    }

    /** Parse the edited text; on success register the engine and assign it
     *  to the given team, restarting the live auction. Returns true on success. */
    function applyRules(side) {
        if (!Rules.key) return false;
        const text = $('rules-text').value;
        const spec = DATA.systems[Rules.key] || {};
        let engine;
        try {
            if (spec.format === 'legacy') {
                const parsed = BidWeb.Legacy.parse(text, Rules.key + '_edited');
                if (!parsed.rules.length) throw new Error('no rules parsed');
                engine = {kind: 'legacy', system: parsed};
            } else {
                const parsed = BidWeb.DSL.parse(text, Rules.key + '_edited');
                if (!parsed.rules.length) throw new Error('no rules parsed');
                engine = {kind: 'net', net: parsed};
            }
        } catch (e) {
            rulesStatus('Parse FAILED: ' + e.message, 'error');
            return false;
        }
        engine.key = 'edited:' + Rules.key;
        engine.label = `Edited ${spec.label || Rules.key} (local)`;
        engine.ruleCount = engine.net ? engine.net.rules.length
            : engine.system.rules.length;
        App.engines[engine.key] = engine;

        // make the edited engine selectable and current for the team
        const optKey = 'edited:' + Rules.key;
        refreshSystemSelects();
        App.systems[side] = optKey;
        $('sel-system-' + side).value = optKey;

        Rules.edited[Rules.key] = text;
        rulesStatus(`applied to ${side.toUpperCase()} — ${engine.ruleCount} rules ` +
            'parsed from edited DSL', 'applied');
        if (App.mode === 'live') resetAuction();
        return true;
    }

    function downloadRules() {
        const key = Rules.key || 'system';
        const text = $('rules-text').value;
        const blob = new Blob([text], {type: 'text/plain'});
        const a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = key.replace(/[^a-z0-9_]+/gi, '_') + '_edited.dsl';
        document.body.appendChild(a);
        a.click();
        a.remove();
        setTimeout(() => URL.revokeObjectURL(a.href), 2000);
        rulesStatus(`downloaded ${a.download} (${text.split('\n').length} lines)`,
            'applied');
    }

    function revertRules() {
        if (!Rules.key) return;
        delete Rules.edited[Rules.key];
        $('rules-text').value = (DATA.systems[Rules.key] || {}).text || '';
        rulesStatus('reverted to snapshot version');
    }

    function renderRulesTab() {
        const sel = $('sel-rules-system');
        if (!sel.options.length) {
            for (const [key, spec] of Object.entries(DATA.systems || {})) {
                const opt = el('option', null,
                    `${spec.label} (${spec.format}, ${spec.python_rule_count ?? '?'} rules)`);
                opt.value = key;
                sel.appendChild(opt);
            }
            sel.addEventListener('change', () => selectRulesSystem(sel.value));
        }
        if (!Rules.key && sel.options.length) selectRulesSystem(sel.value);
    }

    // ---------- student lab ----------

    const Lab = {rows: null, dataset: null, trained: null, loaded: null, teacher: 'improved'};

    function labStatus(text) { $('student-info-status').textContent = text; }

    function labTeacherEngine() {
        // prefer a live (possibly edited) engine over the raw snapshot text
        const key = Lab.teacher;
        if (App.engines[key]) return App.engines[key];
        const spec = (DATA.systems || {})[key];
        if (!spec) return null;
        return engineFor(key);
    }

    async function labGenerate() {
        const engine = labTeacherEngine();
        if (!engine) { labStatus('no teacher system available'); return; }
        const deals = Math.max(10, Math.min(400, parseInt($('in-student-deals').value, 10) || 100));
        labStatus(`generating ${deals} boards with ${engine.label}…`);
        await new Promise(r => setTimeout(r, 30));   // let the status paint
        Lab.rows = BidWeb.StudentLab.buildCorpus(engine, deals, 7);
        Lab.dataset = BidWeb.StudentLab.encodeDataset(Lab.rows);
        $('student-info-corpus').textContent =
            `${Lab.rows.length} decisions / ${deals} boards · ` +
            `${Lab.dataset.vocab.length} distinct bids · ` +
            `forced ${Lab.rows.filter(r => r.forced).length}`;
        labStatus('corpus ready — train the student');
    }

    async function labTrain() {
        if (!Lab.dataset) { labStatus('generate a corpus first'); return; }
        const epochs = Math.max(2, Math.min(60, parseInt($('in-student-epochs').value, 10) || 12));
        labStatus(`training ${epochs} epochs…`);
        const {model, log} = await new Promise(resolve => {
            const result = BidWeb.StudentLab.train(Lab.dataset.X, Lab.dataset.y,
                Lab.dataset.vocab, {
                    epochs,
                    onEpoch: e => {
                        $('student-info-train').textContent =
                            `epoch ${e.epoch}/${epochs} · loss ${e.loss.toFixed(3)}`;
                    },
                });
            // yield between epochs is handled inside train via onEpoch sync;
            // release the thread once now that it is done
            setTimeout(() => resolve(result), 20);
        });
        Lab.trained = model;
        const last = log[log.length - 1];
        $('student-info-train').textContent = `done · final loss ${last.loss.toFixed(3)}`;
        $('student-info-acc').textContent =
            `${(last.valAcc * 100).toFixed(1)}% (majority baseline ${(last.baselineAcc * 100).toFixed(1)}%)`;
        labStatus('student trained — save it or evaluate it');
        // the trained student becomes a reviewable system for either team
        registerStudentEngine('student:lab', {model, meta: {
            teacher: Lab.teacher, corpus_rows: Lab.rows ? Lab.rows.length : 0}},
            `Student (Lab-trained on ${Lab.teacher})`);
    }

    function labDownload() {
        if (!Lab.trained) { labStatus('train a student first'); return; }
        const teacherSpec = (DATA.systems || {})[Lab.teacher];
        const payload = BidWeb.StudentLab.serialize(Lab.trained, {
            teacher: Lab.teacher,
            teacher_label: teacherSpec ? teacherSpec.label : Lab.teacher,
            created: new Date().toISOString(),
            corpus_rows: Lab.rows ? Lab.rows.length : 0,
            feature_dim: BidWeb.StudentLab.FEATURE_DIM,
        });
        const blob = new Blob([JSON.stringify(payload)], {type: 'application/json'});
        const a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = 'student_web.json';
        document.body.appendChild(a);
        a.click();
        a.remove();
        setTimeout(() => URL.revokeObjectURL(a.href), 2000);
        labStatus('saved student_web.json');
    }

    function labEvaluateLoaded() {
        if (!Lab.loaded) { labStatus('load a student.json first'); return; }
        if (!Lab.dataset) { labStatus('generate a corpus to evaluate against'); return; }
        const res = BidWeb.StudentLab.evaluate(Lab.loaded.model, Lab.dataset.X,
            Lab.dataset.y, Lab.dataset.vocab);
        $('student-info-acc').textContent =
            `loaded student ${(res.acc * 100).toFixed(1)}% on current corpus (${res.n} rows)`;
        labStatus('loaded student evaluated' +
            (Lab.loaded.meta.created ? ` (created ${Lab.loaded.meta.created})` : ''));
    }

    function renderStudentTab() {
        if (!Lab.trained && Lab.loaded) {
            const m = Lab.loaded.meta || {};
            const isDefault = globalThis.BID_DEFAULT_STUDENT &&
                Lab.loaded.meta === globalThis.BID_DEFAULT_STUDENT.meta;
            labStatus((isDefault ? 'default student loaded' : 'student loaded') +
                (m.val_acc !== undefined
                    ? ` — snapshot-time val ${(m.val_acc * 100).toFixed(1)}% ` +
                      `vs baseline ${(m.baseline_acc * 100).toFixed(1)}%` : ''));
            $('student-info-corpus').textContent = m.corpus_rows
                ? `trained on ${m.corpus_rows} rows` : '–';
            $('student-info-train').textContent = m.teacher
                ? `teacher: ${m.teacher_label || m.teacher}` : '–';
        }
        const sel = $('sel-student-teacher');
        const prev = sel.value || Lab.teacher;
        sel.innerHTML = '';
        const add = (value, label) => {
            const opt = el('option', null, label);
            opt.value = value;
            sel.appendChild(opt);
        };
        for (const [key, spec] of Object.entries(DATA.systems || {})) {
            add(key, spec.label);
        }
        for (const [key, eng] of Object.entries(App.engines)) {
            if (key.startsWith('edited:') || key.startsWith('student:')) {
                add(key, eng.label);
            }
        }
        sel.value = prev in (DATA.systems || {}) || App.engines[prev] ? prev : Lab.teacher;
        sel.onchange = () => {
            Lab.teacher = sel.value;
            Lab.rows = Lab.dataset = Lab.trained = null;
            $('student-info-corpus').textContent = '–';
            $('student-info-train').textContent = '–';
            $('student-info-acc').textContent = '–';
            labStatus('teacher changed — regenerate the corpus');
        };
    }

    async function labLoadFile(file) {
        try {
            const text = await file.text();
            Lab.loaded = BidWeb.StudentLab.load(JSON.parse(text));
            labStatus(`loaded ${file.name}` +
                (Lab.loaded.meta.teacher ? ` (teacher: ${Lab.loaded.meta.teacher})` : ''));
            $('student-info-corpus').textContent = Lab.loaded.meta.corpus_rows
                ? `trained on ${Lab.loaded.meta.corpus_rows} rows` : '–';
            registerStudentEngine('student:loaded', Lab.loaded,
                `Student (loaded: ${Lab.loaded.meta.teacher || 'unknown teacher'})`);
        } catch (e) {
            labStatus('load failed: ' + e.message);
        }
    }

    /** Load the shipped default student (web/student_default.js) if present. */
    function loadDefaultStudent() {
        const d = globalThis.BID_DEFAULT_STUDENT;
        if (!d) return false;
        try {
            Lab.loaded = BidWeb.StudentLab.load(d);
            return true;
        } catch (e) {
            console.warn('default student failed to load:', e.message);
            return false;
        }
    }

    /** A/B: student vs teacher over N boards — contract-agreement stats. */
    async function labCompare() {
        const teacher = labTeacherEngine();
        const studentLoaded = Lab.trained ? {model: Lab.trained, meta: {}}
            : (Lab.loaded || globalThis.BID_DEFAULT_STUDENT);
        if (!teacher || !studentLoaded) {
            labStatus('need both a teacher and a student (train or load one first)');
            return;
        }
        const student = BidWeb.StudentEngine.make(studentLoaded, 'student');
        const boards = 20;
        labStatus(`A/B over ${boards} boards: ${teacher.label} vs student…`);
        await new Promise(r => setTimeout(r, 30));

        let identical = 0, sameStrain = 0, levelDelta = 0, contracts = 0;
        for (let i = 0; i < boards; i++) {
            const deal = BidWeb.Deal.random(i % 4, (i + 1) % 4, 1000 + i);
            const rt = new BidWeb.Auction.AuctionRunner(deal, teacher, 'manual');
            rt.runOut();
            const rs = new BidWeb.Auction.AuctionRunner(deal, student, 'manual');
            rs.runOut();
            const ct = rt.contract(), cs = rs.contract();
            if (!ct && !cs) { identical++; continue; }
            if (!ct || !cs) { contracts++; levelDelta += 1; continue; }
            contracts++;
            if (ct.level === cs.level && ct.strain === cs.strain &&
                ct.declarer === cs.declarer) identical++;
            if (ct.strain === cs.strain) sameStrain++;
            levelDelta += Math.abs(ct.level - cs.level);
        }
        $('student-info-acc').textContent =
            `identical contracts ${(identical / boards * 100).toFixed(0)}% · ` +
            `same strain ${(sameStrain / boards * 100).toFixed(0)}% · ` +
            `avg |level Δ| ${(levelDelta / boards).toFixed(2)}`;
        labStatus(`A/B complete: student vs ${teacher.label} over ${boards} boards`);
    }

    // ---------- tabs / boot ----------

    function showTab(name) {
        $('view-auction').classList.toggle('hidden', name !== 'auction');
        $('view-data').classList.toggle('hidden', name !== 'data');
        $('view-rules').classList.toggle('hidden', name !== 'rules');
        $('view-student').classList.toggle('hidden', name !== 'student');
        $('tab-auction').classList.toggle('active', name === 'auction');
        $('tab-data').classList.toggle('active', name === 'data');
        $('tab-rules').classList.toggle('active', name === 'rules');
        $('tab-student').classList.toggle('active', name === 'student');
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
        // per-team bidding-system selects (net + legacy engines)
        refreshSystemSelects();
        for (const side of ['ns', 'ew']) {
            $('sel-system-' + side).value = App.systems[side];
        }

        selBoard.onchange = () => {
            const b = App.boardByKey[selBoard.value];
            if (b) { loadReplay(b.rows, 'corpus ' + b.label); selDispute.value = ''; }
        };        selDispute.onchange = () => {
            const row = App.disputes[parseInt(selDispute.value, 10)];
            if (!row) return;
            const board = App.boardByKey[row.board.seed + ':' + row.board.index];
            if (board) loadReplay(board.rows, 'dispute on ' + board.label, row.call_index);
            else loadReplay([row], 'dispute row', row.call_index);
            selBoard.value = '';
        };
        $('tab-auction').onclick = () => showTab('auction');
        $('tab-data').onclick = () => { showTab('data'); renderDataTab(); };
        $('tab-rules').onclick = () => { showTab('rules'); renderRulesTab(); };
        $('tab-student').onclick = () => { showTab('student'); renderStudentTab(); };
        $('btn-student-generate').onclick = () => { labGenerate(); };
        $('btn-student-train').onclick = () => { labTrain(); };
        $('btn-student-download').onclick = labDownload;
        $('btn-student-eval').onclick = labEvaluateLoaded;
        $('btn-student-ab').onclick = () => { labCompare(); };
        $('in-student-file').addEventListener('change', e => {
            if (e.target.files && e.target.files[0]) labLoadFile(e.target.files[0]);
        });
        $('btn-rules-apply-ns').onclick = () => applyRules('ns');
        $('btn-rules-apply-ew').onclick = () => applyRules('ew');
        $('btn-rules-download').onclick = downloadRules;
        $('btn-rules-reset').onclick = revertRules;
        $('rules-text').addEventListener('input', rulesTextChanged);

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
        loadDefaultStudent();   // ship with a ready-to-use student
        if (Lab.loaded) {
            registerStudentEngine('student:default', Lab.loaded,
                'Student (default MLP)');
        }
        newDeal();
    }

    document.addEventListener('DOMContentLoaded', boot);
    globalThis.__bidApp = App;   // debugging / console access
})(globalThis.BidWeb, globalThis.DDS);
