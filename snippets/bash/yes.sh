for i in `yes "" | cat -n | head -n30 | awk "(NR % 5 == 0) && (NR >= 10) {print NR}"`; do
  echo "$i"
done
