/**
 * build_default_student.mjs — regenerate the default in-browser student that
 * ships with the review UI (web/student_default.js).
 *
 * Deterministic: seeded corpus + seeded training on the CURRENT snapshot's
 * improved_system.dsl, so re-running after `bid.web_export` refreshes the
 * student in lockstep with the teacher snapshot.
 *
 * Run: node web/build_default_student.mjs
 */
import {readFileSync, writeFileSync} from 'node:fs';
import {fileURLToPath} from 'node:url';
import {dirname, join} from 'node:path';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');

for (const f of ['objects.js', 'features.js', 'bid_dsl.js', 'system_dsl.js',
                 'bid_net.js', 'auction.js', 'student_lab.js']) {
    (0, eval)(readFileSync(join(root, 'web', f), 'utf8'));
}
(0, eval)(readFileSync(join(root, 'web', 'review_data.js'), 'utf8'));

const BidWeb = globalThis.BidWeb;
const DATA = globalThis.BID_REVIEW_DATA;

const DEALS = parseInt(process.env.STUDENT_DEALS || '150', 10);
const EPOCHS = parseInt(process.env.STUDENT_EPOCHS || '15', 10);
const SEED = 7;

console.log(`building default student: teacher=improved (${DATA.dsl_sha256}), ` +
    `${DEALS} deals, ${EPOCHS} epochs, seed ${SEED}`);

const net = BidWeb.DSL.parse(DATA.dsl, 'improved');
const engine = {kind: 'net', net};

const t0 = Date.now();
const rows = BidWeb.StudentLab.buildCorpus(engine, DEALS, SEED);
const ds = BidWeb.StudentLab.encodeDataset(rows);
const {model, log} = BidWeb.StudentLab.train(ds.X, ds.y, ds.vocab,
    {epochs: EPOCHS, seed: 1});
const last = log[log.length - 1];

const payload = BidWeb.StudentLab.serialize(model, {
    teacher: 'improved',
    teacher_label: 'Improved (current teacher)',
    teacher_dsl_sha256: DATA.dsl_sha256,
    created: new Date().toISOString(),
    corpus_rows: rows.length,
    deals: DEALS,
    epochs: EPOCHS,
    seed_corpus: SEED,
    seed_train: 1,
    val_acc: last.valAcc,
    baseline_acc: last.baselineAcc,
    note: 'default in-browser student; regenerate with `node web/build_default_student.mjs`',
});

const out = '/* Generated default student — run `node web/build_default_student.mjs` ' +
    `to refresh. Teacher dsl ${DATA.dsl_sha256}. */\n` +
    'globalThis.BID_DEFAULT_STUDENT = ' + JSON.stringify(payload) + ';\n';
writeFileSync(join(root, 'web', 'student_default.js'), out);

console.log(`done in ${((Date.now() - t0) / 1000).toFixed(1)}s: ` +
    `${rows.length} rows, ${ds.vocab.length} bids, ` +
    `val ${(last.valAcc * 100).toFixed(1)}% vs baseline ${(last.baselineAcc * 100).toFixed(1)}% ` +
    `-> web/student_default.js (${Math.round(out.length / 1024)} KB)`);
