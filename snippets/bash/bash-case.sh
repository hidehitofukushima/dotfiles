set -euo pipefail

cmd="${1:-}"

case "$cmd" in
  run)
    echo 'run'
    ;;
  clean)
    echo 'clean'
    ;;
  *)
    echo "Usage: $0 {run|clean}" >&2
    exit 1
    ;;
esac
