set -euo pipefail

input=""
outdir="out"
threads=1

while getopts ':i:o:t:' opt; do
  case "$opt" in
    i) input="$OPTARG" ;;
    o) outdir="$OPTARG" ;;
    t) threads="$OPTARG" ;;
    *) echo "Usage: $0 -i input [-o outdir] [-t threads]" >&2; exit 1 ;;
  esac
done

[ -n "$input" ] || { echo 'missing -i input' >&2; exit 1; }
mkdir -p "$outdir"
printf 'input=%s outdir=%s threads=%s\n' "$input" "$outdir" "$threads"
