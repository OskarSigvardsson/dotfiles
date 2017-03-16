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
#source bash/bash-powerline/bash-powerline.sh

function _update_ps1() {
    PS1="$(~/.bash_prompt.py $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

set PATH=$PATH:$HOME/.cargo/bin
