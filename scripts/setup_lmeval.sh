#!/usr/bin/env bash
set -euo pipefail

command -v uv >/dev/null 2>&1 || { echo >&2 "Error: 'uv' is not installed. Please install it first."; exit 1; }

LMEVAL_VER="${LMEVAL_VER:-0.4.9.2}"

uv venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate

uv pip install -U pip
uv pip install "lm-eval[api,ifeval]==${LMEVAL_VER}"

python -c "import lm_eval; print('lm-eval installed successfully')"
lm_eval --help >/dev/null
