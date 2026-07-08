(cd $dir1; find . -name '*.txt' -maxdepth 1 -type f -print | sort) > tmpfile1.txt
(cd $dir2; find . -name '*.txt' -maxdepth 1 -type f -print | sort) > tmpfile2.txt
comm -12 tmpfile1.txt tmpfile2.txt
