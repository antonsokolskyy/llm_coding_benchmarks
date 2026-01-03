#!/usr/bin/env python3
#
# Usage:
#   uv run pick_multilingual_by_lang.py
#   uv run pick_multilingual_by_lang.py --split test
#   uv run pick_multilingual_by_lang.py --split train
#   uv run pick_multilingual_by_lang.py --max-per-lang 2000   # optional truncation
#
# Output format:
#   Ruby: id1, id2, ...
#   Rust: ...
#   ...
#   Undefined: ...

import argparse
import re
from collections import defaultdict
from datasets import load_dataset

# Parse changed file paths from unified diff
DIFF_FILE_RE = re.compile(r"^\+\+\+ b/(.+)$")

# Extensions we treat as "definitely this language"
EXT_TO_LANG = {
    # C / C++
    ".c": "C",
    ".cpp": "C++", ".cc": "C++", ".cxx": "C++", ".c++": "C++",
    ".hpp": "C++", ".hh": "C++", ".hxx": "C++",
    ".ipp": "C++", ".inl": "C++", ".tpp": "C++",

    # Go / Java / Rust
    ".go": "Go",
    ".java": "Java",
    ".rs": "Rust",

    # JavaScript / TypeScript
    ".js": "JavaScript", ".jsx": "JavaScript", ".mjs": "JavaScript", ".cjs": "JavaScript",
    ".ts": "TypeScript", ".tsx": "TypeScript", ".mts": "TypeScript", ".cts": "TypeScript",

    # PHP / Ruby
    ".php": "PHP",
    ".rb": "Ruby",

    # Python
    ".py": "Python",
}

# Ambiguous extensions => never "100% sure"
AMBIGUOUS_EXT = {
    ".h",  # could be C or C++
}

# Noise we ignore when deciding language
IGNORE_EXT = {
    ".md", ".rst", ".txt",
    ".png", ".jpg", ".jpeg", ".gif", ".svg", ".ico",
    ".yml", ".yaml", ".json", ".toml", ".ini", ".cfg",
    ".xml", ".properties",
    ".lock", ".sum",
}

LANG_ORDER = ["C", "C++", "Go", "Java", "JavaScript", "TypeScript", "PHP", "Ruby", "Rust", "Python", "Undefined"]

def infer_language_sure(patch: str) -> str:
    """
    Returns a language if we are SURE (based on file extensions in the patch):
      - all recognized (non-ignored) changed code files map to exactly one language
      - and no ambiguous extensions are present (e.g., .h)
    Otherwise returns "Undefined".
    """
    langs = set()
    saw_any_relevant = False

    for line in patch.splitlines():
        m = DIFF_FILE_RE.match(line)
        if not m:
            continue

        path = m.group(1)
        if path == "dev/null":
            continue

        dot = path.rfind(".")
        if dot == -1:
            # no extension -> don't mark sure
            saw_any_relevant = True
            continue

        ext = path[dot:].lower()
        if ext in IGNORE_EXT:
            continue

        saw_any_relevant = True

        if ext in AMBIGUOUS_EXT:
            return "Undefined"

        lang = EXT_TO_LANG.get(ext)
        if lang is None:
            # some other extension => we can't be sure
            return "Undefined"

        langs.add(lang)
        if len(langs) > 1:
            return "Undefined"

    if not saw_any_relevant:
        return "Undefined"

    return next(iter(langs)) if len(langs) == 1 else "Undefined"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dataset", default="SWE-bench/SWE-bench_Multilingual", help="Dataset name on HuggingFace")
    ap.add_argument("--split", default="test", choices=["train", "test", "dev"])
    ap.add_argument("--max-per-lang", type=int, default=0, help="If >0, truncate each language list to this many IDs.")
    args = ap.parse_args()

    ds = load_dataset(args.dataset, split=args.split)

    groups = defaultdict(list)
    for ex in ds:
        lang = infer_language_sure(ex.get("patch", "") or "")
        groups[lang].append(ex["instance_id"])

    # Deterministic ordering inside each group
    for k in list(groups.keys()):
        groups[k].sort()

    # Print in requested compact format
    for lang in LANG_ORDER:
        ids = groups.get(lang, [])
        if args.max_per_lang and args.max_per_lang > 0:
            ids = ids[: args.max_per_lang]
        joined = ", ".join(ids)
        print(f"{lang}: {joined}")

if __name__ == "__main__":
    main()
