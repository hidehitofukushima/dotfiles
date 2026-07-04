find . -type f \
  ! -path '*/.git/*' \
  ! -path '*/node_modules/*' \
  -print0 | xargs -0 grep -n 'pattern'
