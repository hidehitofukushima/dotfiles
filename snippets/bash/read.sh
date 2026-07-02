word=""
while [[ -z "$word" ]]; do
	echo -n "input word aho or baka: "
	read word
	case $word in 
		aho)
			echo "ahogayo"
			;;
		baka)
			echo "bakagayo"
			;;
		*)
			echo "bad input"
			word=""
			;;
	esac
done
