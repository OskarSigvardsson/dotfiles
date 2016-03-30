#!/bin/sh

# Link dotfiles
for FILE in $( find * | grep "\.home$" )
do
    DOTFILE=$( basename $FILE | sed "s/\(.*\)\.home$/.\1/" )

    if [ ! -f "$HOME/$DOTFILE" ]
    then
        echo "$HOME/$DOTFILE replaced"
    fi
    ln -s -i "`pwd`/$FILE" "$HOME/$DOTFILE"
done

# Run installer scripts
for FILE in $( ls -d */ | sed 's|/$||' | xargs find | grep "install\.sh$" )
do
    echo "Running $FILE"
    sh $FILE
done
