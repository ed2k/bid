import json
import os
import shutil
import subprocess
import sys
import unittest

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from bid import web_export

WEB_DIR = os.path.join(web_export.REPO_ROOT, "web")


class TestWebExport(unittest.TestCase):
    """The exporter bridges repo artifacts into the static review UI."""

    def test_build_snapshot_shape(self):
        snap = web_export.build_snapshot(boards=4)
        for key in ("dsl", "dsl_sha256", "teacher", "student", "mining",
                    "traces", "boards"):
            self.assertIn(key, snap)
        self.assertTrue(snap["dsl"].startswith("#"), "DSL text must be embedded")
        self.assertGreater(len(snap["traces"]), 0, "sampled boards carry rows")
        for row in snap["traces"]:
            self.assertIn("input", row)
            self.assertIn("hand", row["input"])
            self.assertIn("auction", row["input"])
            self.assertIn("features", row["input"])
            self.assertIn("bid", row)
        # sampled boards must be complete enough for native DD solving
        for key, sol in snap["boards"].items():
            self.assertEqual(len(sol["dd_table"]), 5)
            self.assertEqual(len(sol["dd_table"][0]), 4)

    def test_export_writes_parseable_js_module(self):
        out = os.path.join(web_export.REPO_ROOT, "web", "review_data.js")
        self.assertTrue(os.path.exists(out),
            "review_data.js missing — run `python3 -m bid.web_export` once")
        with open(out) as f:
            content = f.read()
        self.assertIn("globalThis.BID_REVIEW_DATA = ", content)
        # the JSON payload must parse
        payload = content.split("globalThis.BID_REVIEW_DATA = ", 1)[1]
        payload = payload.rsplit(";", 1)[0].replace("<\\/", "</")
        data = json.loads(payload)
        self.assertIn("teacher", data)


class TestWebEngine(unittest.TestCase):
    """Runs the JS cross-validation suite (node) when node is available."""

    def test_engine_cross_validation(self):
        node = shutil.which("node")
        if not node:
            self.skipTest("node not available")
        script = os.path.join(web_export.REPO_ROOT, "tests", "web",
                              "engine_test.mjs")
        proc = subprocess.run([node, script], cwd=web_export.REPO_ROOT,
                              capture_output=True, text=True, timeout=120)
        self.assertEqual(proc.returncode, 0,
            f"engine test failed:\n{proc.stdout}\n{proc.stderr}")
        self.assertIn("0 failed", proc.stdout)


if __name__ == "__main__":
    unittest.main()
