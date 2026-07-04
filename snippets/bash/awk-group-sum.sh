awk 'BEGIN { FS="\t"; OFS="\t" } NR > 1 { sum[$1] += $3 } END { for (k in sum) print k, sum[k] }' file.tsv | sort
