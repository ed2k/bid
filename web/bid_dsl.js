/**
 * bid_dsl.js — parser for the Bid system DSL.
 *
 * JS port of eval_vs_dds.load_decision_net_dsl: parses both exported formats
 *   one-line:  RULE <id> PRIORITY <n> ACTION <call> WHEN c1, c2, ...
 *   block:     RULE <id>: / CALL: / PRIORITY: / CONDITION: / NEGATIVE: True
 *   plus:      INTERSECTION <id> ^ <id>: / RESOLVED_CALL: <call>
 */
(function (api) {
    'use strict';

    const Call = api.Call;

    function parseValue(text) {
        let s = text.trim();
        if ((s.startsWith("'") && s.endsWith("'")) ||
            (s.startsWith('"') && s.endsWith('"'))) {
            return s.slice(1, -1);
        }
        if (/^\[.*\]$/.test(s)) {
            const inner = s.slice(1, -1).trim();
            if (!inner) return [];
            return inner.split(',').map(p => parseValue(p));
        }
        if (s === 'True') return true;
        if (s === 'False') return false;
        if (s === 'None') return null;
        if (/^-?\d+\.\d+$/.test(s)) return parseFloat(s);
        if (/^-?\d+$/.test(s)) return parseInt(s, 10);
        return s;
    }

    function parseCondition(text) {
        const m = text.trim().match(/^(\w+)\s*(==|!=|>=|<=|>|<|not_in|in)\s*(.+)$/);
        if (!m) throw new Error('Bad condition: ' + JSON.stringify(text));
        return {key: m[1], op: m[2], value: parseValue(m[3]), raw: text.trim()};
    }

    /** Split 'a >= 5, b in [1, 2], c == "X"' on top-level commas (port of
     *  eval_vs_dds._split_conditions: quote- and bracket-aware). */
    function splitConditions(text) {
        const parts = [];
        let depth = 0, quote = null, cur = '';
        for (const ch of text) {
            if (quote) {
                cur += ch;
                if (ch === quote) quote = null;
                continue;
            }
            if (ch === "'" || ch === '"') {
                quote = ch;
                cur += ch;
            } else if (ch === '[') {
                depth++;
                cur += ch;
            } else if (ch === ']') {
                depth--;
                cur += ch;
            } else if (ch === ',' && depth === 0) {
                parts.push(cur.trim());
                cur = '';
            } else {
                cur += ch;
            }
        }
        if (cur.trim()) parts.push(cur.trim());
        return parts.filter(p => p);
    }

    /**
     * Parse the DSL text into {name, rules: [...], intersections: {key: call}}.
     * rules: {ruleId, call: Call, conditions: [...], isNegative, priority}
     */
    function parse(text, name) {
        const lines = String(text).split(/\r?\n/);
        const net = {name: name || 'ParsedSystem', rules: [], intersections: {}};

        let i = 0;
        while (i < lines.length) {
            const stripped = lines[i].trim();
            if (!stripped || stripped.startsWith('#')) { i++; continue; }

            const oneLine = stripped.match(/^RULE\s+(\S+)\s+PRIORITY\s+(-?\d+)\s+ACTION\s+(\S+)\s+WHEN\s+(.+)$/);
            if (oneLine) {
                const [, rid, prio, action, conds] = oneLine;
                net.rules.push({
                    ruleId: rid,
                    call: Call.parse(action),
                    conditions: splitConditions(conds).map(parseCondition),
                    isNegative: false,
                    priority: parseInt(prio, 10)
                });
                i++;
                continue;
            }

            const blockRule = stripped.match(/^RULE\s+(.+?):$/);
            if (blockRule) {
                const rid = blockRule[1].trim();
                let call = null, prio = 10, conditions = [], isNeg = false;
                i++;
                while (i < lines.length) {
                    const sub = lines[i].trim();
                    if (sub.startsWith('RULE ') || sub.startsWith('INTERSECTION')) break;
                    if (sub.startsWith('CALL:')) call = Call.parse(sub.split('CALL:')[1].trim());
                    else if (sub.startsWith('PRIORITY:')) prio = parseInt(sub.split('PRIORITY:')[1].trim(), 10);
                    else if (sub.startsWith('NEGATIVE:')) isNeg = sub.split('NEGATIVE:')[1].trim() === 'True';
                    else if (sub.startsWith('CONDITION:')) conditions.push(parseCondition(sub.split('CONDITION:').slice(1).join(':')));
                    i++;
                }
                if (call !== null) {
                    net.rules.push({ruleId: rid, call, conditions, isNegative: isNeg, priority: prio});
                }
                continue;
            }

            const inter = stripped.match(/^INTERSECTION\s+(.+?):$/);
            if (inter) {
                const ruleIds = inter[1].split('^').map(t => t.trim());
                let resolved = null;
                i++;
                while (i < lines.length) {
                    const sub = lines[i].trim();
                    if (sub.startsWith('RULE ') || sub.startsWith('INTERSECTION')) break;
                    if (sub.startsWith('RESOLVED_CALL:')) {
                        resolved = Call.parse(sub.split('RESOLVED_CALL:')[1].trim());
                    }
                    i++;
                }
                if (resolved !== null && ruleIds.length > 1) {
                    net.intersections[ruleIds.slice().sort().join('^')] = resolved;
                }
                continue;
            }
            i++;
        }
        return net;
    }

    api.DSL = {parse, parseCondition, parseValue, splitConditions};
})(typeof globalThis !== 'undefined' ? (globalThis.BidWeb = globalThis.BidWeb || {}) : (window.BidWeb = window.BidWeb || {}));
