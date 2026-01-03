from __future__ import annotations

import argparse
import sys
from typing import Iterable

from datasets import load_dataset


def _read_ids_from_file(path: str) -> list[str]:
    ids: list[str] = []
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            s = line.strip()
            if not s or s.startswith("#"):
                continue
            ids.append(s)
    return ids


def _dedupe_preserve_order(xs: Iterable[str]) -> list[str]:
    seen = set()
    out: list[str] = []
    for x in xs:
        if x in seen:
            continue
        seen.add(x)
        out.append(x)
    return out


def main() -> int:
    ap = argparse.ArgumentParser(
        description=(
            "Extract problem_statement for specific instance_id rows from a given dataset"
        )
    )
    ap.add_argument(
        "--dataset",
        default="SWE-bench/SWE-bench_Multilingual",
        help="Hugging Face dataset name (default: SWE-bench/SWE-bench_Multilingual).",
    )
    ap.add_argument(
        "--split",
        default="test",
        help="Dataset split to read (default: test).",
    )
    ap.add_argument(
        "--ids-file",
        default=None,
        help="Optional path to a newline-delimited file of instance_ids (comments with # allowed).",
    )
    ap.add_argument(
        "ids",
        nargs="*",
        help="Optional instance_ids. Space-separated",
    )
    args = ap.parse_args()

    instance_ids: list[str]
    if args.ids_file:
        instance_ids = _read_ids_from_file(args.ids_file)
    elif args.ids:
        instance_ids = list(args.ids)
    else:
        ap.error("You must provide either --ids-file or --ids")

    instance_ids = _dedupe_preserve_order(instance_ids)
    wanted = set(instance_ids)

    # Stream so we don't have to download/materialize the whole split.
    ds = load_dataset(args.dataset, split=args.split, streaming=True)

    found: dict[str, str] = {}
    missing_problem_statement: set[str] = set()

    for row in ds:
        iid = row.get("instance_id")
        if iid not in wanted:
            continue

        ps = row.get("problem_statement")
        if ps is None:
            missing_problem_statement.add(iid)
            ps = ""

        # Normalize newlines a bit (keep content intact, but ensure it's str).
        ps = str(ps).rstrip("\n")
        found[iid] = ps

        if len(found) == len(wanted):
            break

    # Print in the exact order requested.
    # Output format:
    # [instance_id]
    # problem_statement
    # [instance_id]
    # problem_statement
    not_found = [iid for iid in instance_ids if iid not in found]

    out = sys.stdout

    for iid in instance_ids:
        if iid not in found:
            continue
        out.write(f"[{iid}]\n")
        out.write(found[iid] + "\n")

    # Send diagnostics to stderr
    if not_found or missing_problem_statement:
        err = sys.stderr
        if not_found:
            err.write(
                f"WARNING: {len(not_found)} instance_id(s) not found in {args.dataset} split={args.split}:\n"
            )
            for iid in not_found:
                err.write(f"  - {iid}\n")
        if missing_problem_statement:
            err.write(
                f"WARNING: {len(missing_problem_statement)} instance_id(s) found but missing 'problem_statement' field:\n"
            )
            for iid in sorted(missing_problem_statement):
                err.write(f"  - {iid}\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())