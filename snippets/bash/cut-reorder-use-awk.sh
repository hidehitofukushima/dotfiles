awk 'BEGIN { FS="\t"; OFS="\t" } { print $3, $1, $2 }' file.tsv
