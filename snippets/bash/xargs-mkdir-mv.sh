mkdir -p dest
find . -maxdepth 1 -type f -name '*.txt' -print0 | xargs -0 -I {} mv {} dest/
