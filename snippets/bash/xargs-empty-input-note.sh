if [ -s files.txt ]; then
  xargs wc -l < files.txt
fi
