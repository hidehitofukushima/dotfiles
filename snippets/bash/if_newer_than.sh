if [[ $file1 -nt $file2 ]]; then
 echo "[$file1]->newer, [$file2]->older"
else
 echo "[$file2]->newer, [$file1]->older"
fi
