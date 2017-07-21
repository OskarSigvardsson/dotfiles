function _update_ps1() {
    PS1="$($DOTFILES/bash/bash_prompt.py $?)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
