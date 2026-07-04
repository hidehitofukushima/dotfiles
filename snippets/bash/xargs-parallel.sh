cat samples.txt | xargs -n 1 -P 4 sh -c 'echo "processing $1"' sh
