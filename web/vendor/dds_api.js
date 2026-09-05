/**
 * DDS WebAssembly API Client Library for JavaScript in Web Browsers.
 * Provides clean async initialization and ergonomic JavaScript methods for DDS functions.
 *
 * Copyright 2020-2026 Adam Wildavsky & Bo Haglund
 * Use of this source code is governed by the MIT license.
 */

(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        define([], factory);
    } else if (typeof module === 'object' && module.exports) {
        module.exports = factory();
    } else {
        root.DDS = factory();
    }
}(typeof self !== 'undefined' ? self : this, function () {
    let _modulePromise = null;

    return {
        /**
         * Initialize the DDS WebAssembly module.
         * @param {Object} options Optional Emscripten module configuration overrides.
         * @returns {Promise<Object>} Object containing bound DDS JS functions.
         */
        async init(options = {}) {
            if (_modulePromise) {
                return _modulePromise;
            }

            _modulePromise = (async () => {
                if (typeof createDdsApiModule !== 'function') {
                    throw new Error(
                        "createDdsApiModule is not defined. Ensure dds_wasm_api.js is loaded prior to init()."
                    );
                }

                const defaultOptions = {
                    locateFile: (path, scriptDirectory) => {
                        if (path.endsWith('.wasm')) {
                            return (scriptDirectory || '') + 'dds_wasm_api.wasm';
                        }
                        return (scriptDirectory || '') + path;
                    },
                    ...options
                };

                const module = await createDdsApiModule(defaultOptions);

                return {
                    /**
                     * Solve a single deal from PBN format.
                     * @param {string} pbn PBN remaining cards string.
                     * @param {number} trump Trump suit (0=♠, 1=♥, 2=♦, 3=♣, 4=NT). Default: 4
                     * @param {number} first Seat playing first (0=N, 1=E, 2=S, 3=W). Default: 0
                     * @param {Array<number>} trickSuit Current trick suits (3 ints). Default: []
                     * @param {Array<number>} trickRank Current trick ranks (3 ints). Default: []
                     * @param {number} target Target trick limit (-1 = max). Default: -1
                     * @param {number} solutions Depth of solution (1-3). Default: 3
                     * @param {number} mode Solve mode (0=auto). Default: 0
                     * @param {Object|null} context Reusable SolverContext or null.
                     */
                    solveBoardPBN(pbn, trump = 4, first = 0, trickSuit = [], trickRank = [], target = -1, solutions = 3, mode = 0, context = null) {
                        return module.solveBoardPBN(pbn, trump, first, trickSuit, trickRank, target, solutions, mode, context);
                    },

                    /**
                     * Calculate full double-dummy table (5 strains x 4 seats).
                     * @param {string} pbn PBN remaining cards string.
                     * @param {Object|null} context Reusable SolverContext or null.
                     */
                    calcDDTablePBN(pbn, context = null) {
                        return module.calcDDTablePBN(pbn, context);
                    },

                    /**
                     * Analyse play trace from PBN format.
                     * @param {string} pbn PBN deal string.
                     * @param {number} trump Trump suit (0-4).
                     * @param {number} first Seat playing first (0-3).
                     * @param {string} playPbnStr Play cards in PBN format (e.g., "SK DA S2").
                     * @param {Object|null} context Reusable SolverContext or null.
                     */
                    analysePlayPBN(pbn, trump, first, playPbnStr, context = null) {
                        return module.analysePlayPBN(pbn, trump, first, playPbnStr, context);
                    },

                    /**
                     * Calculate par score and contracts for a deal.
                     * @param {string} pbn PBN deal string.
                     * @param {number} vulnerable Vulnerability (0=None, 1=Both, 2=NS, 3=EW).
                     */
                    calcParPBN(pbn, vulnerable = 0) {
                        return module.calcParPBN(pbn, vulnerable);
                    },

                    /**
                     * Create a reusable SolverContext for optimal performance across multiple solves.
                     */
                    createContext() {
                        return new module.SolverContext();
                    },

                    /**
                     * Raw Emscripten WASM module instance.
                     */
                    rawModule: module
                };
            })();

            return _modulePromise;
        }
    };
}));
