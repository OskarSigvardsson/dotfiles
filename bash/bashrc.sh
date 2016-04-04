if which fortune > /dev/null
then
    if which cowsay > /dev/null
    then
        fortune | cowsay
    else
        fortune
    fi
fi
