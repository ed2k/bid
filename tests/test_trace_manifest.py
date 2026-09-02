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
        with open(META, "r", encoding="utf-8") as f:
            meta = json.load(f)
        with open(CORPUS, "r", encoding="utf-8") as f:
            n_traces = sum(1 for _ in f)
        self.assertEqual(meta["n_traces"], n_traces)
        with open(CORPUS, "rb") as f:
            h = hashlib.sha256(f.read()).hexdigest()
        self.assertEqual(meta["corpus_sha256"], h)

    def test_dsl_provenance_recorded(self):
        with open(META, "r", encoding="utf-8") as f:
            meta = json.load(f)
        self.assertIn("dsl_source", meta)
        self.assertIn("dsl_sha256", meta)


if __name__ == "__main__":
    unittest.main()
