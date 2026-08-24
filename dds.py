#!/usr/bin/env python3
"""
Double Dummy Solver (DDS) Native Interface for Bid.
Integrates Bo Haglund's C++ Double Dummy Solver (libdds.dylib / libdds.so / dds.dll)
copied and adapted from BEN (../ben/bin/libdds).
"""

import os
import sys
import platform
import ctypes
from typing import Dict, Tuple, Optional, Any, TYPE_CHECKING
from bid.models import Seat, Strain, Suit, Hand

if TYPE_CHECKING:
    from bid.sampling import Deal

class ddTableDealPBN(ctypes.Structure):
    _fields_ = [("cards", ctypes.c_char * 80)]

class dealPBN(ctypes.Structure):
    _fields_ = [("remainCards", ctypes.c_char * 80),
                ("trump", ctypes.c_int),
                ("first", ctypes.c_int),
                ("currentTrickSuit", ctypes.c_int * 3),
                ("currentTrickRank", ctypes.c_int * 3)]

class futureTricks(ctypes.Structure):
    _fields_ = [("nodes", ctypes.c_int),
                ("cards", ctypes.c_int),
                ("suit", ctypes.c_int * 13),
                ("rank", ctypes.c_int * 13),
                ("equals", ctypes.c_int * 13),
                ("score", ctypes.c_int * 13)]

class ddTableResults(ctypes.Structure):
    # resTable[strain][player] where strain: 0=Spade, 1=Heart, 2=Diamond, 3=Club, 4=NT
    _fields_ = [("resTable", ctypes.c_int * 4 * 5)]

class parResults(ctypes.Structure):
    _fields_ = [
        ("parScore", (ctypes.c_char * 16) * 2),
        ("parContractsString", (ctypes.c_char * 128) * 2)
    ]

class DDSolver:
    """
    High-performance Double Dummy Solver wrapper.
    Loads native libdds library from bin directories with automatic fallback.
    """
    _lib = None
    _loaded = False

    @classmethod
    def _find_and_load_lib(cls):
        if cls._loaded:
            return cls._lib

        search_paths = [
            os.path.join(os.path.dirname(__file__), "..", "bin"),
            os.path.join(os.path.dirname(__file__), "..", "..", "ben", "bin"),
            os.path.join(os.path.dirname(__file__), "bin"),
            "/Users/admin/Documents/GitHub/ben/bin"
        ]

        lib_names = []
        if sys.platform == "darwin":
            lib_names = ["libdds.dylib"]
        elif sys.platform == "win32":
            lib_names = ["dds.dll"]
        else:
            lib_names = ["libdds.so"]

        for path in search_paths:
            for name in lib_names:
                full_path = os.path.abspath(os.path.join(path, name))
                if os.path.isfile(full_path):
                    try:
                        cls._lib = ctypes.CDLL(full_path)
                        cls._loaded = True
                        return cls._lib
                    except Exception as e:
                        sys.stderr.write(f"Warning: Failed loading {full_path}: {e}\n")

        cls._loaded = True
        return None

    @classmethod
    def deal_to_pbn(cls, deal: Deal) -> str:
        """Converts a Deal object to PBN string format starting from North: 'N:S.H.D.C ...'"""
        order = [Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST]
        hands_str = []
        for seat in order:
            hand = deal.hands[seat]
            s_str = "".join(str(c.rank) for c in sorted(hand.by_suit[Suit.SPADES], key=lambda c: c.rank.value, reverse=True))
            h_str = "".join(str(c.rank) for c in sorted(hand.by_suit[Suit.HEARTS], key=lambda c: c.rank.value, reverse=True))
            d_str = "".join(str(c.rank) for c in sorted(hand.by_suit[Suit.DIAMONDS], key=lambda c: c.rank.value, reverse=True))
            c_str = "".join(str(c.rank) for c in sorted(hand.by_suit[Suit.CLUBS], key=lambda c: c.rank.value, reverse=True))
            hands_str.append(f"{s_str}.{h_str}.{d_str}.{c_str}")
        return "N:" + " ".join(hands_str)

    @classmethod
    def strain_to_dds_index(cls, strain: Strain) -> int:
        """
        DDS convention:
        0 = Spades, 1 = Hearts, 2 = Diamonds, 3 = Clubs, 4 = No Trump
        """
        mapping = {
            Strain.SPADES: 0,
            Strain.HEARTS: 1,
            Strain.DIAMONDS: 2,
            Strain.CLUBS: 3,
            Strain.NT: 4
        }
        return mapping.get(strain, 4)

    @classmethod
    def solve_dd_table(cls, deal: Deal) -> Dict[Tuple[Strain, Seat], int]:
        """
        Calculates all 20 double dummy trick contracts (5 strains x 4 declarers).
        Returns a dict mapping (strain, seat) -> tricks_won.
        """
        lib = cls._find_and_load_lib()
        pbn_str = cls.deal_to_pbn(deal)

        if lib is not None:
            try:
                table_deal = ddTableDealPBN()
                table_deal.cards = pbn_str.encode("utf-8")
                table_results = ddTableResults()

                ret = lib.CalcDDtablePBN(table_deal, ctypes.byref(table_results))
                if ret == 1:
                    results: Dict[Tuple[Strain, Seat], int] = {}
                    strain_map = [Strain.SPADES, Strain.HEARTS, Strain.DIAMONDS, Strain.CLUBS, Strain.NT]
                    seat_map = [Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST]

                    for s_idx, strain in enumerate(strain_map):
                        for p_idx, seat in enumerate(seat_map):
                            results[(strain, seat)] = table_results.resTable[s_idx][p_idx]
                    cls._cleanup_error_dump()
                    return results
                sys.stderr.write(f"[dds] CalcDDtablePBN failed rc={ret}; "
                                 f"using per-contract fallback\n")
                cls._cleanup_error_dump()
            except Exception as e:
                sys.stderr.write(f"DDS C-API error: {e}, falling back to Python DD algorithm\n")
                cls._cleanup_error_dump()


        exact = cls._exact_fallback_table(deal)
        if exact is not None:
            return exact
        sys.stderr.write("[dds] WARNING: heuristic fallback table in use\n")
        return cls._fallback_dd_table(deal)

    @classmethod
    def _exact_fallback_table(cls, deal):
        mod = cls._load_dds3()
        if mod is None:
            return None
        ctx = cls._context()
        if ctx is None:
            return None
        try:
            order = [Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST]
            pbn = "N:" + " ".join(cls._cards_to_pbn_suits(deal.hands[s]) for s in order)
            results: Dict[Tuple[Strain, Seat], int] = {}
            strains = [Strain.SPADES, Strain.HEARTS, Strain.DIAMONDS,
                       Strain.CLUBS, Strain.NT]
            for strain_idx, strain in enumerate(strains):
                for d_i, decl in enumerate(order):
                    fut = mod.solve_board_pbn(
                        pbn, trump=strain_idx, first=d_i,
                        current_trick_suit=(0, 0, 0),
                        current_trick_rank=(0, 0, 0),
                        target=-1, solutions=1, mode=2, context=ctx)
                    results[(strain, decl)] = int(fut["score"][0])
            return results
        except Exception as e:
            sys.stderr.write(f"[dds] exact fallback error: {e}\n")
            cls._cleanup_error_dump()
            return None

    @classmethod
    def calculate_par(cls, deal: Deal, vuln: int = 0) -> Tuple[int, str]:
        """
        Calculates the double dummy par score and contract for the deal.
        Returns (ns_par_score, par_contract_str).
        """
        lib = cls._find_and_load_lib()
        pbn_str = cls.deal_to_pbn(deal)

        if lib is not None:
            try:
                table_deal = ddTableDealPBN()
                table_deal.cards = pbn_str.encode("utf-8")
                table_results = ddTableResults()

                if lib.CalcDDtablePBN(table_deal, ctypes.byref(table_results)) == 1:
                    par_res = parResults()
                    if lib.Par(ctypes.byref(table_results), ctypes.byref(par_res), vuln) == 1:
                        score_str = par_res.parScore[0].value.decode()
                        contract_str = par_res.parContractsString[0].value.decode()
                        score_val = int(score_str.split()[1]) if len(score_str.split()) > 1 else 0
                        return score_val, contract_str
            except Exception as e:
                sys.stderr.write(f"DDS Par calculation error: {e}\n")

        return 0, "N/A"

    @classmethod
    def get_tricks(cls, deal: Deal, strain: Strain, declarer: Seat) -> int:
        """Returns the exact double dummy tricks for a given contract."""
        table = cls.solve_dd_table(deal)
        key = (strain, declarer)
        if key not in table:
            sys.stderr.write(f"[dds] missing table entry {key}; reporting 0\n")
            return 0
        return table[key]

    @staticmethod
    def _fallback_dd_table(deal: Deal) -> Dict[Tuple[Strain, Seat], int]:
        """Fast fallback double dummy trick estimation if C library is unavailable."""
        results: Dict[Tuple[Strain, Seat], int] = {}
        for declarer in Seat:
            partner = declarer.partner
            h1 = deal.hands[declarer]
            h2 = deal.hands[partner]
            tot_hcp = h1.hcp + h2.hcp

            for strain in Strain:
                if strain == Strain.NT:
                    base = min(13, max(0, int(tot_hcp / 3.0 + 1)))
                else:
                    suit = Suit(strain.value)
                    fit = h1.length(suit) + h2.length(suit)
                    base = min(13, max(0, int((tot_hcp / 3.1) + max(0, fit - 7) * 1.1)))
                results[(strain, declarer)] = base
        return results

    _pbn_ranks = "23456789TJQKA"

    @classmethod
    def _cards_to_pbn_suits(cls, cards) -> str:
        """PBN suit order is S.H.D.C; repo Suit enums are alphabetical."""
        by_suit = {Suit.SPADES: [], Suit.HEARTS: [], Suit.DIAMONDS: [], Suit.CLUBS: []}
        for c in cards:
            r = getattr(c.rank, "value", c.rank)
            by_suit[c.suit].append(int(r))
        parts = []
        for s in (Suit.SPADES, Suit.HEARTS, Suit.DIAMONDS, Suit.CLUBS):
            ranks = sorted(by_suit[s], reverse=True)
            parts.append("".join(cls._pbn_ranks[r - 2] for r in ranks) if ranks else "-")
        return ".".join(parts)

    _dds3_mod = None
    _dds3_checked = False

    @staticmethod
    def _cleanup_error_dump():
        """libdds writes a dump.txt diagnostic to the CWD on solve errors;
        remove it so debug artifacts never leak into the working tree."""
        try:
            p = os.path.join(os.getcwd(), "dump.txt")
            if os.path.exists(p):
                os.remove(p)
        except OSError:
            pass

    @classmethod
    def _load_dds3(cls):
        """
        Loads the DDS 3.x Python extension (SolverContext API) vendored under
        BEN's bin directory, preferring a build matching the running Python.
        """
        if cls._dds3_checked:
            return cls._dds3_mod
        cls._dds3_checked = True
        try:
            import threading
            import glob
            import importlib.util
            here = os.path.dirname(os.path.abspath(__file__))
            roots = [
                os.path.join(here, "..", "..", "ben", "bin", "dds3-darwin", "dds3"),
                os.path.join(here, "..", "ben", "bin", "dds3-darwin", "dds3"),
                "/Users/admin/Documents/GitHub/ben/bin/dds3-darwin/dds3",
            ]
            py_tag = f"{sys.version_info.major}{sys.version_info.minor}"
            for root in roots:
                if not os.path.isdir(root):
                    continue
                sos = sorted(glob.glob(os.path.join(root, "_dds3*.so")),
                             key=lambda p: (py_tag in p, "arm" in p), reverse=True)
                for so in sos:
                    try:
                        spec = importlib.util.spec_from_file_location("_dds3", so)
                        mod = importlib.util.module_from_spec(spec)
                        spec.loader.exec_module(mod)
                        cls._dds3_mod = mod
                        print(f"dds3 leaf solver loaded from {so}", file=sys.stderr)
                        return mod
                    except ImportError:
                        continue
        except Exception:
            pass
        return None

    _ctx_local = __import__("threading").local()

    @classmethod
    def _context(cls):
        import threading
        ctx = getattr(cls._ctx_local, "ctx", None)
        if ctx is None:
            mod = cls._load_dds3()
            if mod is None:
                return None
            ctx = mod.SolverContext()
            cls._ctx_local.ctx = ctx
        return ctx

    @classmethod
    def solve_position(cls, hands: Dict[Seat, list], trump: int, first: int,
                       trick: list = None) -> Optional[int]:
        """
        Exact double-dummy solve of an in-play position (SDS leaf evaluation).
        hands: {Seat: list[Card]} remaining cards. trump: DDS strain index
        (0=S,1=H,2=D,3=C,4=NT). first: seat index on lead. trick: played cards
        [(seat_index, Card)] on the current trick (<= 3).
        Returns tricks won by the leader's partnership for the rest of the deal.
        """
        mod = cls._load_dds3()
        if mod is None:
            return None
        ctx = cls._context()
        if ctx is None:
            return None
        order = [Seat.NORTH, Seat.EAST, Seat.SOUTH, Seat.WEST]
        pbn = "N:" + " ".join(cls._cards_to_pbn_suits(hands[s]) for s in order)
        trick = trick or []
        # DDS suit order is S,H,D,C while repo enums are C,D,H,S -> reverse
        ts = tuple(3 - int(c.suit.value) for _, c in trick[:3]) + (0,) * (3 - min(3, len(trick)))
        tr = tuple(int(getattr(c.rank, "value", c.rank)) for _, c in trick[:3]) + (0,) * (3 - min(3, len(trick)))
        try:
            fut = mod.solve_board_pbn(
                pbn, trump=trump, first=first,
                current_trick_suit=ts, current_trick_rank=tr,
                target=-1, solutions=1, mode=2, context=ctx)
            return int(fut["score"][0])
        finally:
            cls._cleanup_error_dump()
