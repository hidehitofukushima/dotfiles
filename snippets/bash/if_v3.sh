i=10
if [ $i -le 30 ]; then
	i=`expr $i + 5`
	echo $i
fi
