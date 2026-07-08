for i in 1 2 3 4 5
do
  echo $i
  uptime >> uptime.log
  sleep 2
done
