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

[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

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
export BASH_SILENCE_DEPRECATION_WARNING=1
