awk 'BEGIN { FS="\t"; OFS="\t" } { print $1, $3, $5 }' file.tsv
