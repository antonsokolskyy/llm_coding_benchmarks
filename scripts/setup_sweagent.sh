#!/usr/bin/env bash
set -euo pipefail

command -v uv >/dev/null 2>&1 || { echo >&2 "Error: 'uv' is not installed. Please install it first."; exit 1; }
command -v git >/dev/null 2>&1 || { echo >&2 "Error: 'git' is not installed. Please install it first."; exit 1; }

SWE_AGENT_REPO_URL="${SWE_AGENT_REPO_URL:-https://github.com/SWE-agent/SWE-agent.git}"
SWE_AGENT_DIR="${SWE_AGENT_DIR:-SWE-agent}"
SWE_AGENT_REF="${SWE_AGENT_REF:-main}" # tag/branch/commit for reproducibility

uv venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate

uv pip install -U pip

if [[ ! -d "$SWE_AGENT_DIR" ]]; then
  git clone "$SWE_AGENT_REPO_URL" "$SWE_AGENT_DIR"
fi

git -C "$SWE_AGENT_DIR" fetch --all --tags
git -C "$SWE_AGENT_DIR" checkout "$SWE_AGENT_REF"

# Install from source (editable) per SWE-agent docs. (https://swe-agent.com/latest/installation/source)
uv pip install --editable "./${SWE_AGENT_DIR}"

python -c "import sweagent; print('sweagent installed successfully')"

# CLI smoke check (docs mention sweagent --help; python -m sweagent as fallback). (https://swe-agent.com/latest/installation/source)
if command -v sweagent >/dev/null 2>&1; then
  sweagent --help >/dev/null
else
  python -m sweagent --help >/dev/null
fi
