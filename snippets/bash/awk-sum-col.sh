awk 'BEGIN { FS="\t" } NR > 1 { sum += $3 } END { print sum }' file.tsv
