set -euo pipefail

while IFS=$'\t' read -r sample group path; do
  [ "$sample" = "sample" ] && continue
  printf 'sample=%s group=%s path=%s\n' "$sample" "$group" "$path"
done < metadata.tsv
