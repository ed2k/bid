import json
import os
import unittest

from bid.cot_tokenizer import (
    Tokenizer, tokenize_line, format_state_prefix, example_lines,
    build_frozen_vocab, CALLS_38, SPECIALS, PAD, BOS, SEP, EOT
)
from bid.trace_factory import hand_str
from bid.models import Hand


class TestCotVocab(unittest.TestCase):
    def setUp(self):
        self.vocab = build_frozen_vocab()
        self.tokenizer = Tokenizer(self.vocab)

    def test_fixed_38_calls_in_vocab(self):
        self.assertEqual(len(CALLS_38), 38)
        for call in CALLS_38:
            self.assertIn(call, self.vocab, f"Call {call} must be in frozen vocab")
            tokens = tokenize_line(f"AUCTION {call}")
            self.assertEqual(tokens, ["AUCTION", call])

    def test_digits_and_number_splitting(self):
        for d in range(10):
            self.assertIn(str(d), self.vocab)
        # Check that multi-digit numbers are tokenized as individual digit atoms
        line = "turn = 24 hcp >= 21"
        toks = tokenize_line(line)
        self.assertEqual(toks, ["turn", "=", "2", "4", "hcp", ">=", "2", "1"])
        for t in toks:
            self.assertIn(t, self.vocab)

    def test_hand_cards_space_separated(self):
        hand = Hand.from_string("SAK4 HQJT D986 C7532")
        h_str = hand_str(hand)
        self.assertEqual(h_str, "S : A K 4 H : Q J T D : 9 8 6 C : 7 5 3 2")
        toks = tokenize_line(f"HAND {h_str}")
        expected = ["HAND", "S", ":", "A", "K", "4", "H", ":", "Q", "J", "T",
                    "D", ":", "9", "8", "6", "C", ":", "7", "5", "3", "2"]
        self.assertEqual(toks, expected)
        for t in toks:
            self.assertIn(t, self.vocab)

    def test_void_suit_hand(self):
        hand = Hand.from_string("SAKQJT98765432 H D C")
        h_str = hand_str(hand)
        self.assertIn("H : -", h_str)
        self.assertIn("D : -", h_str)
        self.assertIn("C : -", h_str)
        toks = tokenize_line(f"HAND {h_str}")
        for t in toks:
            self.assertIn(t, self.vocab)

    def test_strict_tokenization_raises_on_unseen(self):
        unseen_line = "EXPLANATION RULE UNSEEN_UNKNOWN_RULE_999 ( hcp >= 12 )"
        with self.assertRaises(KeyError) as ctx:
            self.tokenizer.encode_line(unseen_line, strict=True)
        self.assertIn("Unseen token 'UNSEEN_UNKNOWN_RULE_999'", str(ctx.exception))

    def test_frozen_vocab_file_integrity(self):
        vocab_file = os.path.join(
            os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
            "data", "cot_dataset", "vocab.json"
        )
        self.assertTrue(os.path.exists(vocab_file), f"vocab.json missing at {vocab_file}")
        with open(vocab_file) as f:
            disk_vocab = json.load(f)
        self.assertEqual(len(disk_vocab), len(self.vocab))
        self.assertEqual(disk_vocab, self.vocab)

    def test_example_lines_canonical_atoms(self):
        trace_obj = {
            "board": {"dealer": "NORTH", "vuln": 0},
            "seat": "NORTH",
            "call_index": 12,
            "input": {
                "auction": ["1C", "PASS", "1H"],
                "hand": "S : A K 4 H : Q J T D : 9 8 6 C : 7 5 3 2",
            },
            "explanation": {
                "rule": "R_1D",
                "constraints": [["hcp", ">=", 15], ["is_balanced", "==", True],
                                ["partner_last_call", "in", ["1C", "1D"]]],
            },
            "bid": "4H",
        }
        prefix, target = example_lines(trace_obj)
        for line in prefix + target:
            # Must encode without any unknown token errors
            ids = self.tokenizer.encode_line(line, strict=True)
            self.assertGreater(len(ids), 0)


if __name__ == "__main__":
    unittest.main()
