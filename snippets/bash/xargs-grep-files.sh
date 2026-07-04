find . -type f -name '*.txt' -print0 | xargs -0 grep -n 'pattern'
