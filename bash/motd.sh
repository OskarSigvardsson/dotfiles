
# Have a cow say something clever when you start!

if which fortune > /dev/null 2> /dev/null
then
    if which cowsay > /dev/null 2> /dev/null
    then
        fortune -s | cowsay
    else
        fortune -s
    fi
fi
