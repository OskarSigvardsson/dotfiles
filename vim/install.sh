# Create VIM directory
if [ ! -e $HOME/.vim ]
then
    mkdir $HOME/.vim
fi

# Create swpfile directory
if [ ! -e $HOME/.vim/swpfiles ]
then
    mkdir $HOME/.vim/swpfiles
fi

# Install Vundle
if [ ! -e $HOME/.vim/bundle/Vundle.vim ]
then
    git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
fi

# Install Vundle plugins
vim +PluginInstall +qall
