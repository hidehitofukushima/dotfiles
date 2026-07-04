set -euo pipefail

stamp="$(date '+%Y%m%d_%H%M%S')"
outdir="result_$stamp"
mkdir -p "$outdir"
echo "$outdir"
