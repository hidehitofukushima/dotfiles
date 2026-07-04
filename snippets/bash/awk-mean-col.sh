awk 'BEGIN { FS="\t" } NR > 1 { sum += $3; n++ } END { if (n > 0) print sum / n }' file.tsv
