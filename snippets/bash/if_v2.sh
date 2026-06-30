# [[ -e "$x" ]]   # x が存在する
# [[ -f "$x" ]]   # x が通常ファイル
# [[ -d "$x" ]]   # x がディレクトリ
# [[ -s "$x" ]]   # x が存在して空でない
# [[ -n "$x" ]]   # x という文字列が空でない
# [[ -z "$x" ]]   # x という文字列が空
# [[ "$a" -eq "$b" ]]  # equal
# [[ "$a" -ne "$b" ]]  # not equal
# [[ "$a" -lt "$b" ]]  # less than
# [[ "$a" -le "$b" ]]  # less than or equal
# [[ "$a" -gt "$b" ]]  # greater than
# [[ "$a" -ge "$b" ]]  # greater than or equal

if [[ -f "$file" ]]; then
	echo "普通のファイルです"
fi

if [[ -e "$path" ]]; then
	  echo "存在する"
fi

if [[ -d "$dir" ]]; then
	  echo "ディレクトリです"
fi


if [[ -s "$file" ]]; then
	  echo "空ではないファイルです"
	else
		  echo "存在しないか、空ファイルです"
fi
