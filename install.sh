#!/bin/sh
GREEN="$(tput setaf 2)"
BLUE="$(tput setaf 4)"
RESET="$(tput sgr0)"


# Link dotfiles
echo "${GREEN}--> Linking dotfiles${RESET}"
for FILE in $( find * | grep "\.home$" )
do
    DOTFILE=$( basename $FILE | sed "s/\(.*\)\.home$/.\1/" )

    echo "${BLUE}---> $DOTFILE${RESET}"
    ln -s -i "`pwd`/$FILE" "$HOME/$DOTFILE"
done

# Run installer scripts
echo "${GREEN}--> Run installer scripts${RESET}"
for FILE in $( ls -d */ | sed 's|/$||' | xargs find | grep "install\.sh$" )
do
    echo "${BLUE}---> Running $FILE${RESET}"
    sh $FILE
done
