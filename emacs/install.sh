#!/bin/sh

level_echo "Creating emacs.d"

mkdir -p "$HOME/.emacs.d/"

link_file_prompt "$(pwd)/emacs/init.el"    "$HOME/.emacs.d/init.el"
link_file_prompt "$(pwd)/emacs/custom.el"  "$HOME/.emacs.d/custom.el"
link_file_prompt "$(pwd)/emacs/config.org" "$HOME/.emacs.d/config.org"

level_echo "Run emacs to finish installation"
