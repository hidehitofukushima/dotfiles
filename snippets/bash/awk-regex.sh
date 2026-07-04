awk 'BEGIN { FS="\t"; OFS="\t" } $1 ~ /^chr([0-9]+|X|Y)$/ { print }' file.tsv
