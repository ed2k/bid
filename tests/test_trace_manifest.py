import hashlib
import json
import os
import unittest

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CORPUS = os.path.join(ROOT, "data", "traces", "traces.jsonl")
META = CORPUS.replace(".jsonl", ".meta.json")


@unittest.skipUnless(os.path.exists(CORPUS), "corpus not generated")
class TestTraceManifest(unittest.TestCase):
    def test_meta_exists_and_matches(self):
        self.assertTrue(os.path.exists(META),
                        "meta manifest missing next to corpus")
        meta = json.load(open(META))
        self.assertEqual(meta["n_traces"],
                         sum(1 for _ in open(CORPUS)))
        h = hashlib.sha256(open(CORPUS, "rb").read()).hexdigest()
        self.assertEqual(meta["corpus_sha256"], h)

    def test_dsl_provenance_recorded(self):
        meta = json.load(open(META))
        self.assertIn("dsl_source", meta)
        self.assertIn("dsl_sha256", meta)


if __name__ == "__main__":
    unittest.main()
