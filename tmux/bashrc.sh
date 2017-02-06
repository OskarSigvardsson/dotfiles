#if which tmux > /dev/null 2> /dev/null
#then
#    if [ -z "$TMUX" ]
#    then
#        tmux attach || tmux new-session
#    fi
#fi
