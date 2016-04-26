#!/bin/sh

source utils.sh

# Link dotfiles
level_echo "Linking dotfiles"
increase_level

for file in $( find * | grep "\.home$" )
do
    dotfile=$( basename $file | sed "s/\(.*\)\.home$/.\1/" )

    source="`pwd`/$file" 
    destination="$HOME/$dotfile"

    link_file_prompt "$source" "$destination"
done

decrease_level

# Run installer scripts
level_echo "Run installer scripts"

increase_level
for file in $( ls -d */ | sed 's|/$||' | xargs -I{} find {} -maxdepth 1 | grep "install\.sh$" )
do
    level_echo "Running $file"

    increase_level
    source $file
    decrease_level
done
decrease_level
