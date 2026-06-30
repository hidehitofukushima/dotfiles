# 置換結果を標準出力へ表示
sed 's/old/new/g' file.txt
# ファイルを直接書き換える（macOS）
sed -i '' 's/old/new/g' file.txt
# 2つのパターンに挟まれた範囲を抽出
sed -n '/BEGIN/,/END/p' file.txt
