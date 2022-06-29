export PATH="$HOME/.cargo/bin:$PATH"

alias cat="bat --plain"
alias less="bat --plain"
alias ls="exa"
alias tree="exa --tree"
alias rg="rg -p"
alias rd=". ranger"
alias d='cd $(fd --type directory | fzf)'
alias lgr='ledger -y "%Y-%m-%d" -f "$HOME/Dropbox (Personal)/Ledger/ledger.ledger"'

PROMPT='%B%F{14} λ %c %(?.%F{14}.%F{9})❯ %f%b'

alias dfs='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

HISTFILE=$HOME/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_REDUCE_BLANKS
setopt HIST_FIND_NO_DUPS

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ $(uname) == "Darwin" ]]; then
	em()
	{
		args=""

		if [[ -t 0 ]]; then
			if [[ "$#" -gt "0" ]]; then
				emacsclient -n "$1"
			fi
		else
			TMP="$(mktemp /tmp/emacsstdin-XXX)"
			cat >$TMP
			emacsclient --eval '(let ((b (generate-new-buffer "*stdin*"))) (switch-to-buffer b) (insert-file-contents "'${TMP}'") (delete-file "'${TMP}'"))'
		fi

		emacsclient --eval "(x-focus-frame nil)" > /dev/null
	}

	export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
	source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

	eval "$(direnv hook zsh)"
fi


if which fortune > /dev/null 2> /dev/null
then
    if which cowsay > /dev/null 2> /dev/null
    then
        fortune -s | cowsay
    else
        fortune -s
    fi
fi
