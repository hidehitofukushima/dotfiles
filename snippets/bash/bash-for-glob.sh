set -euo pipefail

shopt -s nullglob

for f in *.txt; do
  printf 'file: %s\n' "$f"
done
