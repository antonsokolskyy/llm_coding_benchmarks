#!/usr/bin/env bash
set -euo pipefail

# This script picks instance IDs from a SWE-bench dataset, grouped by language.
# It works for both multilingual and normal SWE-bench datasets by looking at file extensions in the patch.

DATASET="${1:-SWE-bench/SWE-bench_Multilingual}"
SPLIT="${2:-test}"
MAX_PER_LANG="${3:-0}"

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

uv run "${SCRIPT_DIR}/_pick_instances_by_lang.py" \
  --dataset "${DATASET}" \
  --split "${SPLIT}" \
  --max-per-lang "${MAX_PER_LANG}"
