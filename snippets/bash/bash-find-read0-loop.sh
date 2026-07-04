set -euo pipefail

find . -type f -name '*.txt' -print0 |
  while IFS= read -r -d '' f; do
    printf 'file: %s\n' "$f"
  done
