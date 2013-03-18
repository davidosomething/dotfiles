#!/usr/bin/env bash
set -e

################################################################################
# Vim symlinks, safe to run on any system
################################################################################

################################################################################
# initialize script and dependencies
# get this bootstrap folder
cd "`dirname $0`"/..
dotfiles_path="`pwd`"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh

################################################################################
# Begin
dkostatus "Symlinking vim dotfiles and .vim folder"
dkosymlink vim                 .vim
dkosymlink vim/vimrc           .vimrc
dkosymlink vim/gvimrc          .gvimrc
dkoinstalling "vim bundles"
vim +BundleInstall +qall
