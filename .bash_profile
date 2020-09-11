if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi

# Aliases
alias cat="bat --plain"
alias less="bat --plain"
alias ls="exa"
alias tree="exa --tree"
alias rg="rg -p"
alias rd=". ranger"

# Compatible with ranger 1.4.2 through 1.7.*
#
# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.
# 
# On OS X 10 or later, replace `usr/bin/ranger` with `/usr/local/bin/ranger`.

# function rd {
#     tempfile="$(mktemp -t tmp.XXXXXX)"
#     ranger --choosedir="$tempfile" "${@:-$(pwd)}"
#     test -f "$tempfile" &&
#     if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
#         cd -- "$(cat "$tempfile")"
#     fi
#     rm -f -- "$tempfile"
# }


function _update_ps1() {
	# My own fancy prompt (should probably rewrite one of these days...)
    # PS1="$($HOME/.config/bash_prompt.py $?)"

	# actually, lets try something a little bit more minimalistic for now...
	if [[ $? == 0 ]]; then
		export PS1=" \[\e[00;36;1m\]λ \W > \[\e[0m\]"
	else
		export PS1=" \[\e[00;31;1m\]λ \W > \[\e[0m\]"
	fi 
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1"
fi

export PS1=" \[\e[00;36;1m\]λ \W \[\e[0m\]"

alias dfs='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

if which fortune > /dev/null 2> /dev/null
then
    if which cowsay > /dev/null 2> /dev/null
    then
        fortune -s | cowsay
    else
        fortune -s
    fi
fi

export PATH="$HOME/.cargo/bin:$PATH"
