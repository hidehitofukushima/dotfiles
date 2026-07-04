awk 'match($0, /sample=[^[:space:]]+/) { s = substr($0, RSTART, RLENGTH); sub(/^sample=/, "", s); print s }' file.txt
