Canonicalize the input, not just the tokenizer — emit traces with a fixed alphabet of semantic atoms:

Cards → rank chars only: A K Q J T 9 8 ... instead of suit-symbols concatenated (SAK4 → S A K 4)
Calls → fixed 38-token set: 35 bids + PASS + X + XX (e.g. BID_4H, PASS, X)
Numbers → digit chars, not multi-digit words (21 → 2 1 or TOK_21)
Constraint sentences → already templated (hcp>=15), keep those as-is
That makes token growth closed: new data never introduces new atoms, only recombines them. Vocab freezes around ~300–800 regardless of corpus size.

Practical steps:

Fix tokenization in trace_factory.py/example_lines() to emit pre-split atoms (space-separate every card, call, number).
Freeze one vocab file (data/cot_dataset/vocab.json), commit it; build_cot_dataset maps to it instead of training a new one (error if an unseen token appears — that's the catch, which is what you want).
After freeze, retrain once from scratch; from then on refresh_student.py can warm-start from incumbent weights → incumbent/candidate comparisons work again → promotion gate functions correctly.
Bonus: smaller vocab + heater input likely helps accuracy (fewer spurious rare tokens, cleaner credit assignment over reasoning atoms).
This is the single highest-leverage change before any more training: it unbreaks promotion, enables fine-tuning, and removes a whole class of regressions. Do vocab freeze + canonicalization first, then retrain the 20-epoch run I recommended, then consider RL.