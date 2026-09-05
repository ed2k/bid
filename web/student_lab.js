/**
 * student_lab.js — in-browser student training for the Bid review UI.
 *
 * A compact, dependency-free "student": a small MLP that imitates a loaded
 * bidding system (the teacher) from a corpus generated in the browser with
 * the same JS engine the review UI uses.  This mirrors the shape of Loop B
 * (trace generation -> train -> gate -> save) at demo scale; the production
 * 5.5M-param CoT student still trains in Python via refresh_student.py.
 *
 * Everything is seeded — same inputs produce byte-identical models.
 */
(function (api) {
    'use strict';

    // ---- feature encoding ---------------------------------------------------

    const STRAIN_SLOTS = ['C', 'D', 'H', 'S', 'NT', 'NONE'];
    api.StudentLab = {};

    api.StudentLab.FEATURE_DIM = featurize({
        hcp: 0, controls: 0, major_hcp: 0, spade_len: 0, heart_len: 0,
        diamond_len: 0, club_len: 0, is_balanced: false, is_opening: false,
        passes_since_last_bid: 0, last_bid_level: 0, last_bid_strain: 'NONE',
        opp_bid_count: 0, my_side_bid_count: 0, auction_altitude: 0,
        is_competitive: false, partner_last_bid_strain: 'NONE',
        support_in_partner_suit: 0, is_vulnerable: false,
    }).length;

    function oneHot(slot, value) {
        const v = STRAIN_SLOTS.indexOf(value);
        return slot === v ? 1 : 0;
    }

    /** Fixed normalized feature vector from an explain() features dict. */
    function featurize(f) {
        const num = (v, dflt) => (typeof v === 'number' && isFinite(v)) ? v : dflt;
        const vec = [
            num(f['hcp'], 0) / 20,
            num(f['controls'], 0) / 12,
            num(f['major_hcp'], 0) / 20,
            num(f['spade_len'], 0) / 13,
            num(f['heart_len'], 0) / 13,
            num(f['diamond_len'], 0) / 13,
            num(f['club_len'], 0) / 13,
            f['is_balanced'] ? 1 : 0,
            f['is_opening'] ? 1 : 0,
            Math.min(num(f['passes_since_last_bid'], 0), 3) / 3,
            num(f['last_bid_level'], 0) / 7,
        ];
        const ls = String(f['last_bid_strain'] || 'NONE');
        const ps = String(f['partner_last_bid_strain'] || 'NONE');
        for (const s of STRAIN_SLOTS) vec.push(oneHot(s, ls));
        vec.push(
            Math.min(num(f['opp_bid_count'], 0), 4) / 4,
            Math.min(num(f['my_side_bid_count'], 0), 4) / 4,
            num(f['auction_altitude'], 0) / 7,
            f['is_competitive'] ? 1 : 0,
        );
        for (const s of STRAIN_SLOTS) vec.push(oneHot(s, ps));
        vec.push(
            Math.max(0, Math.min(num(f['support_in_partner_suit'], 0), 6)) / 6,
            f['is_vulnerable'] ? 1 : 0,
        );
        return vec;
    }

    // ---- corpus generation ---------------------------------------------------

    /** Play nDeals with the given engine (all four seats) and record every
     *  decision as a trace row, mirroring the Python corpus schema. */
    function buildCorpus(engine, nDeals, seed, onProgress) {
        const rows = [];
        const rng = api.mulberry32(seed === undefined ? 7 : seed);
        for (let i = 0; i < nDeals; i++) {
            const dealer = Math.floor(rng() * 4);
            const vuln = Math.floor(rng() * 4);
            const deal = api.Deal.random(dealer, vuln, Math.floor(rng() * 0xffffffff));
            const runner = new api.Auction.AuctionRunner(deal, engine, 'manual');
            while (!runner.isOver()) {
                const seat = runner.currentSeat();
                const exp = runner.explain();
                const bid = engine.kind === 'legacy'
                    ? (exp.chosen ? exp.chosen.call : new api.Call(api.CallType.PASS))
                    : engine.kind === 'student'
                        ? exp.chosen.call
                        : api.Net.autoSelect(engine.net, exp);
                rows.push({
                    seat,
                    auction: runner.history.map(c => c.toString()),
                    features: exp.features,
                    bid: bid.toString(),
                    // 'forced' means the engine had exactly one legal call;
                    // legacy engines are always single-answer by design
                    forced: engine.kind === 'legacy' ? false : exp.legal.length === 1,
                });
                runner.applyCall(bid, exp, true);
            }
            if (onProgress && i % 25 === 24) onProgress(i + 1, nDeals);
        }
        return rows;
    }

    // ---- tiny MLP (pure JS, seeded) -------------------------------------------

    function seededWeights(shape, seed) {
        const rng = api.mulberry32(seed);
        const scale = Math.sqrt(2 / shape[0]);
        const w = new Float32Array(shape[0] * shape[1]);
        for (let i = 0; i < w.length; i++) w[i] = (rng() * 2 - 1) * scale;
        return w;
    }

    /** model: {dims:[in,h1,h2,K], W1,b1,W2,b2,W3,b3, vocab} */
    function makeModel(dimIn, hidden1, hidden2, vocab, seed) {
        const K = vocab.length;
        return {
            dims: [dimIn, hidden1, hidden2, K],
            W1: seededWeights([dimIn, hidden1], seed),
            b1: new Float32Array(hidden1),
            W2: seededWeights([hidden1, hidden2], seed + 1),
            b2: new Float32Array(hidden2),
            W3: seededWeights([hidden2, K], seed + 2),
            b3: new Float32Array(K),
            vocab: vocab.slice(),
        };
    }

    function forward(model, x) {
        const [din, h1, h2, K] = model.dims;
        const a1 = new Float32Array(h1), a2 = new Float32Array(h2), out = new Float32Array(K);
        for (let j = 0; j < h1; j++) {
            let s = model.b1[j];
            for (let i = 0; i < din; i++) s += x[i] * model.W1[i * h1 + j];
            a1[j] = s > 0 ? s : 0;
        }
        for (let j = 0; j < h2; j++) {
            let s = model.b2[j];
            for (let i = 0; i < h1; i++) s += a1[i] * model.W2[i * h2 + j];
            a2[j] = s > 0 ? s : 0;
        }
        let max = -Infinity;
        for (let j = 0; j < K; j++) {
            let s = model.b3[j];
            for (let i = 0; i < h2; i++) s += a2[i] * model.W3[i * K + j];
            out[j] = s;
            if (s > max) max = s;
        }
        let sum = 0;
        for (let j = 0; j < K; j++) { out[j] = Math.exp(out[j] - max); sum += out[j]; }
        for (let j = 0; j < K; j++) out[j] /= sum;
        return {a1, a2, out};
    }

    function argmax(arr) {
        let best = 0;
        for (let i = 1; i < arr.length; i++) if (arr[i] > arr[best]) best = i;
        return best;
    }

    /** Encode corpus rows -> {X: Float32Array[], y: int[], vocab, counts}. */
    function encodeDataset(rows) {
        const vocabSet = new Set();
        for (const r of rows) vocabSet.add(r.bid);
        const vocab = [...vocabSet].sort();
        const vidx = new Map(vocab.map((b, i) => [b, i]));
        const X = rows.map(r => new Float32Array(featurize(r.features)));
        const y = rows.map(r => vidx.get(r.bid));
        const counts = vocab.map(b => rows.filter(r => r.bid === b).length);
        return {X, y, vocab, counts};
    }

    /** Train with mini-batch SGD + momentum. Deterministic under seed.
     *  Returns {model, log:[{epoch, loss, valAcc, baselineAcc}]}. */
    function train(X, y, vocab, opts) {
        const o = Object.assign({epochs: 12, batchSize: 32, lr: 0.08,
            momentum: 0.9, hidden1: 64, hidden2: 32, seed: 1,
            valFrac: 0.15, onEpoch: null}, opts || {});
        const rng = api.mulberry32(o.seed);

        // seeded shuffle + split
        const idx = X.map((_, i) => i);
        for (let i = idx.length - 1; i > 0; i--) {
            const j = Math.floor(rng() * (i + 1));
            [idx[i], idx[j]] = [idx[j], idx[i]];
        }
        const nVal = Math.max(1, Math.floor(idx.length * o.valFrac));
        const valIdx = idx.slice(0, nVal), trainIdx = idx.slice(nVal);

        const model = makeModel(X[0].length, o.hidden1, o.hidden2, vocab, o.seed);
        const [din, h1, h2, K] = model.dims;

        // velocity buffers
        const vW1 = new Float32Array(model.W1.length), vb1 = new Float32Array(h1);
        const vW2 = new Float32Array(model.W2.length), vb2 = new Float32Array(h2);
        const vW3 = new Float32Array(model.W3.length), vb3 = new Float32Array(K);

        // majority baseline on train split
        const majorityCount = new Map();
        for (const i of trainIdx) majorityCount.set(y[i], (majorityCount.get(y[i]) || 0) + 1);
        let majorityY = 0, majorityN = 0;
        for (const [cls, n] of majorityCount) if (n > majorityN) { majorityN = n; majorityY = cls; }
        const baselineAcc = valIdx.filter(i => y[i] === majorityY).length / valIdx.length;

        const log = [];
        const gW1 = new Float32Array(model.W1.length), gb1 = new Float32Array(h1);
        const gW2 = new Float32Array(model.W2.length), gb2 = new Float32Array(h2);
        const gW3 = new Float32Array(model.W3.length), gb3 = new Float32Array(K);

        const evalVal = () => {
            let hit = 0;
            for (const i of valIdx) {
                const {out} = forward(model, X[i]);
                if (argmax(out) === y[i]) hit++;
            }
            return hit / valIdx.length;
        };

        for (let epoch = 0; epoch < o.epochs; epoch++) {
            // re-shuffle train order each epoch (seeded continuation)
            for (let i = trainIdx.length - 1; i > 0; i--) {
                const j = Math.floor(rng() * (i + 1));
                const t = trainIdx[i]; trainIdx[i] = trainIdx[j]; trainIdx[j] = t;
            }
            let epochLoss = 0, seen = 0;
            for (let start = 0; start < trainIdx.length; start += o.batchSize) {
                const batch = trainIdx.slice(start, start + o.batchSize);
                gW1.fill(0); gb1.fill(0); gW2.fill(0); gb2.fill(0); gW3.fill(0); gb3.fill(0);
                for (const i of batch) {
                    const x = X[i], label = y[i];
                    const {a1, a2, out} = forward(model, x);
                    epochLoss += -Math.log(Math.max(out[label], 1e-9));
                    seen++;
                    // softmax gradient
                    const d3 = new Float32Array(K);
                    for (let j = 0; j < K; j++) d3[j] = out[j] - (j === label ? 1 : 0);
                    const d2 = new Float32Array(h2), d1 = new Float32Array(h1);
                    for (let j = 0; j < K; j++) {
                        gb3[j] += d3[j];
                        for (let i2 = 0; i2 < h2; i2++) {
                            gW3[i2 * K + j] += a2[i2] * d3[j];
                            d2[i2] += model.W3[i2 * K + j] * d3[j];
                        }
                    }
                    for (let i2 = 0; i2 < h2; i2++) {
                        if (a2[i2] <= 0) d2[i2] = 0;
                        gb2[i2] += d2[i2];
                        for (let i1 = 0; i1 < h1; i1++) {
                            gW2[i1 * h2 + i2] += a1[i1] * d2[i2];
                            d1[i1] += model.W2[i1 * h2 + i2] * d2[i2];
                        }
                    }
                    for (let i1 = 0; i1 < h1; i1++) {
                        if (a1[i1] <= 0) d1[i1] = 0;
                        gb1[i1] += d1[i1];
                        for (let i0 = 0; i0 < din; i0++) gW1[i0 * h1 + i1] += x[i0] * d1[i1];
                    }
                }
                const scale = o.lr / batch.length;
                const apply = (W, G, V) => {
                    for (let k = 0; k < W.length; k++) {
                        V[k] = o.momentum * V[k] - scale * G[k];
                        W[k] += V[k];
                    }
                };
                apply(model.W1, gW1, vW1); apply(model.b1, gb1, vb1);
                apply(model.W2, gW2, vW2); apply(model.b2, gb2, vb2);
                apply(model.W3, gW3, vW3); apply(model.b3, gb3, vb3);
            }
            const entry = {epoch: epoch + 1,
                loss: epochLoss / Math.max(1, seen),
                valAcc: evalVal(), baselineAcc};
            log.push(entry);
            if (o.onEpoch) o.onEpoch(entry);
        }
        return {model, log, baselineAcc};
    }

    // ---- serialize / load ------------------------------------------------------

    function serialize(trained, meta) {
        const m = trained.model || trained;
        return {
            format: 'bid-web-student',
            version: 1,
            meta: meta || {},
            dims: Array.from(m.dims),
            vocab: m.vocab,
            weights: {
                W1: Array.from(m.W1), b1: Array.from(m.b1),
                W2: Array.from(m.W2), b2: Array.from(m.b2),
                W3: Array.from(m.W3), b3: Array.from(m.b3),
            },
        };
    }

    function load(json) {
        if (!json || json.format !== 'bid-web-student') {
            throw new Error('not a bid-web-student file');
        }
        const m = {
            dims: json.dims,
            vocab: json.vocab,
            W1: Float32Array.from(json.weights.W1), b1: Float32Array.from(json.weights.b1),
            W2: Float32Array.from(json.weights.W2), b2: Float32Array.from(json.weights.b2),
            W3: Float32Array.from(json.weights.W3), b3: Float32Array.from(json.weights.b3),
        };
        return {model: m, meta: json.meta || {}};
    }

    /** Top-1 accuracy of a model over encoded rows.  `y` is indexed by
     *  `vocab` (the corpus encoding); model predictions are mapped through
     *  model.vocab so students evaluated on a different corpus than they
     *  were trained on compare bid STRINGS, not class indices. */
    function evaluate(modelObj, X, y, vocab) {
        const m = modelObj.model || modelObj;
        let hit = 0;
        for (let i = 0; i < X.length; i++) {
            const {out} = forward(m, X[i]);
            const predBid = m.vocab[argmax(out)];
            const trueBid = vocab ? vocab[y[i]] : m.vocab[y[i]];
            if (predBid === trueBid) hit++;
        }
        return {acc: X.length ? hit / X.length : 0, n: X.length};
    }

    api.StudentLab.buildCorpus = buildCorpus;
    api.StudentLab.encodeDataset = encodeDataset;
    api.StudentLab.train = train;
    api.StudentLab.serialize = serialize;
    api.StudentLab.load = load;
    api.StudentLab.evaluate = evaluate;
    api.StudentLab.featurize = featurize;
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
