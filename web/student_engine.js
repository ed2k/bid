/**
 * student_engine.js — seats a trained in-browser student at the table.
 *
 * Wraps a StudentLab-serialized model as a reviewable bidding engine
 * ({kind:'student'}) alongside the rule-based systems.  Decisions are
 * explained, not just made: the full bid-probability ranking is exposed
 * with bridge-legality marks, and the choice is legality-constrained
 * (highest-probability legal call; PASS fallback) like the Python side's
 * constrained decoding.
 */
(function (api) {
    'use strict';

    const Call = api.Call;
    const C = api.CallType;

    function make(loadedStudent, label) {
        const model = loadedStudent.model || loadedStudent;
        const engine = {
            kind: 'student',
            model,
            meta: loadedStudent.meta || {},
            label: label || 'Student (MLP)',
            key: null,
        };

        function ranking(features) {
            const x = new Float32Array(api.StudentLab.featurize(features));
            // forward pass (same shapes as StudentLab.train)
            const [din, h1, h2, K] = model.dims;
            const a1 = new Float32Array(h1), a2 = new Float32Array(h2),
                out = new Float32Array(K);
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
            const ranked = [];
            for (let j = 0; j < K; j++) {
                ranked.push({bid: model.vocab[j], prob: out[j] / sum});
            }
            ranked.sort((a, b) => b.prob - a.prob);
            return ranked;
        }

        /** DecisionInspector-shaped explanation for one seat's turn. */
        function explain(hand, history, mySeat, dealer, vuln) {
            const features = api.Features.extractAll(hand, history, mySeat, dealer, vuln);
            const ranked = ranking(features);
            const legality = api.Net.legalityContext(history, mySeat, dealer);

            let chosen = null, fallback = false, suppressed = null;
            const withLegality = ranked.map(r => {
                let call;
                try {
                    call = r.bid === 'PASS' ? new Call(C.PASS) : Call.parse(r.bid);
                } catch (e) {
                    call = null;
                }
                const legal = !call ? false : legality.isLegal(call);
                return Object.assign({}, r, {call, legal});
            });
            for (const r of withLegality) {
                if (!r.legal && !suppressed && r.call) suppressed = r.bid;
                if (r.legal && !chosen) chosen = r;
            }
            if (!chosen) {
                chosen = {bid: 'PASS', prob: null, call: new Call(C.PASS), legal: true};
                fallback = true;
            }

            return {
                kind: 'student',
                features,
                ranking: withLegality,
                chosen,
                suppressed,          // highest-probability call legality vetoed
                candidates: [chosen.call],
                legal: [chosen.call],
                illegal: [],
                fallbackPass: fallback,
                intersectionApplied: null,
                matchedIds: [],
                label: engine.label,
            };
        }

        engine.explain = explain;
        engine.ranking = ranking;
        return engine;
    }

    api.StudentEngine = {make};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
