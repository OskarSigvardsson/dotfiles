#!/bin/bash

# Ensure (server-start) is added in your emacs init script.

EMACS=/Applications/Emacs.app/Contents/MacOS/Emacs
EMACSCLIENT=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient

# test if client already exists
$EMACSCLIENT -e "(frames-on-display-list)" &>/dev/null

# use emacsclient to connect existing server.
if [ $? -eq 0 ]; then
    $EMACSCLIENT -n "$@"
# open emacs.app instead.
else
    `$EMACS "$@"` &
fi
