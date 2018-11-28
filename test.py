#!/usr/bin/env python3

import os
import shutil

def info(message):
    print("--> {}".format(message))

def query(message): 
    response = "x"

    while response not in "yn": 
        response = input("--> {} (y/n) ".format(message))

    return response == "y"

def create_link(source, dest):
    info("Linking {}".format(os.path.basename(dest)))

    if os.path.exists(dest):
        if os.path.islink(dest):
            os.remove(dest)
        else:
            shutil.rmtree(dest)

    directory = os.path.dirname(dest)

    if not os.path.exists(directory):
        info("Creating directory {}".format(directory))
        os.makedirs(directory)   

    os.symlink(source, dest)

def dotfile(source, dotfile):
    source_abs = os.path.abspath(os.path.expanduser(source))
    dotfile_abs = os.path.abspath(os.path.expanduser(dotfile))

    source_real = os.path.realpath(source_abs)
    dotfile_real = os.path.realpath(dotfile_abs)

    if os.path.islink(dotfile_abs):
        if source_real == dotfile_real:
            info("{} already linked".format(dotfile))
            return
        elif query("{} linked to {}, overwrite?".format(dotfile, dotfile_real)):
            create_link(source_abs, dotfile_abs)

    elif os.path.exists(dotfile):
        if query("{} already exists, delete and overwrite?".format(dotfile)):
            create_link(source_abs, dotfile_abs)

    else:
        create_link(source_abs, dotfile_abs)


dotfile("vim/vimrc.home", "~/.vimrc")
