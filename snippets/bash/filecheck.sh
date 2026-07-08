filecheck()
{
  if [[ ! -e $1 ]]; then
    echo "ERROOR: File $1 does not exist" >&2
    exit 1
  fi
}
