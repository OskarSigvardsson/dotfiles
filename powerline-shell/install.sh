level_echo "Cloning powerline-shell"
git submodule update --init powerline-shell/powerline-shell

level_echo "Copying config file"
cp powerline-shell/config.py powerline-shell/powerline-shell/config.py

level_echo "Running powerline"
cd powerline-shell/powerline-shell 
./install.py
link_file_prompt "`pwd`/powerline-shell.py" "$HOME/.powerline-shell.py"
cd ../..
