#!/bin/sh

choice=""

level_prompt "Do you wish to install fonts to $HOME/Library/Fonts? (y/n) "

if [[ $prompt =~ ^[Yy]$ ]]
then
    level_echo "Cloning fonts..."
    git submodule update --init fonts/powerline-fonts
    level_echo "Running installer..."
    ./fonts/powerline-fonts/install.sh
fi
