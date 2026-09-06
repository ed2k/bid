/**
 * cot_model.js — runs the SAME CoT transformer student the Python loops
 * trained (data/cot_model/ckpt.pt) inside the browser.
 *
 * Weights come from web/models/cot/ (produced by
 * `python3 -m bid.cot_export_web`): FP16 tensors + manifest + vocabulary.
 * The architecture is a faithful port of cot_model.py (nanoGPT-lite:
 * tok/pos embeddings, 6 pre-LN blocks with fused-qkv causal attention and
 * GELU MLPs, final LN, untied LM head), with a KV cache for generation.
 *
 * The prompt/dataset conventions are ported from cot_tokenizer.py and
 * cot_bidder.py: canonical state prefix, <sep>-separated reasoning, greedy
 * generation of <=48 tokens, bid extracted after the last BID atom and
 * legality-checked (PASS fallback mirrors Python's symbolic fallback).
 */
(function (api) {
    'use strict';

    const SPECIALS = {PAD: '<pad>', BOS: '<bos>', SEP: '<sep>', EOT: '<eot>'};
    const Call = api.Call;
    const C = api.CallType;

    // ---- fp16 decode ---------------------------------------------------------

    function f16ToFloat32(uint16) {
        const out = new Float32Array(uint16.length);
        const i32 = new Int32Array(out.buffer);   // shares the buffer!
        for (let i = 0; i < uint16.length; i++) {
            const h = uint16[i];
            const sign = (h & 0x8000) << 16;
            let exp = (h & 0x7c00) >> 10;
            let man = h & 0x03ff;
            let bits;
            if (exp === 0) {
                if (man === 0) { bits = sign; }
                else {           // subnormal — normalize
                    let e = -1;
                    man <<= 1;
                    while ((man & 0x0400) === 0) { man <<= 1; e--; }
                    exp = 127 + e - 15 + 1;
                    man &= 0x03ff;
                    bits = sign | (exp << 23) | (man << 13);
                }
            } else if (exp === 0x1f) {
                bits = sign | 0x7f800000 | (man << 13);
            } else {
                bits = sign | ((exp - 15 + 127) << 23) | (man << 13);
            }
            i32[i] = bits;
        }
        return out;
    }

    // ---- tokenizer (port of cot_tokenizer.py) ---------------------------------

    const CALL_PAT = "(?<!\\w)(?:[1-7](?:NT|[CDHS])|PASS|XX?)(?!\\w)";
    const TOKEN_RE = new RegExp(
        CALL_PAT + "|>=|<=|==|!=|<[^>]+>|[A-Za-z_][A-Za-z0-9_]*|\\d|[^\\w\\s]", "g");

    function tokenizeLine(line) {
        return String(line).match(TOKEN_RE) || [];
    }

    function formatNumSplit(val) {
        return String(val).split('').join(' ');
    }

    function formatStatePrefix(dealer, vuln, seat, turn, auctionStrs, handStr) {
        const auc = auctionStrs && auctionStrs.length
            ? auctionStrs.join(' ') : '-';
        return [
            `STATE dealer = ${dealer} vuln = ${formatNumSplit(vuln)}`,
            `seat = ${seat} turn = ${formatNumSplit(turn)}`,
            `AUCTION ${auc}`,
            `HAND ${handStr}`,
        ];
    }

    /** trace_factory.hand_str port: 'S : A K 2 H : ... T for 10, - for void. */
    function handStr(hand) {
        const parts = [];
        for (const k of api.SUIT_KEYS) {
            const ranks = hand.suits[k];
            const s = ranks.length ? ranks.map(r =>
                r === 14 ? 'A' : r === 13 ? 'K' : r === 12 ? 'Q' :
                r === 11 ? 'J' : r === 10 ? 'T' : String(r)).join(' ') : '-';
            parts.push(`${k[0].toUpperCase()} : ${s}`);
        }
        return parts.join(' ');
    }

    // ---- erf/gelu (torch nn.GELU exact form) ----------------------------------

    function erf(x) {
        const sign = x < 0 ? -1 : 1;
        x = Math.abs(x);
        const t = 1 / (1 + 0.3275911 * x);
        const y = 1 - (((((1.061405429 * t - 1.453152027) * t + 1.421413741) * t
            - 0.284496736) * t + 0.254829592) * t) * Math.exp(-x * x);
        return sign * y;
    }

    // ---- model ----------------------------------------------------------------

    class CotModel {
        constructor(manifest, weightsBuf) {
            this.cfg = manifest.config;
            this.vocab = manifest.vocab;                 // token -> id
            this.inv = {};
            for (const t in this.vocab) this.inv[this.vocab[t]] = t;
            this.block = this.cfg.block;
            this.d = this.cfg.n_embd;
            this.tensors = {};
            // accept an ArrayBuffer or a Uint8Array/Buffer of weight bytes
            const u8 = weightsBuf instanceof Uint8Array
                ? new Uint8Array(weightsBuf.buffer, weightsBuf.byteOffset,
                                 weightsBuf.byteLength)
                : new Uint8Array(weightsBuf);
            for (const [name, meta] of Object.entries(manifest.tensors)) {
                const shape = meta.shape;
                let data;
                if (manifest.dtype === 'fp16') {
                    const u16 = new Uint16Array(u8.buffer, u8.byteOffset,
                                                u8.byteLength / 2);
                    data = f16ToFloat32(u16.subarray(
                        meta.offset / 2, (meta.offset + meta.bytes) / 2));
                } else {
                    data = new Float32Array(u8.buffer,
                        u8.byteOffset + meta.offset, shape.reduce((a, b) => a * b, 1));
                }
                this.tensors[name] = {data, shape};
            }
        }

        t(name) { return this.tensors[name].data; }

        ln(out, x, prefix, offset, n) {
            const g = this.t(prefix + '.weight'), b = this.t(prefix + '.bias');
            let mean = 0;
            for (let i = 0; i < n; i++) mean += x[offset + i];
            mean /= n;
            let varr = 0;
            for (let i = 0; i < n; i++) {
                const d = x[offset + i] - mean;
                varr += d * d;
            }
            varr /= n;
            const inv = 1 / Math.sqrt(varr + 1e-5);
            for (let i = 0; i < n; i++) {
                out[offset + i] = (x[offset + i] - mean) * inv * g[i] + b[i];
            }
        }

        /** One transformer forward over `pos` using/ extending the KV cache.
         *  x: Float32Array [d] embeddings of the newest token at position pos.
         *  Returns the hidden state [d] after the final LN. */
        forwardStep(pos, xEmbed, kv) {
            const d = this.d, heads = this.cfg.n_head, hs = d / heads;
            let cur = xEmbed.slice();
            for (let layer = 0; layer < this.cfg.n_layer; layer++) {
                const p = `blocks.${layer}`;
                const ln1 = new Float32Array(d);
                this.ln(ln1, cur, `${p}.ln1`, 0, d);
                // fused qkv
                const W = this.t(`${p}.attn.qkv.weight`);   // [3d, d] row-major
                const B = this.t(`${p}.attn.qkv.bias`);
                const qkv = new Float32Array(3 * d);
                for (let r = 0; r < 3 * d; r++) {
                    let s = B[r];
                    const row = r * d, w = W.subarray(row, row + d);
                    for (let i = 0; i < d; i++) s += w[i] * ln1[i];
                    qkv[r] = s;
                }
                // cache k, v for this position
                const kc = kv[layer].k, vc = kv[layer].v;
                for (let r = 0; r < d; r++) {
                    kc[pos * d + r] = qkv[d + r];
                    vc[pos * d + r] = qkv[2 * d + r];
                }
                // causal attention per head
                const attOut = new Float32Array(d);
                for (let hI = 0; hI < heads; hI++) {
                    const off = hI * hs;
                    const q = qkv.subarray(off, off + hs);
                    const scores = new Float32Array(pos + 1);
                    let max = -Infinity;
                    for (let t = 0; t <= pos; t++) {
                        let s = 0;
                        const krow = kc.subarray(t * d + off, t * d + off + hs);
                        for (let i = 0; i < hs; i++) s += q[i] * krow[i];
                        s /= Math.sqrt(hs);
                        scores[t] = s;
                        if (s > max) max = s;
                    }
                    let sum = 0;
                    for (let t = 0; t <= pos; t++) {
                        scores[t] = Math.exp(scores[t] - max);
                        sum += scores[t];
                    }
                    const y = new Float32Array(hs);
                    for (let t = 0; t <= pos; t++) {
                        const psc = scores[t] / sum;
                        const vrow = vc.subarray(t * d + off, t * d + off + hs);
                        for (let i = 0; i < hs; i++) y[i] += psc * vrow[i];
                    }
                    // output projection rows for this head
                    const PW = this.t(`${p}.attn.proj.weight`);
                    const PB = this.t(`${p}.attn.proj.bias`);
                    for (let r = 0; r < d; r++) {
                        let s = 0;
                        const row = r * d + off;
                        for (let i = 0; i < hs; i++) s += PW[row + i] * y[i];
                        attOut[r] += s;
                    }
                }
                const PB2 = this.t(`${p}.attn.proj.bias`);
                for (let r = 0; r < d; r++) attOut[r] += PB2[r];
                for (let r = 0; r < d; r++) cur[r] += attOut[r];   // residual
                if (this.debug) this.debug(`fwd L${layer} attn+res`, cur, 1);

                const ln2 = new Float32Array(d);
                this.ln(ln2, cur, `${p}.ln2`, 0, d);
                // mlp: d -> 4d -> gelu -> d
                const W1 = this.t(`${p}.mlp.0.weight`), B1 = this.t(`${p}.mlp.0.bias`);
                const W2 = this.t(`${p}.mlp.2.weight`), B2 = this.t(`${p}.mlp.2.bias`);
                const h = new Float32Array(4 * d);
                for (let r = 0; r < 4 * d; r++) {
                    let s = B1[r];
                    const row = r * d, w = W1.subarray(row, row + d);
                    for (let i = 0; i < d; i++) s += w[i] * ln2[i];
                    h[r] = 0.5 * s * (1 + erf(s / Math.SQRT2));
                }
                const mlpOut = new Float32Array(d);
                for (let r = 0; r < d; r++) {
                    let s = B2[r];
                    const row = r * 4 * d, w = W2.subarray(row, row + 4 * d);
                    for (let i = 0; i < 4 * d; i++) s += w[i] * h[i];
                    mlpOut[r] = s;
                }
                if (this.debug) this.debug('fwd mlp out', mlpOut, 1);
                for (let r = 0; r < d; r++) cur[r] += mlpOut[r];   // residual
            }
            if (this.debug) this.debug('fwd attn+res', cur, 1);
            const lnf = new Float32Array(d);
            this.ln(lnf, cur, 'ln_f', 0, d);
            if (this.debug) this.debug('fwd ln_f', lnf, 1);
            return {hidden: lnf, last: cur};
        }

        logitsFor(hidden) {
            const d = this.d, V = this.cfg.vocab_size;
            const W = this.t('head.weight');   // [V, d]
            const logits = new Float32Array(V);
            for (let v = 0; v < V; v++) {
                let s = 0;
                const row = v * d, w = W.subarray(row, row + d);
                for (let i = 0; i < d; i++) s += w[i] * hidden[i];
                logits[v] = s;
            }
            return logits;
        }

        embed(tokenId, pos) {
            const d = this.d;
            const out = new Float32Array(d);
            const tok = this.t('tok_emb.weight').subarray(tokenId * d, tokenId * d + d);
            const posw = this.t('pos_emb.weight').subarray(pos * d, pos * d + d);
            for (let i = 0; i < d; i++) out[i] = tok[i] + posw[i];
            return out;
        }

        /** Greedy generation (port of generate_batch, temp=0, KV-cached).
         *  Returns {ids, text-less token list, avgConfidence}. */
        generate(promptIds, maxNew) {
            const V = this.cfg.vocab_size;
            let ids = promptIds.slice();
            let kv = null;
            const generated = [];
            let confSum = 0;
            for (let step = 0; step < maxNew; step++) {
                if (ids.length > this.block) {
                    ids = ids.slice(ids.length - this.block);
                    kv = null;   // context window slid: rebuild cache
                }
                let logits;
                if (!kv) {
                    kv = [];
                    for (let l = 0; l < this.cfg.n_layer; l++) {
                        kv.push({k: new Float32Array(this.block * this.d),
                                 v: new Float32Array(this.block * this.d)});
                    }
                    const {hidden} = this.prefill(ids, kv);
                    logits = this.logitsFor(hidden);
                } else {
                    const pos = ids.length - 1;
                    const emb = this.embed(ids[pos], pos);
                    const r = this.forwardStep(pos, emb, kv);
                    logits = this.logitsFor(r.hidden);
                }
                let best = 0;
                for (let v = 1; v < V; v++) if (logits[v] > logits[best]) best = v;
                let max = -Infinity;
                for (let v = 0; v < V; v++) if (logits[v] > max) max = logits[v];
                let sum = 0;
                for (let v = 0; v < V; v++) {
                    logits[v] = Math.exp(logits[v] - max);
                    sum += logits[v];
                }
                confSum += logits[best] / sum;
                if (best === this.vocab[SPECIALS.EOT]) break;
                ids.push(best);
                generated.push(best);
            }
            return {ids: generated,
                avgConfidence: generated.length ? confSum / generated.length : 0};
        }

        /** Prefill: process the whole prompt, filling the KV cache. */
        prefill(ids, kv) {
            const d = this.d;
            let x = new Float32Array(ids.length * d);
            for (let t = 0; t < ids.length; t++) {
                const e = this.embed(ids[t], t);
                x.set(e, t * d);
            }
            if (this.debug) this.debug('embed', x, ids.length);
            // run each layer over the whole window (non-incremental prefill)
            for (let layer = 0; layer < this.cfg.n_layer; layer++) {
                const p = `blocks.${layer}`;
                const T = ids.length;
                const ln1 = new Float32Array(T * d);
                for (let t = 0; t < T; t++) this.ln(ln1, x, `${p}.ln1`, t * d, d);
                const W = this.t(`${p}.attn.qkv.weight`), B = this.t(`${p}.attn.qkv.bias`);
                const heads = this.cfg.n_head, hs = d / heads;
                const qkv = new Float32Array(T * 3 * d);
                for (let t = 0; t < T; t++) {
                    for (let r = 0; r < 3 * d; r++) {
                        let s = B[r];
                        const row = r * d, w = W.subarray(row, row + d);
                        const xr = t * d;
                        for (let i = 0; i < d; i++) s += w[i] * ln1[xr + i];
                        qkv[t * 3 * d + r] = s;
                    }
                }
                const kc = kv[layer].k, vc = kv[layer].v;
                for (let t = 0; t < T; t++) {
                    for (let r = 0; r < d; r++) {
                        kc[t * d + r] = qkv[t * 3 * d + d + r];
                        vc[t * d + r] = qkv[t * 3 * d + 2 * d + r];
                    }
                }
                const attAll = new Float32Array(T * d);
                for (let hI = 0; hI < heads; hI++) {
                    const off = hI * hs;
                    for (let t = 0; t < T; t++) {
                        const q = qkv.subarray(t * 3 * d + off, t * 3 * d + off + hs);
                        const scores = new Float32Array(t + 1);
                        let max = -Infinity;
                        for (let u = 0; u <= t; u++) {
                            let s2 = 0;
                            const krow = kc.subarray(u * d + off, u * d + off + hs);
                            for (let i = 0; i < hs; i++) s2 += q[i] * krow[i];
                            s2 /= Math.sqrt(hs);
                            scores[u] = s2;
                            if (s2 > max) max = s2;
                        }
                        let sum = 0;
                        for (let u = 0; u <= t; u++) {
                            scores[u] = Math.exp(scores[u] - max);
                            sum += scores[u];
                        }
                        const y = new Float32Array(hs);
                        for (let u = 0; u <= t; u++) {
                            const psc = scores[u] / sum;
                            const vrow = vc.subarray(u * d + off, u * d + off + hs);
                            for (let i = 0; i < hs; i++) y[i] += psc * vrow[i];
                        }
                        const PW = this.t(`${p}.attn.proj.weight`);
                        for (let r = 0; r < d; r++) {
                            let s3 = 0;
                            const row = r * d + off;
                            for (let i = 0; i < hs; i++) s3 += PW[row + i] * y[i];
                            attAll[t * d + r] += s3;
                        }
                    }
                }
                const PB2 = this.t(`${p}.attn.proj.bias`);
                for (let t = 0; t < T; t++) {
                    for (let r = 0; r < d; r++) {
                        attAll[t * d + r] += PB2[r];
                        x[t * d + r] += attAll[t * d + r];
                    }
                }
                const ln2 = new Float32Array(T * d);
                for (let t = 0; t < T; t++) this.ln(ln2, x, `${p}.ln2`, t * d, d);
                const W1 = this.t(`${p}.mlp.0.weight`), B1 = this.t(`${p}.mlp.0.bias`);
                const W2 = this.t(`${p}.mlp.2.weight`), B2 = this.t(`${p}.mlp.2.bias`);
                for (let t = 0; t < T; t++) {
                    const h = new Float32Array(4 * d);
                    for (let r = 0; r < 4 * d; r++) {
                        let s = B1[r];
                        const row = r * d, w = W1.subarray(row, row + d);
                        const xr = t * d;
                        for (let i = 0; i < d; i++) s += w[i] * ln2[xr + i];
                        h[r] = 0.5 * s * (1 + erf(s / Math.SQRT2));
                    }
                    for (let r = 0; r < d; r++) {
                        let s = B2[r];
                        const row = r * 4 * d, w = W2.subarray(row, row + 4 * d);
                        for (let i = 0; i < 4 * d; i++) s += w[i] * h[i];
                        x[t * d + r] += s;
                    }
                }
                if (this.debug) this.debug(`${p}.out`, x, T);
            }
            if (this.debug) this.debug('ln_f', x, ids.length);
            const lnf = new Float32Array(ids.length * d);
            for (let t = 0; t < ids.length; t++) this.ln(lnf, x, 'ln_f', t * d, d);
            const lastT = ids.length - 1;
            return {hidden: lnf.subarray(lastT * d, lastT * d + d)};
        }
    }

    // ---- bidder (port of cot_bidder.py decision path) -------------------------

    function bidLegal(bidStr, auction, seatI, dealerI) {
        if (bidStr === 'PASS') return true;
        if (bidStr === 'X' || bidStr === 'XX') {
            let lastNp = null;
            for (let i = 0; i < auction.length; i++) {
                if (auction[i] !== 'P') lastNp = {i, tok: auction[i]};
            }
            if (!lastNp) return false;
            const seatOf = (dealerI + lastNp.i) % 4;
            const opp = seatOf !== seatI && seatOf !== (seatI + 2) % 4;
            if (lastNp.tok === 'X' || lastNp.tok === 'XX') return false;
            return opp;
        }
        let lvl, strain;
        try {
            lvl = parseInt(bidStr[0], 10);
            strain = {C: 0, D: 1, H: 2, S: 3, N: 4}[bidStr[1]];
        } catch (e) { return false; }
        if (isNaN(lvl) || strain === undefined) return false;
        let lastBid = null;
        for (const tok of auction) {
            if (/^[1-7][CDHSN]$/.test(tok)) lastBid = tok;
        }
        if (!lastBid || lastBid.length < 2 || !/[1-7]/.test(lastBid[0])) return true;
        const plvl = parseInt(lastBid[0], 10);
        const pstrain = {C: 0, D: 1, H: 2, S: 3, N: 4}[lastBid[1]];
        return lvl > plvl || (lvl === plvl && strain > pstrain);
    }

    function extractBid(text, auction, seatI, dealerI) {
        const parts = text.split(/\s+/);
        const lastBID = parts.lastIndexOf('BID');
        if (lastBID < 0 || lastBID + 1 >= parts.length) return null;
        // parse_bid reads the first atom after BID (level + strain chars)
        const atom = parts[lastBID + 1];
        if (atom === 'PASS') return new Call(C.PASS);
        if (atom === 'X' || atom === 'DBL') return new Call(C.DOUBLE);
        if (atom === 'XX' || atom === 'RDBL') return new Call(C.REDOUBLE);
        const m = atom.match(/^([1-7])(C|D|H|S|N)/);
        if (!m) return null;
        try {
            return new Call(C.BID, parseInt(m[1], 10),
                api.Strain.fromName(m[2] === 'N' ? 'NT' : m[2]));
        } catch (e) { return null; }
    }

    /** Wrap a loaded model as a reviewable engine ({kind:'cot'}).
     *  fallbackNet: the rule system used when the generated bid is illegal
     *  or unparseable (mirrors cot_bidder's symbolic fallback). */
    function makeEngine(model, manifest, Net, fallbackNet, label) {
        const engine = {
            kind: 'cot',
            model,
            label: label || `CoT student (transformer ${model.cfg.n_layer}L)`,
            key: null,
            explain(hand, history, mySeat, dealer, vuln) {
                const features = api.Features.extractAll(hand, history,
                    mySeat, dealer, vuln);
                const auctionStrs = history.map(c => c.toString());
                const hStr = handStr(hand);
                const lines = formatStatePrefix(api.SEAT_NAMES[dealer], vuln,
                    api.SEAT_NAMES[mySeat], history.length, auctionStrs, hStr);
                const V = model.vocab;
                let ids = [V[SPECIALS.BOS]];
                for (const ln of lines) {
                    for (const tok of tokenizeLine(ln)) {
                        if (V[tok] !== undefined) ids.push(V[tok]);
                    }
                }
                ids.push(V[SPECIALS.SEP]);
                const gen = model.generate(ids, 48);
                const allParts = [];
                for (const ln of lines) allParts.push(...tokenizeLine(ln));
                for (const id of gen.ids) allParts.push(model.inv[id] || '?');
                const cotText = allParts.join(' ');
                const bid = extractBid(cotText, auctionStrs, mySeat, dealer);
                const legality = api.Net.legalityContext(history, mySeat, dealer);
                let chosen, fallback = false, fallbackNote = null;
                if (bid && legality.isLegal(bid)) {
                    chosen = bid;
                } else {
                    const expF = api.Net.explain(fallbackNet, hand, history,
                        mySeat, dealer, vuln);
                    chosen = api.Net.autoSelect(fallbackNet, expF);
                    fallback = true;
                    fallbackNote = bid ? 'generated bid illegal' : 'no bid generated';
                }
                return {
                    kind: 'cot', features,
                    cotText: cotText.split('<sep>').pop().trim() || '(prompt only)',
                    bid: chosen,
                    chosen: {bid: chosen.toString(), call: chosen, legal: true},
                    candidates: [chosen], legal: [chosen], illegal: [],
                    fallbackPass: fallback && chosen.type === api.CallType.PASS,
                    fallback, fallbackNote,
                    confidence: gen.avgConfidence,
                    intersectionApplied: null, matchedIds: [],
                };
            },
        };
        return engine;
    }

    api.CotStudent = {
        SPECIALS, tokenizeLine, formatStatePrefix, handStr, bidLegal, extractBid,
        CotModel, makeEngine,
    };
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
