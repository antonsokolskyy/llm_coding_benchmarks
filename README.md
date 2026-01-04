# LLM Coding Benchmarks

This repository contains benchmarks for coding and instruction-following tasks. It includes tests for local models via LM Studio and cloud models via OpenRouter.

---

## 🛠 Benchmarks

### 1. IFEval
**Instruction-Following Evaluation for Large Language Models**.
- **What it does**: Evaluates the model's ability to follow "verifiable instructions" (e.g., "no capital letters", "format as JSON", "at least 400 words").
- **How it works**: Uses ~25 instruction types implemented as Python scripts to verify if the output follows the prompt.
- **Why it is useful**: It provides an objective measure of how well a model follows formatting and structural constraints.
- **Scores**: 
  - `prompt_level_strict_acc`: 1 if all instructions in a prompt are met, otherwise 0.
  - `inst_level_strict_acc`: Percentage of individual instructions followed across the entire dataset.
  - `prompt_level_loose_acc`: Similar to strict, but allows minor deviations (e.g. casing) if the instruction logic allows.
  - `inst_level_loose_acc`: Instruction-level accuracy using loose criteria.

### 2. EvalPlus (HumanEval+ and MBPP+)
**Rigorous evaluation of LLMs for code generation.**
- **What it does**: Enhances the original HumanEval and MBPP benchmarks with significantly more test cases.
- **How it works**: Uses an automated test generation framework. It generates 80x more tests for HumanEval and 35x more for MBPP by mutating LLM-generated seed inputs and filtering via program contracts and ground-truth implementations.
- **Why it is useful**: It catches "wrong-but-passing" code that original benchmarks miss. The "Plus" score provides a more accurate measure of functional correctness. **Note**: EvalPlus is a Python-only benchmark.
- **Scores**: 
  - `pass@1`: Percentage of tasks where the first generated solution passes all tests (using greedy decoding).
  - `Base`: Performance on original tests. 
  - `Plus`: Performance on augmented EvalPlus tests.

### 3. SWE-bench & SWE-agent
**Evaluating LLMs on real-world GitHub issues.**
- **SWE-agent**: An agent-computer interface (ACI) that allows an LLM to browse code, run shell commands, and edit files. It is used to generate a `.patch` file trying to fix an issue.
- **SWE-bench**: A benchmark of real GitHub issues. It takes the model's patch and evaluates it in a Docker environment by running the repository's test suite.
- **How it works**: A task is solved if the patch passes "fail-to-pass" (F2P) tests (the bug fix) and "pass-to-pass" (P2P) tests (no regressions).
- **Why it is useful**: It tests repository-level reasoning, bug localization, and functional fix generation.
- **Score Format**: `Resolved / Scheduled (Submitted)`.
  - *Example*: `10 / 20 (15)` means 20 tasks were scheduled, the model has submitted 15 non-empty results before hitting a budget/call limit, and 10 were resolved correctly.
- **Dataset**:
  - **Multilingual**: We use SWE-bench Multilingual to test models on languages other than Python (as EvalPlus is Python-only). We use a subset of 20 instances (10 Ruby, 10 JavaScript).
    - **Ruby IDs**: `faker-ruby__faker-2705`, `faker-ruby__faker-2970`, `fastlane__fastlane-19207`, `fastlane__fastlane-19304`, `fastlane__fastlane-19765`, `fastlane__fastlane-20642`, `fastlane__fastlane-20958`, `fastlane__fastlane-20975`, `fastlane__fastlane-21857`, `fluent__fluentd-3328`
    - **JS IDs**: `axios__axios-4731`, `axios__axios-4738`, `axios__axios-5316`, `axios__axios-5892`, `axios__axios-6539`, `babel__babel-13928`, `immutable-js__immutable-js-2005`, `immutable-js__immutable-js-2006`, `mrdoob__three.js-25687`, `mrdoob__three.js-26589`
  - **Lite**: We use a subset of 10 instances of SWE-bench Lite dataset to test models on Python issues.
    - **Python IDs**: `astropy__astropy-12907`, `astropy__astropy-14182`, `astropy__astropy-14365`, `astropy__astropy-14995`, `astropy__astropy-6938`, `astropy__astropy-7746`, `django__django-10914`, `django__django-10924`, `django__django-11001`, `django__django-11019`

---

## 📈 Leaderboards

### 1. IFEval
#### Local Models (LM Studio)
| Model | Quant | Context | Prompt Strict | Prompt Loose | Inst Strict | Inst Loose |
| :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| devstral-small-2-24b-instruct-2512 | `Q4_K_XL` | 65536 | 71.0% | 77.3% | 80.0% | 84.4% |
| gpt-oss-20b | `MXFP4` | 65536 | 68.2% | 69.9% | 68.9% | 70.4% |
| qwen3-coder-30b-a3b-instruct | `Q4_K_XL` | 65536 | 78.4% | 82.6% | 85.1% | 88.0% |

#### Cloud Models (OpenRouter)
| Model | Context | Run Cost | Prompt Strict | Prompt Loose | Inst Strict | Inst Loose |
| :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| anthropic/claude-sonnet-4.5  | 1000000 | $3.177 | 86.9% | 90.0% | 91.0% | 93.2% |
| deepseek/deepseek-v3.2 | 163840 | $0.129 | 85.0% | 88.7% | 89.3% | 91.8% |
| google/gemini-3-flash-preview | 1048576 | $0.528 | 91.1% | 92.6% | 93.9% | 95.1% |
| openai/gpt-5.1-codex-mini | 400000 | $0.528 | 80.0% | 81.5% | 79.9% | 80.8% |
| x-ai/grok-code-fast-1 | 256000 | $1.366 | 84.5% | 88.9% | 89.3% | 92.2% |

### 2. EvalPlus (HumanEval & MBPP)
#### Local Models (LM Studio)
| Model | Quant | Context | HumanEval | HumanEval+ | MBPP | MBPP+ |
| :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| devstral-small-2-24b-instruct-2512 | `Q4_K_XL` | 65536 | 83.5% | 79.3% | 76.5% | 65.6% |
| gpt-oss-20b | `MXFP4` | 65536 | 13.4% | 13.4% | 30.4% | 28.0% |
| qwen3-coder-30b-a3b-instruct | `Q4_K_XL` | 65536 | 92.1% | 89.0% | 83.9% | 71.2% |

#### Cloud Models (OpenRouter)
| Model | Context | Run Cost | HumanEval | HumanEval+ | MBPP | MBPP+ |
| :--- | :--- | :--- | :---: | :---: | :---: | :---: |
| anthropic/claude-sonnet-4.5 | 1000000 | $3.475 | 96.3% | 92.7% | 93.9% | 81.2% |
| deepseek/deepseek-v3.2 | 163840 | $0.168 | 90.2% | 86.0% | 88.1% | 72.0% |
| google/gemini-3-flash-preview | 1048576 | $0.564 | 98.2% | 94.5% | 94.2% | 81.0% |
| openai/gpt-5.1-codex-mini | 400000 | $0.358 | 87.2% | 86.0% | 88.1% | 74.6% |
| x-ai/grok-code-fast-1 | 256000 | $1.406 | 94.5% | 90.9% | 95.2% | 78.8% |

### 3. SWE-bench Multilingual
#### Local Models (LM Studio)
| Model | Quant | Context | Resolved / Scheduled (Submitted) |
| :--- | :--- | :--- | :--- |
| devstral-small-2-24b-instruct-2512 | `Q4_K_XL` | 65536 | 6 / 20 (19) |
| gpt-oss-20b | `MXFP4` | 65536 | 0 / 20 (0) |
| qwen3-coder-30b-a3b-instruct | `Q4_K_XL` | 65536 | 9 / 20 (20) |

#### Cloud Models (OpenRouter)
| Model | Context | Run Cost | Resolved / Scheduled (Submitted) |
| :--- | :--- | :--- | :--- |
| anthropic/claude-sonnet-4.5 | 1000000 | $8.461 | 5 / 20 (20) |
| deepseek/deepseek-v3.2 | 163840 | $2.739 | 1 / 20 (16) |
| google/gemini-3-flash-preview | 1048576 | $2.115 | 5 / 20 (16) |
| openai/gpt-5.1-codex-mini | 400000 | $1.675 | 5 / 20 (14) |
| x-ai/grok-code-fast-1 | 256000 | $10.30 | 2 / 20 (5) |

### SWE-bench Lite
#### Local Models (LM Studio)
| Model | Quant | Context | Resolved / Scheduled (Submitted) |
| :--- | :--- | :--- | :--- |
| devstral-small-2-24b-instruct-2512 | `Q4_K_XL` | 65536 | 3 / 10 (10) |
| gpt-oss-20b | `MXFP4` | 65536 | 0 / 10 (0) |
| qwen3-coder-30b-a3b-instruct | `Q4_K_XL` | 65536 | 4 / 10 (10) |

#### Cloud Models (OpenRouter)
| Model | Context | Run Cost | Resolved / Scheduled (Submitted) |
| :--- | :--- | :--- | :--- |
| anthropic/claude-sonnet-4.5 | 1000000 | $3.191 | 5 / 10 (9) |
| deepseek/deepseek-v3.2 | 163840 | $0.811 | 0 / 10 (9) |
| google/gemini-3-flash-preview | 1048576 | $0.685 | 5 / 10 (10) |
| openai/gpt-5.1-codex-mini | 400000 | $0.436 | 4 / 10 (10) |
| x-ai/grok-code-fast-1 | 256000 | $8.615 | 4 / 10 (10) |

---

## 🚀 Execution Workflow

### Step 1: IFEval
1. Setup: `bash scripts/setup_lmeval.sh`
2. Run Local: `bash benchmarks/ifeval/run_lmstudio.sh ...`
3. Run Cloud: `bash benchmarks/ifeval/run_openrouter.sh ...`

### Step 2: EvalPlus (HumanEval/MBPP)
1. Setup: `bash scripts/setup_evalplus.sh`
2. Run Local: `bash benchmarks/humaneval/run_lmstudio.sh ...`
3. Run Cloud: `bash benchmarks/humaneval/run_openrouter.sh ...`

### Step 3: SWE-agent & SWE-bench
1. Setup Agent: `bash scripts/setup_sweagent.sh`
2. Run Agent (Generate Patches): `bash scripts/run_sweagent_batch.sh ...`
3. Setup Bench: `bash scripts/setup_swebench.sh`
4. Run Bench (Evaluate Patches): `bash benchmarks/swebench/run_multilingual.sh ...`

*Refer to **[command_examples.md](command_examples.md)** for detailed parameters.*

---

## 🛡 Methodology
- **Greedy Decoding**: All benchmarks are run with `temperature=0`.
- **Local Models**: Only models that support tool calling (via LM Studio) were tested.
- **Cloud Model Budget**: All cloud models were given a budget of $10 per benchmark. For SWE-bench, only **Grok** hit the budget limit.
- **SWE-agent Call Limit**: For SWE-bench evaluations, all models were restricted to a maximum of 25 calls per instance.
