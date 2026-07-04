awk 'BEGIN { FS="\t"; OFS="\t" } $2 == "PASS" { print }' file.tsv
