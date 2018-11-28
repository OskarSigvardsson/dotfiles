
DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function readlinks {(
  set -o errexit -o nounset
  declare n=0 limit=1024 link="$1"

  # If it's a directory, just skip all this.
  if cd "$link" 2>/dev/null
  then
    pwd -P "$link"
    return 0
  fi

  # Resolve until we are out of links (or recurse too deep).
  while [[ -L $link ]] && [[ $n -lt $limit ]]
  do
    cd "$(dirname -- "$link")"
    n=$((n + 1))
    link="$(readlink -- "${link##*/}")"
  done
  cd "$(dirname -- "$link")"

  if [[ $n -ge $limit ]]
  then
    echo "Recursion limit ($limit) exceeded." >&2
    return 2
  fi

  printf '%s/%s\n' "$(pwd -P)" "${link##*/}"
)}

function dotfile {
	echo  "$DOTFILES/$1"
	readlinks "$DOTFILES/$1"
	readlinks "$DOTFILES/$2"
}


dotfile vim/vimrc.home ~/.vimrc
