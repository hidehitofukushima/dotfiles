set -euo pipefail

f="/path/to/sample.fastq.gz"

echo "dirname:  ${f%/*}"
echo "basename: ${f##*/}"
echo "remove .gz: ${f%.gz}"

bn="${f##*/}"
echo "basename variable: $bn"
echo "remove shortest suffix: ${bn%.*}"
echo "remove longest suffix:  ${bn%%.*}"
