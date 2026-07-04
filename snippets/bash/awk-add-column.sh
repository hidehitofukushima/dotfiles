awk 'BEGIN { FS="\t"; OFS="\t" } NR == 1 { print $0, "log_value"; next } { print $0, log($3 + 1) }' file.tsv
