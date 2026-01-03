## lm-eval
```sh
bash scripts/setup_lmeval.sh
```

```sh
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash benchmarks/ifeval/run_lmstudio.sh "qwen3-coder-30b-a3b-instruct" "results/ifeval_lmstudio_${RUN_ID}" "http://localhost:1234/v1"
```

```sh
export OPENROUTER_API_KEY="YOUR_KEY"
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash benchmarks/ifeval/run_openrouter.sh "google/gemini-3-flash-preview" "results/ifeval_openrouter_${RUN_ID}"
```

## evalplus
```sh
bash scripts/setup_evalplus.sh
```

```sh
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash benchmarks/mbpp/run_lmstudio.sh "qwen3-coder-30b-a3b-instruct" "results/mbpp_lmstudio_${RUN_ID}" "http://localhost:1234/v1"
```

```sh
export OPENROUTER_API_KEY="YOUR_KEY"
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash benchmarks/mbpp/run_openrouter.sh "google/gemini-3-flash-preview" "results/mbpp_openrouter_${RUN_ID}"
```

```sh
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash benchmarks/humaneval/run_lmstudio.sh "qwen3-coder-30b-a3b-instruct" "results/humaneval_lmstudio_${RUN_ID}" "http://localhost:1234/v1"
```

```sh
export OPENROUTER_API_KEY="YOUR_KEY"
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash benchmarks/humaneval/run_openrouter.sh "google/gemini-3-flash-preview" "results/humaneval_openrouter_${RUN_ID}"
```

## SWE
### Picking instances by language
```sh
# For Multilingual (non-Python)
bash scripts/pick_by_lang.sh "SWE-bench/SWE-bench_Multilingual" "test" 10
```

```sh
# For SWE-bench Lite (Python)
bash scripts/pick_by_lang.sh "SWE-bench/SWE-bench_Lite" "test" 10
```

### Fetching instance descriptions
```sh
# For Multilingual (non-Python)
bash scripts/extract_instance_descriptions.sh babel__babel-16130 caddyserver__caddy-5761
```

```sh
# For SWE-bench Lite (Python)
bash scripts/extract_instance_descriptions.sh --dataset SWE-bench/SWE-bench_Lite django__django-11133 astropy__astropy-14365
```

### SWE-agent
#### Multilingual
```sh
bash scripts/setup_sweagent.sh
```

```sh
export API_KEY="unused" # if using local LM Studio
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash scripts/run_sweagent_multilingual_batch.sh \
  "openai/qwen3-coder-30b-a3b-instruct" \
  '^(jqlang__jq-2235|jqlang__jq-2658)$' \
  "http://localhost:1234/v1" \
  65536 \
  "results/sweagent_lmstudio_${RUN_ID}/qwen3-coder-30b-a3b-instruct"
```

```sh
export API_KEY="YOUR_KEY"
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash scripts/run_sweagent_multilingual_batch.sh \
  "openrouter/google/gemini-3-flash-preview" \
  '^(jqlang__jq-2235|jqlang__jq-2658)$' \
  "https://openrouter.ai/api/v1" \
  1048576 \
  "results/sweagent_openrouter_${RUN_ID}/gemini-3-flash-preview"
```

#### Lite (Python)
```sh
export API_KEY="unused" # if using local LM Studio
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash scripts/run_sweagent_batch.sh \
  "openai/qwen3-coder-30b-a3b-instruct" \
  '^(astropy__astropy-12907|astropy__astropy-14182)$' \
  "http://localhost:1234/v1" \
  65536 \
  "results/sweagent_lmstudio_${RUN_ID}/qwen3-coder-30b-a3b-instruct"
```

```sh
export API_KEY="YOUR_KEY"
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash scripts/run_sweagent_batch.sh \
  "openrouter/google/gemini-3-flash-preview" \
  '^(astropy__astropy-12907|astropy__astropy-14182)$' \
  "https://openrouter.ai/api/v1" \
  1048576 \
  "results/sweagent_openrouter_${RUN_ID}/gemini-3-flash-preview"
```

### SWE-bench
```sh
bash scripts/setup_swebench.sh
```

#### Lite
```sh
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash benchmarks/swebench/run_lite.sh \
  "path/to/predictions.jsonl" \
  2 \
  "results/swebench_lite_${RUN_ID}"
```

#### Multilingual
```sh
RUN_ID="$(date -u +%Y%m%d_%H%M%SZ)"
bash benchmarks/swebench/run_multilingual.sh \
  "path/to/predictions.jsonl" \
  2 \
  "results/swebench_multilingual_${RUN_ID}"
```
