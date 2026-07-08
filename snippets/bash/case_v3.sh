for filename in *
do
  case $filename in
    *.htm | *.html)
      headname=${filename%.*}
      mv $filename $headname
      ;;
  esac
done
