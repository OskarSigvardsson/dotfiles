set -o vi
export EDITOR=vim
PATH=$PATH:$DOTFILES/bin

ssh-add -A

if which fortune > /dev/null 2> /dev/null
then
    if which cowsay > /dev/null 2> /dev/null
    then
        fortune -s | cowsay
    else
        fortune -s
    fi
fi

source bash/aliases.sh
source bash/bash_automatic_cd.sh
source bash/bash_fzf_cd.sh

function _update_ps1() {
    PS1="$($DOTFILES/bash/bash_prompt.py $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

set PATH=$PATH:$HOME/.cargo/bin

