# Building & Using the Double Dummy Solver (DDS) Library

The **Double Dummy Solver (DDS)**, originally created by Bo Haglund and maintained by Soren Hein and Martin Nygren, is the global gold standard for contract bridge analysis. It computes exact, optimal minimax card play assuming all four hands are visible.

In this repository, [`src/bid/dds.py`](file:///Users/admin/Documents/GitHub/bid/src/bid/dds.py) wraps DDS to compute:
- **All 20 contract trick values** (5 strains $\times$ 4 declarers) via `CalcDDtablePBN`.
- **Double Dummy Par contracts & scores** (game-theoretic minimax equilibrium) via `CalcParPBN`.
- **Mid-play trick expectations** for specific leads and remaining cards via `SolveBoardPBN`.

---

## 1. Quick Verification: Is DDS Active?

Run this one-line check in your terminal:

```bash
.venv/bin/python3 -c "from bid.dds import DDSolver; print('DDS Library:', DDSolver._find_and_load_lib())"
```

- **If loaded successfully**:
  ```text
  DDS Library: <CDLL '.../bid/bin/libdds.dylib', handle ...>
  ```
  Double dummy calculations run at **native C++ multi-threaded speed** (solving hundreds of boards per second).
- **If `None`**:
  ```text
  DDS Library: None
  ```
  The repository automatically falls back to an internal heuristic solver so code never crashes, but calculations will be slower.

---

## 2. Directory Layout: Where Binaries Live

`DDSolver` automatically checks the following paths for the shared library:

```text
bid/
├── bin/
│   ├── libdds.dylib      # macOS (Intel or Apple Silicon)
│   ├── libdds.so         # Linux (x86_64 or aarch64)
│   └── dds.dll           # Windows (x64)
├── src/bid/
│   └── dds.py            # Python ctypes / C++ bindings
```

If the library is placed inside `bin/`, `bid` discovers and loads it with zero manual configuration.

---

## 3. Building `libdds` from Source

If you need to compile `libdds` for your specific OS or CPU architecture, follow the instructions below.

### Option A: Standard C++ Shared Library (GCC / Clang)

The classic DDS engine can be compiled directly using standard C++ compilers with OpenMP multi-threading:

#### 1. Linux (`libdds.so`)
```bash
# Install build tools and OpenMP
sudo apt-get update && sudo apt-get install -y build-essential libomp-dev

# Clone the DDS repository
git clone https://github.com/dds-bridge/dds.git /tmp/dds
cd /tmp/dds/src

# Compile shared library with OpenMP
g++ -O3 -fPIC -shared -fopenmp -std=c++17 \
    *.cpp \
    -o /path/to/bid/bin/libdds.so
```

#### 2. macOS (`libdds.dylib`)
On macOS, Apple Clang requires `libomp` (via Homebrew) to support OpenMP multi-threading:
```bash
# Install OpenMP via Homebrew
brew install libomp

# Clone the DDS repository
git clone https://github.com/dds-bridge/dds.git /tmp/dds
cd /tmp/dds/src

# Compile dynamic library (Apple Silicon or Intel)
clang++ -O3 -dynamiclib -std=c++17 \
    -Xpreprocessor -fopenmp -I$(brew --prefix libomp)/include \
    -L$(brew --prefix libomp)/lib -lomp \
    *.cpp \
    -o /path/to/bid/bin/libdds.dylib
```

#### 3. Windows (`dds.dll`)
Using MSVC Developer Command Prompt:
```cmd
cl /O2 /LD /openmp *.cpp /Fe:dds.dll
copy dds.dll C:\path\to\bid\bin\dds.dll
```

---

### Option B: Building via Modern Bazel (DDS 3.0)

If using the modern DDS 3.0 repository ([dds-bridge/dds](https://github.com/dds-bridge/dds)):

```bash
cd /path/to/dds

# 1. Build C++ shared library
bazelisk build -c opt //library/src:dds

# Copy the built library to bid/bin/
cp bazel-bin/library/src/libdds.* /path/to/bid/bin/
```

To build the Python pybind11 extension (`_dds3.so`):
```bash
# Build matching your Python version (e.g. 3.12)
bazelisk build -c opt \
  --@rules_python//python/config_settings:python_version=3.12 \
  //python:_dds3

# Place into your environment or copy to bin/
cp bazel-bin/python/_dds3.so /path/to/bid/bin/
```

---

## 4. How to Use DDS in Python Code

### 4.1 Solving All 20 Contracts on a Deal
Double dummy tables calculate how many tricks each seat (N, E, S, W) can make in each strain (♠, ♥, ♦, ♣, NT):

```python
from bid.sampling import Deal
from bid.eval_vs_dds import build_deals
from bid.dds import DDSolver
from bid.models import Seat, Strain

deal = build_deals(1, seed=42)[0]
table = DDSolver.solve_dd_table(deal)

# Inspect tricks:
for strain in (Strain.NT, Strain.SPADES, Strain.HEARTS):
    print(f"{strain.name:<7} | North: {table[(strain, Seat.NORTH)]:2d} tricks "
          f"| South: {table[(strain, Seat.SOUTH)]:2d} tricks "
          f"| East: {table[(strain, Seat.EAST)]:2d} tricks "
          f"| West: {table[(strain, Seat.WEST)]:2d} tricks")
```

### 4.2 Calculating Double Dummy Par
Par calculates the exact optimal contract assuming perfect play by all four players:

```python
from bid.dds import DDSolver
from bid.eval_vs_dds import build_deals

deal = build_deals(1, seed=42)[0]
par_score, par_contracts = DDSolver.calculate_par(deal, vuln=0)

print("Par Score    :", par_score)
print("Par Contracts:", par_contracts)
```

---

## 5. Benchmarking & Self-Play CLI Commands

Once `libdds` is loaded in `bin/`, all evaluation and search tools will automatically take advantage of native speed:

```bash
# 1. Benchmark a system against Double Dummy Par across 100 boards
.venv/bin/python3 -m bid.eval_vs_dds --system system/improved_system.dsl --boards 100

# 2. Explain a board with Double Dummy tricks and Par regret
.venv/bin/python3 -m bid.explain_board --board 1

# 3. Run autonomous flywheel search with DDS scoring
.venv/bin/python3 -m bid.autoloop --tiers 8,24 --pool-cap 4 --sds-gate --max-minutes 5
```

---

## 6. Troubleshooting

| Issue | Cause | Fix |
| :--- | :--- | :--- |
| `DDS Library: None` | Binary missing from `bin/` | Copy `libdds.dylib` (macOS), `libdds.so` (Linux), or `dds.dll` into `bin/`. |
| `wrong architecture (x86_64 vs arm64)` | Mismatch between Python and compiled dylib | Check `file .venv/bin/python3` vs `file bin/libdds.dylib`. Recompile matching your CPU. |
| `library not loaded: @rpath/libomp.dylib` | OpenMP runtime missing on macOS | Run `brew install libomp`. |
| `CalcDDtablePBN failed rc=-4` | PBN string had fewer than 52 cards | Normal when solving partial hand states; engine automatically uses per-contract fallback. |
