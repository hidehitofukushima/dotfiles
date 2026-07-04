awk 'BEGIN { FS="\t"; OFS="\t" } !seen[$1]++ { print }' file.tsv
