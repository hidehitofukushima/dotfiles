
hoge() {
	echo "this is a sample function"
	echo $1
	echo $2
}

find .  -name '*.txt' 
awk -F'\t' 'NR == 1 {
  for (i = 1; i <= NF; i++) {
    print i, $i
  }
}' input.tsv
module use /usr/local/package/modulefiles
module load hoge
eval "$(~/miniconda3/bin/conda shell.bash hook)"
export R_LIBS_USER=/home/ny1fh/R/hoge
