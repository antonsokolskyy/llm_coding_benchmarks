#!/usr/bin/env bash
set -euo pipefail

MODEL_NAME="${1:?Usage: $0 <MODEL_NAME> <OUT_DIR> [BASE_URL]}"
OUT_DIR="${2:?Usage: $0 <MODEL_NAME> <OUT_DIR> [BASE_URL]}"
BASE_URL="${3:-http://127.0.0.1:1234/v1}"

mkdir -p "$OUT_DIR"

export OPENAI_API_KEY="${OPENAI_API_KEY:-lm-studio}"

uv run evalplus.evaluate \
  --backend openai \
  --base-url "$BASE_URL" \
  --model "$MODEL_NAME" \
  --dataset humaneval \
  --greedy \
  --root "$OUT_DIR"
