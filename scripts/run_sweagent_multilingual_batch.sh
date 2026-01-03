#!/usr/bin/env bash
set -euo pipefail

MODEL_NAME="${1:?Usage: $0 <MODEL_NAME> <INST_FILTER> <API_BASE> [MAX_INPUT_TOKENS] [OUT_DIR]}"
INST_FILTER="${2:?Usage: $0 <MODEL_NAME> <INST_FILTER> <API_BASE> [MAX_INPUT_TOKENS] [OUT_DIR]}"
API_BASE="${3:?Usage: $0 <MODEL_NAME> <INST_FILTER> <API_BASE> [MAX_INPUT_TOKENS] [OUT_DIR]}"
MAX_INPUT_TOKENS="${4:-}"
OUT_DIR="${5:-../results/sweagent/${MODEL_NAME}}"

# API configuration
: "${API_KEY:?Set API_KEY in your env}"

# Resolve paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SWE_AGENT_DIR="${ROOT_DIR}/SWE-agent"

DEFAULT_CONFIG="${SWE_AGENT_DIR}/config/default.yaml"
ML_CONFIG="${SWE_AGENT_DIR}/config/benchmarks/anthropic_filemap_multilingual.yaml"

# Validate files/dirs
if [[ ! -f "${DEFAULT_CONFIG}" ]]; then
  echo "Error: Default config not found at ${DEFAULT_CONFIG}" >&2
  exit 1
fi
if [[ ! -f "${ML_CONFIG}" ]]; then
  echo "Error: Multilingual config not found at ${ML_CONFIG}" >&2
  exit 1
fi

mkdir -p "${OUT_DIR}"

uv run sweagent run-batch \
  --config "${DEFAULT_CONFIG}" \
  --config "${ML_CONFIG}" \
  --output_dir "${OUT_DIR}" \
  --agent.model.name "${MODEL_NAME}" \
  --agent.model.api_base "${API_BASE}" \
  --agent.model.api_key "${API_KEY}" \
  --agent.model.per_instance_cost_limit 0 \
  --agent.model.total_cost_limit 0 \
  --agent.model.per_instance_call_limit 25 \
  ${MAX_INPUT_TOKENS:+--agent.model.max_input_tokens "$MAX_INPUT_TOKENS"} \
  --agent.model.temperature "0" \
  --instances.type "swe_bench" \
  --instances.subset "multilingual" \
  --instances.split "test" \
  --instances.filter "${INST_FILTER}"
