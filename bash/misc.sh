# Add ssh keys to ssh-agent using keychain password

ssh-add -A > /dev/null 2> /dev/null

# Add completions
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
