from argparse import ArgumentParser
from csv import DictReader
from json import dump
from pathlib import Path


parser = ArgumentParser()
parser.add_argument("--input", required=True)
parser.add_argument("--output", required=True)
args = parser.parse_args()

rows = list(DictReader(open(args.input)))
failed = [row for row in rows if not str(row["status"]).startswith("2")]
max_consecutive_failures = 0
current_failures = 0

for row in rows:
    if str(row["status"]).startswith("2"):
        current_failures = 0
    else:
        current_failures += 1
        max_consecutive_failures = max(max_consecutive_failures, current_failures)

summary = {
    "total_requests": len(rows),
    "failed_requests": len(failed),
    "failure_rate": (len(failed) / len(rows)) if rows else 0,
    "max_consecutive_failures": max_consecutive_failures,
}

Path(args.output).parent.mkdir(parents=True, exist_ok=True)
with open(args.output, "w") as file:
    dump(summary, file, indent=2)
    file.write("\n")
