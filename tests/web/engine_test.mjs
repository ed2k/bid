/**
 * engine_test.mjs — cross-validates the browser JS engine against ground
 * truth recorded by the Python engine in web/review_data.js:
 *
 *   1. the embedded DSL parses to the same number of rules;
 *   2. for every recorded corpus trace row, the JS feature extractor
 *      reproduces the Python-computed feature values exactly (all ported keys);
 *   3. the JS candidate set at each recorded decision equals the recorded
 *      candidate set (`ev`) and contains the recorded bid.
 *
 * Run: node tests/web/engine_test.mjs
 */
import {readFileSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import {dirname, join} from 'node:path';

const root = join(dirname(fileURLToPath(import.meta.url)), '..', '..');

for (const f of ['objects.js', 'features.js', 'bid_dsl.js', 'system_dsl.js',
                 'bid_net.js', 'auction.js', 'student_lab.js',
                 'student_engine.js']) {
    (0, eval)(readFileSync(join(root, 'web', f), 'utf8'));
}
let DEFAULT_STUDENT = null;
try {
    (0, eval)(readFileSync(join(root, 'web', 'student_default.js'), 'utf8'));
    DEFAULT_STUDENT = globalThis.BID_DEFAULT_STUDENT;
} catch (e) { /* optional artifact */ }
(0, eval)(readFileSync(join(root, 'web', 'review_data.js'), 'utf8'));

const BidWeb = globalThis.BidWeb;
const DATA = globalThis.BID_REVIEW_DATA;

let passed = 0, failed = 0;
function check(name, ok, detail) {
    if (ok) { passed++; }
    else { failed++; console.error(`FAIL ${name}${detail ? ': ' + detail : ''}`); }
}

// ---- 1. DSL parse ---------------------------------------------------------

const net = BidWeb.DSL.parse(DATA.dsl, 'ImprovedSystem');
check('dsl: parses rules', net.rules.length >= 60,
    `got ${net.rules.length} rules`);
check('dsl: has 1NT opening', net.rules.some(r => r.ruleId === 'R_1NT'),
    'R_1NT missing');

// ---- 2/3. replay recorded corpus rows -------------------------------------

const KEYS = Object.keys(DATA.traces[0]?.input?.features || {});
const portedExpectation = ['hcp', 'is_opening', 'spade_len', 'partner_last_call',
    'support_in_partner_suit', 'is_balancing', 'vuln_pressure'];
for (const k of portedExpectation) {
    check(`features: recorded rows contain ${k}`, KEYS.includes(k));
}

const seatByName = {NORTH: 0, EAST: 1, SOUTH: 2, WEST: 3};

function seatValue(v) {
    if (typeof v === 'number') return v;
    if (typeof v === 'string') {
        if (seatByName[v] !== undefined) return seatByName[v];
        if (seatByName[v.replace('Seat.', '')] !== undefined) return seatByName[v.replace('Seat.', '')];
        if (seatByName[{N: 'NORTH', E: 'EAST', S: 'SOUTH', W: 'WEST'}[v]] !== undefined)
            return seatByName[{N: 'NORTH', E: 'EAST', S: 'SOUTH', W: 'WEST'}[v]];
    }
    throw new Error('bad seat ' + JSON.stringify(v));
}

let featureCheckedRows = 0;
let featureMismatches = 0;
let candidateChecked = 0, candidateInSet = 0, evExact = 0, evChecked = 0;
const mismatchDetails = [];

for (const row of DATA.traces) {
    const dealer = seatValue(row.board.dealer);
    const vuln = row.board.vuln;
    const seat = seatValue(row.seat);
    const hand = BidWeb.Hand.parse(row.input.hand);
    const history = (row.input.auction || []).map(s => BidWeb.Call.parse(s));
    const callIndex = typeof row.call_index === 'number'
        ? row.call_index : history.length;

    // the recorded history must be the prefix before call_index
    check('trace: auction is prefix', history.length === callIndex,
        `row board ${row.board?.index}: auction ${history.length} vs call_index ${callIndex}`);

    const exp = BidWeb.Net.explain(net, hand, history, seat, dealer, vuln);

    // 2. feature parity on every ported key
    featureCheckedRows++;
    for (const key of Object.keys(exp.features)) {
        if (!(key in row.input.features)) continue;   // not recorded -> skip
        const js = exp.features[key];
        const py = row.input.features[key];
        if (typeof py === 'number' && typeof js === 'number') {
            if (Math.abs(py - js) > 1e-9) {
                featureMismatches++;
                if (mismatchDetails.length < 10)
                    mismatchDetails.push(`board ${row.board?.index} call ${callIndex} seat ${row.seat}: ${key} js=${js} py=${py}`);
            }
        } else if (js !== py) {
            featureMismatches++;
            if (mismatchDetails.length < 10)
                mismatchDetails.push(`board ${row.board?.index} call ${callIndex} seat ${row.seat}: ${key} js=${JSON.stringify(js)} py=${JSON.stringify(py)}`);
        }
    }

    // 3. recorded bid must be in the JS legal candidate set; `ev` must match
    const bid = BidWeb.Call.parse(row.bid);
    if (exp.legal.some(c => c.equals(bid))) candidateInSet++;
    candidateChecked++;
    if (Array.isArray(row.ev) && row.ev.length) {
        evChecked++;
        const evCalls = row.ev.map(s => BidWeb.Call.parse(s));
        const same = evCalls.length === exp.legal.length &&
            evCalls.every(c => exp.legal.some(l => l.equals(c)));
        if (same) evExact++;
    }
}

check('features: all ported keys match Python on corpus rows',
    featureMismatches === 0,
    `${featureMismatches} mismatches over ${featureCheckedRows} rows\n  ` +
    mismatchDetails.join('\n  '));

check('candidates: recorded bid always in JS legal set',
    candidateInSet === candidateChecked,
    `${candidateChecked - candidateInSet}/${candidateChecked} rows missing recorded bid`);

check('candidates: JS legal set equals recorded ev',
    evExact === evChecked,
    `${evChecked - evExact}/${evChecked} rows differ from recorded ev`);

// ---- 4. contract extraction sanity ---------------------------------------

const over = ['PASS', '1NT', 'PASS', 'PASS', 'PASS'].map(s => BidWeb.Call.parse(s));
const contract = BidWeb.Auction.getContract(over, 0);
check('contract: extracts 1NT by East', contract &&
    contract.level === 1 && contract.strain === BidWeb.Strain.NT &&
    contract.declarer === 1, JSON.stringify(contract));

const passedOut = ['PASS', 'PASS', 'PASS', 'PASS'].map(s => BidWeb.Call.parse(s));
check('contract: passed out is null', BidWeb.Auction.getContract(passedOut, 0) === null);

// ---- hand parsing: dotted PBN style + duplicate detection ------------------

const dotted = BidWeb.Hand.parse('AKQJ.T98.765.432');
check('hand: dotted S.H.D.C parse', [4, 3, 3, 3].join(',') ===
    BidWeb.SUIT_KEYS.map(k => dotted.suits[k].length).join(','),
    JSON.stringify(BidWeb.SUIT_KEYS.map(k => dotted.suits[k].length)));
check('hand: dotted ace of spades', dotted.hasRank('spades', 14));

const compact = BidWeb.Hand.parse('SAK2 HKQ DQJ9 C5432');
check('hand: compact parse', compact.hcp() === 15,
    String(compact.hcp()));
const counts = BidWeb.Hand.cardCounts([dotted, compact]);
const dupes = Object.entries(counts).filter(([, c]) => c > 1);
check('hand: duplicate detection', dupes.length > 0 &&
    dupes.every(([card]) => /^(S|H|D|C)\d+$/.test(card)),
    JSON.stringify(dupes));

// ---- 5. embedded native DD tables are well-formed --------------------------

const boardEntries = Object.entries(DATA.boards || {});
check('dds: snapshot carries solved boards', boardEntries.length > 0,
    `got ${boardEntries.length}`);
for (const [key, sol] of boardEntries.slice(0, 10)) {
    const t = sol.dd_table;
    check('dds: table is 5x4 and in range',
        Array.isArray(t) && t.length === 5 && t[0].length === 4 &&
        t.every(row => row.every(n => n >= 0 && n <= 13)),
        `${key}: ${JSON.stringify(t).slice(0, 80)}`);
}

// ---- 6. WASM DDS solves a full deal quickly (node) -------------------------

try {
    const {createRequire} = await import('node:module');
    const require = createRequire(import.meta.url);
    globalThis.createDdsApiModule = require(join(root, 'web', 'vendor', 'dds_wasm_api.js'));
    const DDS = require(join(root, 'web', 'vendor', 'dds_api.js'));
    const mod = await Promise.race([
        DDS.init({locateFile: (p, dir) => p.endsWith('.wasm')
            ? join(root, 'web', 'vendor', 'dds_wasm_api.wasm') : p}),
        new Promise((_, rej) => setTimeout(() => rej(new Error('WASM init timeout')), 20000)),
    ]);
    const deal = BidWeb.Deal.random(0, 0, 77);
    const t0 = Date.now();
    const table = mod.calcDDTablePBN(deal.toPBN());
    const ms = Date.now() - t0;
    check('dds: WASM solves full deal', table.resTable?.length === 5 &&
        table.resTable[0].length === 4, JSON.stringify(table).slice(0, 90));
    console.log(`  (WASM calcDDTablePBN: ${ms} ms on a random full deal)`);
} catch (e) {
    check('dds: WASM solves full deal', false, String(e));
}

// ---- 7. reviewable systems: parse parity + legacy behaviour ----------------

const systems = DATA.systems || {};
check('systems: snapshot carries reviewable systems',
    Object.keys(systems).length >= 4, `got ${Object.keys(systems).length}`);
for (const [key, spec] of Object.entries(systems)) {
    const parsed = spec.format === 'legacy'
        ? BidWeb.Legacy.parse(spec.text, key)
        : BidWeb.DSL.parse(spec.text, key);
    check(`systems: ${key} rule count matches Python`,
        parsed.rules.length === spec.python_rule_count,
        `js ${parsed.rules.length} vs py ${spec.python_rule_count}`);
}

// Precision strong-club opening, verified against the Python engine:
//   SAK2 HAK2 DAK3 C5432 (21 HCP) -> 1C; weak hands -> no OPEN rule fires.
{
    const prec = BidWeb.Legacy.parse(systems.precision.text, 'precision');
    const strong = BidWeb.Hand.parse('SAK2 HKQ2 DAK3 C5432');
    const r = BidWeb.Legacy.appliedRules(prec, [], strong)[0];
    check('systems: precision opens 1C on 21 HCP',
        r && r.call.toString() === '1C', r && r.call.toString());
    const weak = BidWeb.Hand.parse('S5432 H872 D962 CJ42');
    check('systems: precision passes on 1 HCP opening set',
        !BidWeb.Legacy.appliedRules(prec, [], weak).length);
}

// mixed-partnership auction must run end-to-end (improved N/S vs precision E/W)
{
    const deal = BidWeb.Deal.random(0, 0, 7);
    const runner = new BidWeb.Auction.AuctionRunner(deal, {
        ns: {kind: 'net', net},
        ew: {kind: 'legacy', system: BidWeb.Legacy.parse(systems.precision.text, 'precision')},
    }, 'manual');
    runner.runOut();
    check('systems: mixed-partnership auction completes',
        runner.history.length >= 4 && BidWeb.Auction.getContract(runner.history, 0) !== null,
        `calls ${runner.history.length}`);
}

// ---- 8. student lab: seeded corpus -> train -> serialize/load --------------

{
    const SL = BidWeb.StudentLab;
    const engine = {kind: 'net', net};
    const rows = SL.buildCorpus(engine, 12, 3);
    check('student: corpus generated', rows.length >= 40, `rows ${rows.length}`);
    const {X, y, vocab} = SL.encodeDataset(rows);
    check('student: feature dim consistent', X[0].length === SL.FEATURE_DIM,
        `${X[0].length} vs ${SL.FEATURE_DIM}`);
    const {model, log} = SL.train(X, y, vocab, {epochs: 10, seed: 1});
    check('student: training reduces loss',
        log[log.length - 1].loss < log[0].loss,
        `${log[0].loss.toFixed(3)} -> ${log[log.length - 1].loss.toFixed(3)}`);
    const last = log[log.length - 1];
    check('student: val accuracy sane', last.valAcc >= 0 && last.valAcc <= 1,
        String(last.valAcc));

    // determinism: same seed -> identical round-tripped model behaviour
    const json = SL.serialize({model, meta: {teacher: 'test'}});
    const reloaded = SL.load(JSON.parse(JSON.stringify(json)));
    const evOrig = SL.evaluate({model}, X, y, vocab);
    const evLoad = SL.evaluate(reloaded.model, X, y, vocab);
    check('student: serialize/load round-trips exactly',
        evOrig.acc === evLoad.acc, `${evOrig.acc} vs ${evLoad.acc}`);

    // determinism of the whole pipeline
    const rows2 = SL.buildCorpus(engine, 12, 3);
    check('student: corpus generation is seeded/deterministic',
        JSON.stringify(rows2) === JSON.stringify(rows));
}

// ---- 9. shipped default student ---------------------------------------------

{
    const SL = BidWeb.StudentLab;
    const engine = {kind: 'net', net};
    check('student: default student ships with the UI', !!DEFAULT_STUDENT);
    if (DEFAULT_STUDENT) {
        const reloaded = SL.load(DEFAULT_STUDENT);
        check('student: default metadata present',
            reloaded.meta.teacher === 'improved' && reloaded.meta.val_acc !== undefined,
            JSON.stringify(reloaded.meta).slice(0, 90));
        // beats the majority baseline on a fresh deterministic corpus
        const rows = SL.buildCorpus(engine, 30, 11);
        const fresh = SL.encodeDataset(rows);
        const ev = SL.evaluate(reloaded.model, fresh.X, fresh.y, fresh.vocab);
        const counts = new Map();
        for (const c of fresh.y) counts.set(c, (counts.get(c) || 0) + 1);
        let maj = 0;
        for (const n of counts.values()) if (n > maj) maj = n;
        const baseline = maj / fresh.y.length;
        check('student: default beats majority baseline on fresh corpus',
            ev.acc > baseline,
            `acc ${(ev.acc * 100).toFixed(1)}% vs baseline ${(baseline * 100).toFixed(1)}%`);
    }
}

// ---- 10. student engine: reviewable system with explained decisions --------

{
    check('student engine: default student present for seating', !!DEFAULT_STUDENT);
    if (DEFAULT_STUDENT) {
        const eng = BidWeb.StudentEngine.make(
            BidWeb.StudentLab.load(DEFAULT_STUDENT), 'Student (test)');
        const hand = BidWeb.Hand.parse('SAK2 HKQ2 DQ95 C542');   // 16 HCP balanced
        const exp = eng.explain(hand, [], 0, 0, 0);
        check('student: explain returns ranking', exp.kind === 'student' &&
            exp.ranking.length > 0, `ranking ${exp.ranking.length}`);
        check('student: ranking is probability-sorted',
            exp.ranking.every((r, i) => i === 0 || exp.ranking[i - 1].prob >= r.prob));
        check('student: chosen is bridge-legal', exp.chosen && exp.chosen.legal,
            JSON.stringify(exp.chosen));
        check('student: legal+illegal marks coherent',
            exp.ranking.every(r => typeof r.legal === 'boolean'));

        // student seated N/S against rule-based East/West completes an auction
        const deal = BidWeb.Deal.random(0, 0, 5);
        const runner = new BidWeb.Auction.AuctionRunner(deal, {
            ns: eng,
            ew: {kind: 'net', net},
        }, 'manual');
        runner.runOut();
        check('student: mixed student-vs-rules auction completes',
            runner.history.length >= 4 &&
            BidWeb.Auction.getContract(runner.history, 0) !== null,
            `calls ${runner.history.length}`);
        // every student call was legality-checked at apply time by design;
        // spot-check the runner's history is a legal sequence via replay:
        let legal = true;
        for (let t = 0; t < runner.history.length && legal; t++) {
            const ctx = BidWeb.Net.legalityContext(runner.history.slice(0, t),
                (deal.dealer + t) % 4, deal.dealer);
            legal = ctx.isLegal(runner.history[t]);
        }
        check('student: produced auction is bridge-legal', legal);
    }
}

// ---- summary ---------------------------------------------------------------

console.log(`engine_test: ${passed} checks passed, ${failed} failed ` +
    `(${net.rules.length} rules, ${featureCheckedRows} trace rows replayed)`);
process.exit(failed ? 1 : 0);
