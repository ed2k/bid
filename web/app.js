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
        live: {deal: null, runner: null, runnerId: 0},
        replay: null,
        boards: [],
        boardByKey: {},
        disputes: [],
        pendingLevel: null,
        dds: null,          // WASM DDS module once DDS.init() resolves
        ddsFailed: false,
        systems: {ns: 'improved', ew: 'improved'},
        engines: {},        // key -> engine (parsed once)
        reviewIdx: null,    // auction-table click: review this past decision
        sdsCache: {},       // sdsKey -> result
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
            if (App.reviewIdx != null) {
                const rec = r.record[App.reviewIdx];
                if (!rec) return null;
                return {seat: rec.seat, exp: rec.explanation,
                    history: r.history.slice(0, App.reviewIdx),
                    review: App.reviewIdx};
            }
            if (!r || r.isOver()) return null;
            return {seat: r.currentSeat(), exp: r.explain(), history: r.history};
        }
        const rp = App.replay;
        if (!rp || rp.idx < 0 || rp.idx >= rp.rows.length) return null;
        const idx = App.reviewIdx != null ? App.reviewIdx : rp.idx;
        const row = rp.rows[idx];
        if (!row) return null;
        if (!row.__exp) {
            row.__exp = Net.explain(App.net, BidWeb.Hand.parse(row.input.hand),
                (row.input.auction || []).map(s => Call.parse(s)),
                rowSeatValue(row.seat), rowSeatValue(row.board.dealer), row.board.vuln);
        }
        return {seat: rowSeatValue(row.seat), exp: row.__exp,
            history: (row.input.auction || []).map(s => Call.parse(s)),
            row, review: App.reviewIdx != null ? idx : null};
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
        // global call index of cell (r, c) — accounts for dealer offset
        const callIndexOf = (r, c) => r * 4 + (c - colOf(dealer));
        for (let r = 0; r < Math.max(rows.length, 1); r++) {
            const tr = el('tr');
            for (let c = 0; c < 4; c++) {
                const td = el('td');
                const call = rows[r] ? rows[r][c] : undefined;
                if (call) {
                    const idx = callIndexOf(r, c);
                    td.className = call.type === C.PASS ? 'call-PASS cell-click'
                        : call.type === C.BID ? 'call-bid cell-click' : 'call-X cell-click';
                    td.textContent = call.toString();
                    if (App.reviewIdx === idx) td.classList.add('cell-selected');
                    td.title = 'click to review this decision';
                    td.onclick = () => reviewCall(idx);
                } else {
                    td.className = 'future';
                    td.textContent = '';
                }
                tr.appendChild(td);
            }
            tbody.appendChild(tr);
        }
    }

    function reviewCall(idx) {
        if (App.mode === 'replay') {
            // jump the replay to the clicked recorded decision
            App.replay.idx = Math.min(idx, App.replay.rows.length - 1);
            render();
            return;
        }
        App.reviewIdx = App.reviewIdx === idx ? null : idx;
        render();
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
        if (App.reviewIdx != null) {
            const bar = el('div');
            bar.appendChild(el('span', 'tag tag-warn',
                'reviewing past decision #' + (App.reviewIdx + 1)));
            const back = el('button', 'btn btn-secondary', '← current');
            back.style.marginLeft = '8px';
            back.onclick = () => { App.reviewIdx = null; render(); };
            bar.appendChild(back);
            body.appendChild(bar);
        }
        if (auctionOver() && App.reviewIdx == null) {
            body.appendChild(el('p', 'muted',
                'Auction complete — click any bid in the auction table to review its explanation.'));
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
        } else if (App.reviewIdx == null) {
            body.appendChild(renderBelief(dec));
        }

        if (exp.kind === 'legacy') {
            renderLegacyRules(body, exp, dec);
        } else if (exp.kind === 'student') {
            renderStudentRanking(body, exp);
        } else if (exp.kind === 'cot') {
            renderCotExplanation(body, exp);
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

    /** Hidden-seat constraint estimates from the auction (legacy systems). */
    function renderBelief(dec) {
        const box = el('div');
        const beliefs = [];
        for (const s of [0, 1, 2, 3]) {
            if (s === dec.seat) continue;
            const m = App.live.runner.modelFor(s);
            if (!m || m.kind !== 'legacy') continue;
            const est = BidWeb.Belief.estimateDeal(m.system,
                App.live.runner.history, App.live.deal.dealer);
            if (est) beliefs.push([s, est[s]]);
        }
        if (!beliefs.length) return box;
        box.appendChild(el('h4', 'muted small',
            'hidden-hand estimates (bids intersect, passes carve — legacy systems)'));
        for (const [s, c] of beliefs) {
            box.appendChild(el('div', 'feature-chip',
                `${Seat.name(s)}: ${BidWeb.Belief.format(c)}`));
        }
        return box;
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

    /** Inspector for the CoT transformer: the generated reasoning, the
     *  extracted bid, and the legality verdict. */
    function renderCotExplanation(body, exp) {
        const head = el('p');
        head.appendChild(el('span', 'tag ' +
            (exp.fallback ? 'tag-warn' : 'tag-ok'),
            exp.fallback ? 'FALLBACK (' + exp.fallbackNote + ')' : 'generated bid'));
        head.appendChild(document.createTextNode('  ' +
            (exp.bid ? exp.bid.toString() : 'PASS')));
        if (exp.confidence !== null && exp.confidence !== undefined) {
            head.appendChild(document.createTextNode(
                `  · avg token confidence ${(exp.confidence * 100).toFixed(0)}%`));
        }
        body.appendChild(head);
        body.appendChild(el('h4', 'muted small', 'generated chain of thought'));
        const pre = el('pre', 'cot-text', exp.cotText || '(empty)');
        body.appendChild(pre);
        body.appendChild(el('p', 'muted small',
            'Greedy decode from the Python-trained transformer ' +
            '(web/models/cot). Legality-constrained: an illegal or unparseable ' +
            'bid falls back to the rule system.'));
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
        const reviewing = App.reviewIdx != null;
        const dec = currentDecision();
        const liveManual = App.mode === 'live' && !over && !reviewing;
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
            : (App.reviewIdx != null
                ? 'Reviewing a past call — click "← current" to resume.'
                : (App.mode === 'replay'
                    ? 'Replay mode — recorded calls are stepped through and verified.'
                    : 'Auction complete — start a new deal or reset.'));
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
        const sdsPanel = $('sds-panel');
        if (!over) { panel.classList.add('hidden'); sdsPanel.classList.add('hidden'); return; }

        // need all four hands for the solver
        const hands = knownHands();
        if (hands.some(h => !h)) {
            panel.classList.remove('hidden');
            $('dd-table').innerHTML = '';
            $('dd-par').textContent = 'Hidden hands present — DD table unavailable.';
            sdsPanel.classList.add('hidden');
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
        let parScoreNum = null;
        if (App.dds) {
            try {
                table = App.dds.calcDDTablePBN(pbn);
                const par = App.dds.calcParPBN(pbn, WASM_VULN[vuln] ?? 0);
                parContracts = (par.parContracts || []).join(', ');
                parScore = (par.parScore || []).join(' / ');
                const m = (par.parScore || ['NS 0'])[0].match(/NS\s+(-?\d+)/);
                parScoreNum = m ? parseInt(m[1], 10) : 0;
                source = 'WASM DDS';
            } catch (e) {
                $('dd-par').textContent = 'DDS error: ' + e.message;
                panel.classList.remove('hidden');
                renderSDS(deal, contract, null, embedded, boardKey);
                return;
            }
        } else if (embedded) {
            table = {resTable: embedded.dd_table};
            parContracts = embedded.par_contract + ' (' + embedded.par_score + ')';
            parScore = String(embedded.par_score);
            parScoreNum = embedded.par_score;
            source = 'native DDS @ export';
        } else {
            panel.classList.remove('hidden');
            $('dd-table').innerHTML = '';
            $('dd-par').textContent = App.ddsFailed
                ? 'WASM DDS unavailable here (needs http serving) — PBN: ' + pbn
                : 'Initializing WASM DDS…';
            renderSDS(deal, contract, null, embedded, boardKey);
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
        let ddTricks = null;
        for (let strain = 0; strain < 5; strain++) {
            const tr = el('tr');
            tr.appendChild(el('th', null, rows[strain]));
            for (let seat = 0; seat < 4; seat++) {
                const td = el('td', null, String(table.resTable[strain][seat]));
                if (contract && rows[strain] ===
                        ['C', 'D', 'H', 'S', 'NT'][contract.strain] &&
                    'NESW'[seat] === Seat.letter(contract.declarer)) {
                    td.classList.add('dd-cell-hit');
                    ddTricks = table.resTable[strain][seat];
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
        renderSDS(deal, contract, ddTricks, embedded, boardKey);
        renderDiagnostics(deal, contract, ddTricks,
            table ? table.resTable : null, parScoreNum, parContracts, history, vuln);
    }

    /** Diagnostics panel (port of diagnostics.py ParDiagnosticEngine). */
    function renderDiagnostics(deal, contract, ddTricks, resTable,
                               parScoreNum, parContractStr, history, vuln) {
        const panel = $('diag-panel');
        const body = $('diag-body');
        if (!contract || !resTable || parScoreNum === null) {
            panel.classList.add('hidden');
            return;
        }
        panel.classList.remove('hidden');
        body.innerHTML = '';
        const actualScore = BidWeb.SDS.contractScore(contract.level,
            ['C', 'D', 'H', 'S', 'NT'][contract.strain], contract.doubled,
            BidWeb.Vulnerability.isVulnerable(vuln, contract.declarer), ddTricks ?? 0);
        const d = BidWeb.Diagnostics.diagnose(deal, contract, actualScore,
            parScoreNum, parContractStr, resTable, history, vuln);
        const colors = {
            OPTIMAL_PAR: 'tag-ok',
            MISSED_GAME: 'tag-warn', MISSED_SLAM: 'tag-warn',
            SOFT_DEFENSE: 'tag-bad', OVERBID_DOWN: 'tag-bad',
            TAKEOUT_PASS: 'tag-bad',
        };
        const head = el('p');
        head.appendChild(el('span', 'tag ' + (colors[d.flaw] || 'tag-warn'), d.flaw));
        head.appendChild(document.createTextNode(
            `  regret ${d.regret >= 0 ? '+' : ''}${d.regret.toFixed(0)} pts` +
            (d.severity ? ` · severity ${d.severity.toFixed(0)}` : '')));
        body.appendChild(head);
        body.appendChild(el('p', 'small', d.advice));
    }

    /** SDS two-hand analysis panel (port of sds.py SDSScorer). */
    function renderSDS(deal, contract, ddTricks, embedded) {
        const panel = $('sds-panel');
        const body = $('sds-body');
        if (!contract) { panel.classList.add('hidden'); return; }
        panel.classList.remove('hidden');
        body.innerHTML = '';

        const strainLetter = ['C', 'D', 'H', 'S', 'NT'][contract.strain];
        const sdsKey = deal.toPBN().slice(0, 80) + ':' +
            Auction.contractString(contract) + Seat.letter(contract.declarer);
        if (App.sdsCache[sdsKey] === undefined) {
            if (App.dds) {
                let cond = null;
                if (App.mode === 'live') {
                    cond = {history: App.live.runner.history,
                        engineFor: s => App.live.runner.modelFor(s),
                        factor: 3};
                }
                const res = BidWeb.SDS.analyze(App.dds, deal, contract, 20, 42, cond);
                res.mode = 'sampled';
                App.sdsCache[sdsKey] = res;
            } else {
                // no WASM: report the exact-DD score from the embedded table
                App.sdsCache[sdsKey] = embedded && ddTricks != null ? {
                    mode: 'dd-only', ddTricks,
                    meanScore: BidWeb.SDS.contractScore(contract.level,
                        strainLetter, contract.doubled,
                        BidWeb.Vulnerability.isVulnerable(deal.vuln,
                            contract.declarer), ddTricks),
                } : {mode: 'none'};
            }
        }
        const sds = App.sdsCache[sdsKey];

        if (sds.mode === 'none') {
            body.appendChild(el('p', 'muted small',
                'SDS needs the WASM DDS (serve over http in a normal browser).'));
            return;
        }

        const needed = contract.level + 6;
        if (sds.mode === 'dd-only') {
            const p1 = el('p');
            p1.appendChild(el('strong', null,
                `exact-DD view: ${sds.ddTricks} tricks · score ${sds.meanScore}`));
            body.appendChild(p1);
            body.appendChild(el('p', 'muted small',
                'Two-hand sampling (P(make), world spread) needs the WASM DDS.'));
            return;
        }

        const head = el('p');
        head.appendChild(el('strong', null,
            `${sds.meanTricks.toFixed(2)} tricks ` +
            `(need ${needed}, full-deck DD ${ddTricks})`));
        body.appendChild(head);
        const tags = el('p');
        tags.appendChild(el('span', 'tag ' + (sds.pMake >= 0.5 ? 'tag-ok' : 'tag-warn'),
            `P(make) ${(sds.pMake * 100).toFixed(0)}%`));
        tags.appendChild(document.createTextNode(' '));
        tags.appendChild(el('span', 'tag ' +
            (sds.meanScore >= 0 ? 'tag-ok' : 'tag-bad'),
            `expected score ${sds.meanScore >= 0 ? '+' : ''}${sds.meanScore.toFixed(0)} ` +
            `(declarer view${sds.isVul ? ', vul' : ''})`));
        body.appendChild(tags);

        body.appendChild(el('h4', 'muted small', 'sampled worlds (green = makes)'));
        sds.tricks.forEach((t, i) => {
            const row = el('div', 'candidate-row');
            row.style.margin = '1px 0';
            const lbl = el('span', null, `#${i + 1} ${t}tr`);
            lbl.style.cssText = 'flex:0 0 58px;font-size:0.7rem;' +
                'font-family:ui-monospace,Menlo,monospace';
            row.appendChild(lbl);
            const bar = el('div');
            bar.style.cssText = 'flex:0 0 60%;height:7px;border-radius:3px;background:' +
                (t >= needed ? 'rgba(74,222,128,0.55)' : 'rgba(248,113,113,0.45)');
            row.appendChild(bar);
            body.appendChild(row);
        });
        body.appendChild(el('p', 'muted small',
            'Opponent layouts sampled from the declarer+dummy view, each solved ' +
            'double-dummy. A big gap vs full-deck DD means the contract relies ' +
            'on favourable splits.'));
    }

    // ---------- sources ----------

    function newDeal() {
        App.reviewIdx = null;
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
        App.reviewIdx = null;
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
        App.reviewIdx = null;
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
        const stratify = $('sel-student-stratify') ? $('sel-student-stratify').value : 'uniform';
        Lab.rows = BidWeb.StudentLab.buildCorpus(engine, deals, 7, null, stratify);
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

    /** Load the Python-trained CoT transformer (web/models/cot/) as a
     *  reviewable system.  The bid is generated greedily from the same
     *  weights refresh_student.py trained, legality-constrained like the
     *  Python side, with the reasoning shown in the inspector. */
    async function loadCotStudent() {
        try {
            const res = await fetch('models/cot/manifest.json');
            if (!res.ok) return;
            const manifest = await res.json();
            const wbuf = await (await fetch('models/cot/weights.bin')).arrayBuffer();
            const model = new BidWeb.CotStudent.CotModel(manifest, wbuf);
            const engine = BidWeb.CotStudent.makeEngine(model, manifest,
                Net, App.net);
            engine.key = 'student:cot';
            App.engines[engine.key] = engine;
            refreshSystemSelects();
            console.log('CoT student loaded — select it as a team system');
        } catch (e) {
            console.warn('CoT student unavailable:', e.message);
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

    /** A/B: dual-room duplicate match, student vs teacher (arena.py-style).
     *  Room A: teacher N/S vs student E/W.  Room B: student N/S vs teacher E/W.
     *  Each board's final contracts are scored with exact double-dummy tricks
     *  (WASM DDS) and converted to IMPs; contract-agreement stats reported too. */
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
        if (!App.dds) {
            labStatus('IMP scoring needs the WASM DDS — run in a normal browser tab');
        }
        labStatus(`dual-room match over ${boards} boards: ` +
            `${teacher.label} vs student…`);
        await new Promise(r => setTimeout(r, 30));

        let impsStudent = 0, winsStudent = 0, winsTeacher = 0, ties = 0;
        let identical = 0, sameStrain = 0, levelDelta = 0;
        const scored = !!App.dds;
        for (let i = 0; i < boards; i++) {
            const deal = BidWeb.Deal.random(i % 4, (i + 1) % 4, 1000 + i);
            const runA = new BidWeb.Auction.AuctionRunner(deal,
                {ns: teacher, ew: student}, 'manual');
            runA.runOut();
            const runB = new BidWeb.Auction.AuctionRunner(deal,
                {ns: student, ew: teacher}, 'manual');
            runB.runOut();
            const cA = runA.contract(), cB = runB.contract();
            if (cA && cB) {
                if (cA.level === cB.level && cA.strain === cB.strain &&
                    cA.declarer === cB.declarer) identical++;
                if (cA.strain === cB.strain) sameStrain++;
                levelDelta += Math.abs(cA.level - cB.level);
            }
            if (scored) {
                let table;
                try {
                    table = App.dds.calcDDTablePBN(deal.toPBN()).resTable;
                } catch (e) { continue; }
                const tricksFor = c => c ? table[['S', 'H', 'D', 'C', 'NT']
                    .indexOf(['C', 'D', 'H', 'S', 'NT'][c.strain])][c.declarer] : 0;
                const scoreNS = c => c ? BidWeb.SDS.contractScore(c.level,
                    ['C', 'D', 'H', 'S', 'NT'][c.strain], c.doubled,
                    BidWeb.Vulnerability.isVulnerable(deal.vuln, c.declarer),
                    tricksFor(c)) : 0;
                const diff = scoreNS(cA) - scoreNS(cB);   // + favors room-A NS team
                const imps = BidWeb.SDS.scoreToImp(diff);
                // room A: teacher sits N/S; room B: student sits N/S
                impsStudent += -imps;
                if (imps > 0) winsTeacher++;
                else if (imps < 0) winsStudent++;
                else ties++;
            }
            if (i % 4 === 3) {
                labStatus(`A/B board ${i + 1}/${boards}…`);
                await new Promise(r => setTimeout(r));
            }
        }
        const parts = [`identical contracts ${(identical / boards * 100).toFixed(0)}%`,
            `same strain ${(sameStrain / boards * 100).toFixed(0)}%`,
            `avg |level Δ| ${(levelDelta / boards).toFixed(2)}`];
        if (scored) {
            parts.push(`IMPs student-vs-teacher ${impsStudent >= 0 ? '+' : ''}${impsStudent}` +
                ` (${winsStudent}W/${winsTeacher}L/${ties}T over ${boards})`);
        }
        $('student-info-acc').textContent = parts.join(' · ');
        labStatus('A/B complete' + (scored ? ' (duplicate-scored)' :
            ' (agreement only — WASM DDS unavailable)'));
    }

    // ---------- system comparison (Python-first) --------------------------
    // A board's DD table, par, and PYTHON reference auctions are computed by
    // the Python engine at export time (web_export.py); every JS system then
    // plays the same board and is checked against the Python reference.

    async function compareSystems() {
        const modal = $('compare-modal');
        const statusEl = $('compare-status');
        const body = $('compare-body');
        modal.classList.remove('hidden');
        body.innerHTML = '';

        // board select (embedded, Python-computed boards)
        const boardKeys = Object.keys(DATA.python_auctions || {});
        if (!boardKeys.length) {
            statusEl.textContent = 'no Python-computed boards in the snapshot';
            return;
        }
        let sel = $('compare-board');
        if (!sel) {
            sel = el('select');
            sel.id = 'compare-board';
            sel.style.cssText = 'width:100%;margin-bottom:10px';
            body.appendChild(sel);
            sel.addEventListener('change', () => compareSystems());
        }
        const prev = sel.value;
        sel.innerHTML = '';
        for (const key of boardKeys) {
            const spec = (DATA.boards || {})[key];
            if (!spec) continue;
            const opt = el('option', null,
                `board ${key.replace(':', ' #')} — par ${spec.par_contract}`);
            opt.value = key;
            sel.appendChild(opt);
        }
        if (prev && boardKeys.includes(prev)) sel.value = prev;
        const boardKey = sel.value;

        const embedded = (DATA.boards || {})[boardKey];
        const refs = (DATA.python_auctions || {})[boardKey] || {};
        const resTable = embedded.dd_table;
        parScoreNum_cmp = embedded.par_score;
        const parContractStr = embedded.par_contract + ' (' + embedded.par_score + ')';
        statusEl.textContent = 'reconstructing the board…';

        // reconstruct the deal from the board's trace rows
        const boardRows = (DATA.traces || []).filter(r =>
            (r.board.seed + ':' + r.board.index) === boardKey);
        const hands = [null, null, null, null];
        for (const row of boardRows) {
            const s = rowSeatValue(row.seat);
            if (s !== undefined && !hands[s]) {
                try { hands[s] = BidWeb.Hand.parse(row.input.hand); } catch (e) {}
            }
        }
        if (hands.some(h => !h)) {
            statusEl.textContent = 'board hands incomplete in the snapshot';
            return;
        }
        const dealer = rowSeatValue(boardRows[0].board.dealer);
        const vuln = boardRows[0].board.vuln;
        const deal = new BidWeb.Deal(dealer, vuln, hands);

        // every reviewable system plays the board
        const entries = allSystemEntries();

        const results = [];
        for (let i = 0; i < entries.length; i++) {
            const [key, eng] = entries[i];
            statusEl.textContent = `(${i + 1}/${entries.length}) ${eng.label} bidding…`;
            await new Promise(r => setTimeout(r));
            try {
                const runner = new BidWeb.Auction.AuctionRunner(deal,
                    {ns: eng, ew: eng}, 'manual');
                runner.runOut();
                const contract = runner.contract();
                let tricks = null, scoreNS = 0;
                if (contract) {
                    tricks = resTable[['S', 'H', 'D', 'C', 'NT']
                        .indexOf(['C', 'D', 'H', 'S', 'NT'][contract.strain])][contract.declarer];
                    scoreNS = BidWeb.SDS.contractScore(contract.level,
                        ['C', 'D', 'H', 'S', 'NT'][contract.strain],
                        contract.doubled,
                        BidWeb.Vulnerability.isVulnerable(vuln, contract.declarer),
                        tricks);
                }
                const diag = BidWeb.Diagnostics.diagnose(deal, contract,
                    scoreNS, parScoreNum_cmp, parContractStr, resTable,
                    runner.history.slice(), vuln);
                const pyRef = refs[key] || null;
                results.push({key, label: eng.label, contract,
                    auction: runner.history.map(c => c.toString()).join(' '),
                    pyAuction: pyRef ? pyRef.auction.join(' ') : null,
                    pyContract: pyRef ? pyRef.contract : null,
                    tricks, scoreNS, diag});
            } catch (e) {
                results.push({key, label: eng.label, error: e.message});
            }
        }

        results.sort((a, b) => (b.scoreNS ?? -9999) - (a.scoreNS ?? -9999));
        const best = results.length ? results[0].scoreNS : null;
        statusEl.textContent = `par: ${parContractStr} — auctions checked ` +
            'against the PYTHON engine reference';

        const table = el('table', 'compare-table');
        const thead = el('thead');
        const hr = el('tr');
        for (const h of ['system', 'JS auction', 'PYTHON auction', 'contract (JS / py)',
                         'DD tricks', 'N/S score', 'vs par', 'diagnosis'])
            hr.appendChild(el('th', null, h));
        thead.appendChild(hr);
        table.appendChild(thead);
        const tb = el('tbody');
        for (const r of results) {
            const tr = el('tr');
            if (best !== null && r.scoreNS === best) tr.classList.add('best');
            tr.appendChild(el('td', null, r.label));
            if (r.error) {
                tr.appendChild(el('td', 'compare-auction', 'error: ' + r.error));
                for (let i = 0; i < 6; i++) tr.appendChild(el('td', null, '–'));
                tb.appendChild(tr);
                continue;
            }
            tr.appendChild(el('td', 'compare-auction', r.auction || '(passed out)'));
            // python reference + parity tag
            const tdPy = el('td', 'compare-auction');
            if (r.pyAuction !== null) {
                tdPy.appendChild(el('div', null, r.pyAuction || '(passed out)'));
                const suffix = r.contract.doubled === 1 ? 'X'
                    : r.contract.doubled === 2 ? 'XX' : '';
                const jsFull = r.contract.level +
                    BidWeb.STRAIN_NAMES[r.contract.strain] + suffix +
                    ' by ' + Seat.name(r.contract.declarer);
                const same = r.pyContract !== null && jsFull === r.pyContract;
                tdPy.appendChild(el('span', 'tag ' + (same ? 'tag-ok' : 'tag-warn'),
                    same ? 'JS == PYTHON ✓' : 'differs from PYTHON'));
            } else {
                tdPy.appendChild(el('span', 'muted small', 'no reference'));
            }
            tr.appendChild(tdPy);
            const suffix = r.contract.doubled === 1 ? 'X'
                : r.contract.doubled === 2 ? 'XX' : '';
            const jsContract = r.contract.level +
                BidWeb.STRAIN_NAMES[r.contract.strain] + suffix + ' by ' +
                Seat.name(r.contract.declarer);
            const tdC = el('td', 'mono');
            tdC.appendChild(el('div', null, jsContract));
            if (r.pyContract) {
                tdC.appendChild(el('div', 'muted small', r.pyContract));
            }
            tr.appendChild(tdC);
            tr.appendChild(el('td', 'mono', String(r.tricks)));
            const tdScore = el('td', 'mono ' + (r.scoreNS >= 0 ? 'score-pos' : 'score-neg'),
                (r.scoreNS >= 0 ? '+' : '') + r.scoreNS);
            tr.appendChild(tdScore);
            const delta = r.scoreNS - parScoreNum_cmp;
            tr.appendChild(el('td', 'mono ' + (delta >= 0 ? 'score-pos' : 'score-neg'),
                (delta >= 0 ? '+' : '') + delta));
            const tdDiag = el('td');
            const cls = r.diag.flaw === 'OPTIMAL_PAR' ? 'tag-ok'
                : (r.diag.flaw === 'MISSED_GAME' || r.diag.flaw === 'MISSED_SLAM') ? 'tag-warn'
                : 'tag-bad';
            tdDiag.appendChild(el('span', 'tag ' + cls, r.diag.flaw));
            if (r.diag.flaw !== 'OPTIMAL_PAR') {
                tdDiag.appendChild(el('div', 'muted small', r.diag.advice));
            }
            tr.appendChild(tdDiag);
            tb.appendChild(tr);
        }
        table.appendChild(tb);
        body.appendChild(table);
    }

    let parScoreNum_cmp = 0;

    /** Every reviewable system: all snapshot systems (parsed on demand) plus
     *  edited variants and student models, in stable display order. */
    function allSystemEntries() {
        const entries = [];
        for (const key of Object.keys(DATA.systems || {})) {
            const eng = engineFor(key);
            if (eng) entries.push([key, eng]);
        }
        for (const [key, eng] of Object.entries(App.engines)) {
            if (key.startsWith('edited:') || key.startsWith('student:')) {
                entries.push([key, eng]);
            }
        }
        const rank = k => k.startsWith('student:cot') ? 4
            : k.startsWith('student:') ? 5 : k.startsWith('edited:') ? 3 : 2;
        entries.sort(([a], [b]) => rank(a) - rank(b));
        return entries;
    }

    globalThis.__compare = compareSystems;   // debugging / console access

    // ---------- team contest: round robin, duplicate IMPs ------------------
    // Every unordered system pair meets over N Python-computed boards in two
    // rooms (A NS / B EW and B NS / A EW).  Each final contract is scored
    // with exact DD tricks and the difference converted on the WBF IMP
    // scale — a faithful port of arena.play_match's scoring.

    function contestAuction(deal, nsEngine, ewEngine) {
        const runner = new BidWeb.Auction.AuctionRunner(deal,
            {ns: nsEngine, ew: ewEngine}, 'manual');
        runner.runOut();
        return runner;
    }

    function scoreContractNS(contract, resTable, vuln) {
        if (!contract) return 0;
        const tricks = resTable[['S', 'H', 'D', 'C', 'NT']
            .indexOf(['C', 'D', 'H', 'S', 'NT'][contract.strain])][contract.declarer];
        const score = BidWeb.SDS.contractScore(contract.level,
            ['C', 'D', 'H', 'S', 'NT'][contract.strain], contract.doubled,
            BidWeb.Vulnerability.isVulnerable(vuln, contract.declarer), tricks);
        return {score, tricks};
    }

    async function runContest() {
        const statusEl = $('contest-status');
        const body = $('contest-body');
        body.innerHTML = '';
        const boardCount = Math.max(1, Math.min(40,
            parseInt($('in-contest-boards').value, 10) || 8));
        const includeCot = $('chk-contest-cot').checked;

        const boardKeys = Object.keys(DATA.python_auctions || {}).slice(0, boardCount);
        if (boardKeys.length < 1) {
            statusEl.textContent = 'no Python-computed boards in the snapshot';
            return;
        }

        const entries = allSystemEntries().filter(([key, eng]) =>
            eng.kind !== 'cot' || includeCot);
        if (entries.length < 2) {
            statusEl.textContent = 'need at least two systems';
            return;
        }

        // pre-reconstruct all boards once
        const boards = [];
        for (const key of boardKeys) {
            const embedded = (DATA.boards || {})[key];
            if (!embedded) continue;
            const rows = (DATA.traces || []).filter(r =>
                (r.board.seed + ':' + r.board.index) === key);
            const hands = [null, null, null, null];
            for (const row of rows) {
                const s = rowSeatValue(row.seat);
                if (s !== undefined && !hands[s]) {
                    try { hands[s] = BidWeb.Hand.parse(row.input.hand); } catch (e) {}
                }
            }
            if (hands.some(h => !h)) continue;
            boards.push({key, deal: new BidWeb.Deal(
                rowSeatValue(rows[0].board.dealer), rows[0].board.vuln, hands),
                resTable: embedded.dd_table, vuln: rows[0].board.vuln});
        }

        const totalPairs = entries.length * (entries.length - 1) / 2;
        const totalAuctions = totalPairs * 2 * boards.length;
        let doneAuctions = 0;
        statusEl.textContent = `0/${totalAuctions} auctions…`;

        const table = {imps: {}, wins: {}, losses: {}, ties: {}};
        for (const [, eng] of entries) {
            table.imps[eng.key] = 0; table.wins[eng.key] = 0;
            table.losses[eng.key] = 0; table.ties[eng.key] = 0;
        }

        const pairResults = [];
        for (let a = 0; a < entries.length; a++) {
            for (let b = a + 1; b < entries.length; b++) {
                const [, engA] = entries[a];
                const [, engB] = entries[b];
                let pairImpsA = 0;
                for (const board of boards) {
                    // room 1: A NS vs B EW
                    const cA = contestAuction(board.deal, engA, engB).contract();
                    // room 2: B NS vs A EW
                    const cB = contestAuction(board.deal, engB, engA).contract();
                    const sA = scoreContractNS(cA, board.resTable, board.vuln).score;
                    const sB = scoreContractNS(cB, board.resTable, board.vuln).score;
                    // A's match total = room1 NS score − room2 (B's NS score)
                    pairImpsA += BidWeb.SDS.scoreToImp(sA - sB);
                    doneAuctions += 2;
                    if (doneAuctions % 8 === 0) {
                        statusEl.textContent =
                            `${doneAuctions}/${totalAuctions} auctions · ` +
                            `now: ${engA.label} vs ${engB.label}`;
                        await new Promise(r => setTimeout(r));
                    }
                }
                // attribute: team A = the room-A NS side
                table.imps[engA.key] += pairImpsA;
                table.imps[engB.key] -= pairImpsA;
                if (pairImpsA > 0) { table.wins[engA.key]++; table.losses[engB.key]++; }
                else if (pairImpsA < 0) { table.wins[engB.key]++; table.losses[engA.key]++; }
                else { table.ties[engA.key]++; table.ties[engB.key]++; }
                pairResults.push({a: engA.label, b: engB.label, impsA: pairImpsA});
            }
        }

        const standings = entries.map(([, eng]) => ({
            label: eng.label, key: eng.key,
            imps: table.imps[eng.key], wins: table.wins[eng.key],
            losses: table.losses[eng.key], ties: table.ties[eng.key],
        })).sort((p, q) => q.imps - p.imps);

        statusEl.textContent = `contest complete: ${totalPairs} pairs × ` +
            `${boards.length} boards × 2 rooms (${totalAuctions} auctions)`;

        const h3 = el('h3', null, 'Standings');
        body.appendChild(h3);
        const table2 = el('table', 'compare-table');
        const thead = el('thead');
        const hr = el('tr');
        for (const h of ['#', 'system', 'IMPs', 'wins', 'losses', 'ties'])
            hr.appendChild(el('th', null, h));
        thead.appendChild(hr);
        table2.appendChild(thead);
        const tb = el('tbody');
        standings.forEach((r, i) => {
            const tr = el('tr');
            if (i === 0) tr.classList.add('best');
            tr.appendChild(el('td', null, String(i + 1)));
            tr.appendChild(el('td', null, r.label));
            const tdI = el('td', 'mono ' + (r.imps >= 0 ? 'score-pos' : 'score-neg'),
                (r.imps >= 0 ? '+' : '') + r.imps);
            tr.appendChild(tdI);
            tr.appendChild(el('td', 'mono', String(r.wins)));
            tr.appendChild(el('td', 'mono', String(r.losses)));
            tr.appendChild(el('td', 'mono', String(r.ties)));
            tb.appendChild(tr);
        });
        table2.appendChild(tb);
        body.appendChild(table2);

        body.appendChild(el('h3', null, 'Pair results (IMPs from A’s perspective)'));
        const pt = el('table', 'compare-table');
        const pthead = el('thead');
        const phr = el('tr');
        for (const h of ['room A NS', 'room B NS', 'IMPs (A)'])
            phr.appendChild(el('th', null, h));
        pthead.appendChild(phr);
        pt.appendChild(pthead);
        const ptb = el('tbody');
        for (const pr of pairResults) {
            const tr = el('tr');
            tr.appendChild(el('td', null, pr.a));
            tr.appendChild(el('td', null, pr.b));
            tr.appendChild(el('td', 'mono ' + (pr.impsA >= 0 ? 'score-pos' : 'score-neg'),
                (pr.impsA >= 0 ? '+' : '') + pr.impsA));
            ptb.appendChild(tr);
        }
        pt.appendChild(ptb);
        body.appendChild(pt);
    }

    // ---------- tabs / boot ----------

    // ---------- tabs / boot ----------    // ---------- tabs / boot ----------

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
        $('btn-compare').onclick = () => { compareSystems(); };
        $('btn-contest').onclick = () => {
            $('contest-modal').classList.remove('hidden');
        };
        $('btn-contest-close').onclick = () => $('contest-modal').classList.add('hidden');
        $('contest-modal').addEventListener('click', e => {
            if (e.target === $('contest-modal')) $('contest-modal').classList.add('hidden');
        });
        $('btn-contest-run').onclick = () => { runContest(); };
        $('btn-compare-close').onclick = () => $('compare-modal').classList.add('hidden');
        $('compare-modal').addEventListener('click', e => {
            if (e.target === $('compare-modal')) $('compare-modal').classList.add('hidden');
        });
        $('btn-load-board').onclick = openBoardModal;
        $('btn-board-cancel').onclick = closeBoardModal;
        $('btn-board-load').onclick = loadUserBoard;
        $('board-modal').addEventListener('click', e => {
            if (e.target === $('board-modal')) closeBoardModal();
        });
        $('btn-auto-step').onclick = async () => {
            if (App.mode === 'live') {
                await stepOnce();
                render();
            } else replayStep(1);
        };
        $('btn-auto-run').onclick = async () => {
            if (App.mode === 'live') {
                while (!App.live.runner.isOver()) {
                    await stepOnce();
                }
                render();
            } else replayStep(App.replay.rows.length);
        };
        async function stepOnce() {
            const r = App.live.runner;
            const usePidm = $('chk-pidm') && $('chk-pidm').checked;
            if (usePidm && App.dds && !r.isOver()) {
                const exp = r.explain();
                if (exp.legal.length > 1) {
                    const pick = BidWeb.PIDM.pick(App.dds, r, 4, 11);
                    r.applyCall(pick.call, exp, true);
                    return;
                }
            }
            r.stepAuto();
        }
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
        $('btn-student-id3').onclick = () => {
            if (!Lab.rows || !Lab.rows.length) { labStatus('generate a corpus first'); return; }
            const eng = labTeacherEngine();
            if (!eng || eng.kind !== 'net') {
                labStatus('ID3 ambiguity resolution needs a net-engine teacher (improved/champion/edited)');
                return;
            }
            const attached = BidWeb.ID3.resolveAmbiguities(eng.net, Lab.rows);
            if (!attached.length) {
                labStatus('no sufficiently-populated ambiguous decision groups found');
                return;
            }
            const totalRows = attached.reduce((a, x) => a + x.rows, 0);
            const avgAcc = attached.reduce((a, x) => a + x.acc * x.rows, 0) / totalRows;
            labStatus(`ID3 attached ${attached.length} refinement group(s) covering ` +
                `${totalRows} ambiguous decisions (fit accuracy ${(avgAcc * 100).toFixed(0)}%) ` +
                `— teacher "${eng.label}" now resolves them in live review`);
            $('student-info-acc').textContent =
                `ID3 refinements: ${attached.length} groups, ${totalRows} rows, ` +
                `fit ${(avgAcc * 100).toFixed(0)}%`;
        };
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
        loadCotStudent();       // the real transformer student, if exported
        newDeal();
    }

    document.addEventListener('DOMContentLoaded', boot);
    globalThis.__bidApp = App;   // debugging / console access
})(globalThis.BidWeb, globalThis.DDS);
