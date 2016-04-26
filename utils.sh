BLACK="$(tput setaf 0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"
MAGENTA="$(tput setaf 5)"
CYAN="$(tput setaf 6)"
WHITE="$(tput setaf 7)"
RESET="$(tput sgr0)"

if [[ ! $ECHO_LEVEL =~ ^\d+$ ]]
then
    ECHO_LEVEL=1
fi

function increase_level {
    ECHO_LEVEL=$((ECHO_LEVEL+1))
}

function decrease_level {
    ECHO_LEVEL=$((ECHO_LEVEL-1))
}

function level_echo {
    level_string "$1"
    echo $string
}

function level_string {
    prefix=""

    for i in $(seq 1 $ECHO_LEVEL)
    do
        prefix="-$prefix"
    done

    case $ECHO_LEVEL in
        1) color=$BLUE;;
        2) color=$GREEN;;
        3) color=$YELLOW;;
        4) color=$RED;;
        5) color=$CYAN;;
        6) color=$MAGENTA;;
        7) color=$WHITE;;
        8) color=$BLACK;;
    esac
    string="${color}$prefix> $1${RESET}"
}

function level_prompt {
    prompt=""

    level_string "$1"

    while [[ ! $prompt =~ ^[YyNn]$ ]]
    do
        read -n 1 -r -p "$string" prompt
        echo
    done
}

function link_file_prompt {
    if [ -f "$2" ]
    then
        level_prompt "~/`basename $2` exists, replace? (y/n) "

        if [[ $prompt =~ ^[Yy]$ ]]
        then
            force_link_file "$1" "$2"
        fi
    else
        level_echo "Linking `basename $1`"
        force_link_file "$1" "$2"
    fi
}
function force_link_file {
    ln -s -i -f "$1" "$2"
}
