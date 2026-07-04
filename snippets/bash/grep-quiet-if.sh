if grep -q 'PASS' result.txt; then
  echo 'PASS found'
else
  echo 'PASS not found'
fi
