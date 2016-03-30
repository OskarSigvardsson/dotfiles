#!/bin/sh

for FILE in $( find * | grep "\.home$" )
do
    DOTFILE=$( basename $FILE | sed "s/\(.*\)\.home$/.\1/" )

    ln -s -i "`pwd`/$FILE" "$HOME/$DOTFILE"
    if [ ! -f "$HOME/$DOTFILE" ]
    then
        echo "$HOME/$DOTFILE replaced"
    fi
done
