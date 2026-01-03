#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash benchmarks/swebench/run_lite.sh <PREDICTIONS_PATH> <MAX_WORKERS> <RESULTS_DIR>
#
# Notes:
# - PREDICTIONS_PATH can be a path to a .jsonl file OR the special value "gold".

PREDICTIONS_PATH="${1:?Usage: $0 <PREDICTIONS_PATH> <MAX_WORKERS> <RESULTS_DIR>}"
MAX_WORKERS="${2:?Usage: $0 <PREDICTIONS_PATH> <MAX_WORKERS> <RESULTS_DIR>}"
RESULTS_DIR="${3:?Usage: $0 <PREDICTIONS_PATH> <MAX_WORKERS> <RESULTS_DIR>}"

# The harness requires a run_id; derive one deterministically from the results dir.
RUN_ID="$(basename "${RESULTS_DIR}")"

mkdir -p "${RESULTS_DIR}"

# If PREDICTIONS_PATH is not "gold", make it absolute because we will cd into RESULTS_DIR
if [[ "${PREDICTIONS_PATH}" != "gold" ]]; then
  PREDICTIONS_PATH="$(realpath "${PREDICTIONS_PATH}")"
fi

cd "${RESULTS_DIR}"

uv run python -m swebench.harness.run_evaluation \
  --dataset_name "SWE-bench/SWE-bench_Lite" \
  --split "test" \
  --predictions_path "${PREDICTIONS_PATH}" \
  --max_workers "${MAX_WORKERS}" \
  --run_id "${RUN_ID}"
