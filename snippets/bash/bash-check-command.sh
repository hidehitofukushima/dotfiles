set -euo pipefail

for cmd in awk sed grep cut xargs; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "missing command: $cmd" >&2
    exit 1
  fi
done
