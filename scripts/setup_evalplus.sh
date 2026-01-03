#!/usr/bin/env bash
set -euo pipefail

command -v uv >/dev/null 2>&1 || { echo >&2 "Error: 'uv' is not installed. Please install it first."; exit 1; }

EVALPLUS_VER="${EVALPLUS_VER:-0.3.1}"

uv venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate

uv pip install -U pip
uv pip install "evalplus==${EVALPLUS_VER}"

python -c "import evalplus; print(f'evalplus {evalplus.__version__} installed successfully')"
evalplus.evaluate --help >/dev/null
