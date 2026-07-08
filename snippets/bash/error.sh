command=./tmp.sh


if [[ -x $command ]]; then
  $command
else
  echo "error: -x $command failed" >&2
fi
