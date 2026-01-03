#!/usr/bin/env bash
set -euo pipefail

MODEL_NAME="${1:?Usage: $0 <MODEL_NAME> <OUT_DIR> [BASE_URL]}"
OUT_DIR="${2:?Usage: $0 <MODEL_NAME> <OUT_DIR> [BASE_URL]}"
BASE_URL="${3:-https://openrouter.ai/api/v1}"

mkdir -p "$OUT_DIR"

: "${OPENROUTER_API_KEY:?Set OPENROUTER_API_KEY in your env}"
export OPENAI_API_KEY="$OPENROUTER_API_KEY"

uv run lm_eval \
  --model openai-chat-completions \
  --model_args "model=${MODEL_NAME},base_url=${BASE_URL}/chat/completions,num_concurrent=1,max_retries=5" \
  --tasks ifeval \
  --apply_chat_template \
  --fewshot_as_multiturn \
  --batch_size 1 \
  --seed 0 \
  --gen_kwargs "temperature=0" \
  --log_samples \
  --output_path "${OUT_DIR}"
