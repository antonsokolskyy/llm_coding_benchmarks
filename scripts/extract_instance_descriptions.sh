#!/usr/bin/env bash
set -euo pipefail

# This script extracts problem statements for specified instance IDs from a SWE-bench dataset.
# It works for both multilingual and normal SWE-bench datasets.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="${SCRIPT_DIR}/_extract_instance_descriptions.py"


uv run python "$PYTHON_SCRIPT" "$@"
