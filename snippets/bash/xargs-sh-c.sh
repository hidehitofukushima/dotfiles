find . -type f -name '*.txt' -print0 |
  xargs -0 -I {} sh -c 'echo "file=$1"; wc -l "$1"' sh {}
