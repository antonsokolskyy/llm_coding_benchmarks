#!/usr/bin/env bash
set -euo pipefail

command -v uv >/dev/null 2>&1 || { echo >&2 "Error: 'uv' is not installed. Please install it first."; exit 1; }
command -v git >/dev/null 2>&1 || { echo >&2 "Error: 'git' is not installed. Please install it first."; exit 1; }

SWEBENCH_REPO_URL="${SWEBENCH_REPO_URL:-https://github.com/SWE-bench/SWE-bench.git}"
SWEBENCH_DIR="${SWEBENCH_DIR:-SWE-bench}"
SWEBENCH_REF="${SWEBENCH_REF:-main}" # tag/branch/commit for reproducibility

uv venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate

uv pip install -U pip

if [[ ! -d "$SWEBENCH_DIR" ]]; then
  git clone "$SWEBENCH_REPO_URL" "$SWEBENCH_DIR"
fi

git -C "$SWEBENCH_DIR" fetch --all --tags
git -C "$SWEBENCH_DIR" checkout "$SWEBENCH_REF"

# Install SWE-bench from source (editable) per docs quickstart. (https://www.swebench.com/SWE-bench/guides/quickstart/)
uv pip install --editable "./${SWEBENCH_DIR}"

python -c "import swebench; print('swebench installed successfully')"

# Smoke check: harness entrypoint exists (docs show running it via -m). (https://www.swebench.com/SWE-bench/guides/quickstart/)
python -m swebench.harness.run_evaluation --help >/dev/null
