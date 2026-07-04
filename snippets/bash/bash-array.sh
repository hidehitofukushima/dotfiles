set -euo pipefail

samples=(sample1 sample2 sample3)

for sample in "${samples[@]}"; do
  printf 'sample=%s\n' "$sample"
done
