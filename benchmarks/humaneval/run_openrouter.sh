#!/usr/bin/env bash
set -euo pipefail

MODEL_NAME="${1:?Usage: $0 <MODEL_NAME> <OUT_DIR> [BASE_URL]}"
OUT_DIR="${2:?Usage: $0 <MODEL_NAME> <OUT_DIR> [BASE_URL]}"
BASE_URL="${3:-https://openrouter.ai/api/v1}"

mkdir -p "$OUT_DIR"

: "${OPENROUTER_API_KEY:?Set OPENROUTER_API_KEY in your env}"
export OPENAI_API_KEY="$OPENROUTER_API_KEY"

uv run evalplus.evaluate \
  --backend openai \
  --base-url "$BASE_URL" \
  --model "$MODEL_NAME" \
  --dataset humaneval \
  --greedy \
  --root "$OUT_DIR"
