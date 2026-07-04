awk 'BEGIN { FS="\t"; OFS="\t" } NR > 1 { count[$1]++ } END { for (k in count) print k, count[k] }' file.tsv | sort
