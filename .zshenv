export PATH=$HOME/bin:$PATH
export EDITOR=editor
if [ -e /Users/oskarsigvardsson/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/oskarsigvardsson/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
. "$HOME/.cargo/env"
