case "$(uname -s)" in
	Darwin*) export EDITOR="emacsclient -c";;
	*) export EDITOR=vim
esac

# Set locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# My dotfiles bin/
export PATH="$DOTFILES/bin:$PATH"

# Cargo bin
export PATH="$HOME/.cargo/bin:$PATH"

