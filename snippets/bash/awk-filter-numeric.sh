awk 'BEGIN { FS="\t"; OFS="\t" } NR == 1 || ($5 + 0) >= 10 { print }' file.tsv
