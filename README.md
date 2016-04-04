My dotfiles repo. Very early stages.

To install, clone into some folder, run ```./install.sh``` and then add this to your .bashrc/.bash_profile: 

    source ~/path/to/dotfiles/repo/bashrc.sh

To make sure the various bashrc scripts in the repo runs when you log in. 

Note that this does not install necessary packages, so you might have to do that manually. Also, Vim might throw some errors (like that YouCompleteMe has to be compiled manually), which you might have to fix on your own. 
