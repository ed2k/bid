/**
 * id3.js — speedup learning (compact port of src/bid/learner.py
 * ID3DecisionTree): fits threshold-split decision trees on numeric features
 * by Shannon information gain, and resolves ambiguous DecisionNet states
 * (|φ(s)| > 1) into a deterministic call, attached as a refinement the
 * rule engine applies before falling back to the full candidate set.
 */
(function (api) {
    'use strict';

    function entropy(rows) {
        if (!rows.length) return 0;
        const counts = new Map();
        for (const r of rows) counts.set(r.bid, (counts.get(r.bid) || 0) + 1);
        let e = 0;
        for (const n of counts.values()) {
            const p = n / rows.length;
            e -= p * Math.log2(p);
        }
        return e;
    }

    function majority(rows) {
        const counts = new Map();
        for (const r of rows) counts.set(r.bid, (counts.get(r.bid) || 0) + 1);
        let best = null, bestN = -1;
        for (const [bid, n] of counts) if (n > bestN) { best = bid; bestN = n; }
        return best;
    }

    /**
     * Fit a tree.  rows: [{features: {key: number|string}, bid: string}].
     * Numeric features split at midpoints of sorted unique values; string
     * features split by equality against each value (capped at 6 branches).
     */
    function fit(rows, maxDepth, minSplit) {
        maxDepth = maxDepth || 3;
        minSplit = minSplit || 4;

        function build(rows, depth, used) {
            const node = {leaf: true, prediction: majority(rows), n: rows.length};
            if (depth >= maxDepth || rows.length < minSplit * 2) return node;
            if (entropy(rows) === 0) return node;

            const keys = Object.keys(rows[0].features).filter(k => !used.has(k));
            let best = null;   // {key, kind, threshold, value, gain, groups}
            const base = entropy(rows);
            for (const key of keys) {
                const vals = rows.map(r => r.features[key]);
                const isNum = vals.every(v => typeof v === 'number');
                if (isNum) {
                    const uniq = [...new Set(vals)].sort((a, b) => a - b);
                    for (let i = 0; i + 1 < uniq.length; i++) {
                        const thr = (uniq[i] + uniq[i + 1]) / 2;
                        const left = rows.filter(r => r.features[key] <= thr);
                        const right = rows.filter(r => r.features[key] > thr);
                        if (left.length < minSplit || right.length < minSplit) continue;
                        const gain = base - (left.length * entropy(left) +
                            right.length * entropy(right)) / rows.length;
                        if (!best || gain > best.gain) {
                            best = {key, kind: 'num', threshold: thr, gain,
                                groups: [left, right], labels: ['<= ' + thr, '> ' + thr]};
                        }
                    }
                } else {
                    const uniq = [...new Set(vals)].slice(0, 6);
                    if (uniq.length < 2) continue;
                    const groups = uniq.map(v => rows.filter(r => r.features[key] === v));
                    const rest = rows.filter(r => !uniq.includes(r.features[key]));
                    if (rest.length) { groups.push(rest); uniq.push('*'); }
                    if (groups.some(g => g.length < minSplit)) continue;
                    const weighted = groups.reduce((a, g) => a + g.length * entropy(g), 0);
                    const gain = base - weighted / rows.length;
                    if (!best || gain > best.gain) {
                        best = {key, kind: 'str', values: uniq, gain,
                            groups, labels: uniq.map(v => `${key}==${v}`)};
                    }
                }
            }
            if (!best || best.gain <= 1e-9) return node;
            node.leaf = false;
            node.split = best.key;
            node.gain = best.gain;
            node.children = best.groups.map((g, i) => {
                const child = build(g, depth + 1, new Set([...used, best.key]));
                child.label = best.labels[i];
                return child;
            });
            return node;
        }

        const featureKeys = new Set(Object.keys(rows[0].features));
        return build(rows, 0, featureKeys);   // root may use any feature once per path
    }

    function predict(node, features) {
        while (!node.leaf) {
            const v = features[node.split];
            let next = null;
            for (const child of node.children) {
                if (child.label.endsWith('*')) { next = child; continue; }
                if (typeof v === 'number' && node.children[0].label.startsWith('<=')) {
                    const thr = parseFloat(child.label.slice(3));
                    if ((child.label.startsWith('<= ') && v <= thr) ||
                        (child.label.startsWith('> ') && v > thr)) { next = child; break; }
                } else if (child.label === `${node.split}==${v}`) { next = child; break; }
            }
            if (!next) return node.prediction;
            node = next;
        }
        return node.prediction;
    }

    function render(node, indent) {
        indent = indent || '';
        if (node.leaf) return `${indent}→ ${node.prediction} (n=${node.n})\n`;
        let s = `${indent}[${node.split}? gain ${node.gain.toFixed(3)}]\n`;
        for (const child of node.children) {
            s += `${indent}  ${child.label}:\n` + render(child, indent + '    ');
        }
        return s;
    }

    /**
     * Speedup learning over a generated corpus: group rows whose decision had
     * multiple legal candidates by their matched-rule set, fit an ID3 tree
     * per sufficiently-populated ambiguous group, and attach its per-feature
     * prediction as a refinement.  Returns the list of attached groups.
     */
    function resolveAmbiguities(net, rows, opts) {
        opts = Object.assign({minRows: 6, maxDepth: 3}, opts || {});
        const groups = new Map();
        for (const r of rows) {
            if (!r.multiCandidate || !r.matchedIds || r.matchedIds.length < 2) continue;
            const key = r.matchedIds.slice().sort().join('^');
            if (!groups.has(key)) groups.set(key, []);
            groups.get(key).push(r);
        }
        const attached = [];
        for (const [key, grp] of groups) {
            if (grp.length < opts.minRows) continue;
            const fitRows = grp.map(r => ({features: r.features, bid: r.bid}));
            const tree = fit(fitRows, opts.maxDepth, opts.minSplit);
            let correct = 0;
            for (const r of fitRows) if (predict(tree, r.features) === r.bid) correct++;
            net.refinements = net.refinements || {};
            net.refinements[key] = features => predict(tree, features);
            attached.push({key, rows: grp.length, acc: correct / grp.length,
                text: render(tree).trim()});
        }
        attached.sort((a, b) => b.rows - a.rows);
        return attached;
    }

    api.ID3 = {fit, predict, render, resolveAmbiguities};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
