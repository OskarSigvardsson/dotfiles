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
source bash/bash-powerline/bash-powerline.sh

set PATH=$PATH:$HOME/.cargo/bin
