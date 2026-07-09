#!/usr/bin/env bash
targetdir="$HOME/dotfiles/snippets/"
filecount=`find "$targetdir"   -type f -print | wc -l`
dircount=`find "$targetdir"   -type d -print | wc -l`
echo $filecount $dircount
dircount=`expr "$dircount" - 1`
echo "対象ディレクトリ= $targetdir"
echo "files= $filecount"
echo "directories= $dircount"
awk -F'\t' 'NR == 1 {
  for (i = 1; i <= NF; i++) {
    print i, $i
  }
}' input.tsv
# ============================================================
# header
# ============================================================
