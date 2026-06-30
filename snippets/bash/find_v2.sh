find . \
  \( -path './.git' -o -path './node_modules' \) -prune -o \
  -type f -name '*.js' -print
