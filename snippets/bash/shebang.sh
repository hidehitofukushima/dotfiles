#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./script.sh input.txt output.txt

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <input> <output>" >&2
  exit 1
fi

input="$1"
output="$2"
