#!/usr/bin/env bash
#
# Vim symlinks, safe to run on any system

set -eu

################################################################################
# initialize script and dependencies
# get this bootstrap folder
cd "$(dirname $0)"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh

dkorequire "curl"

################################################################################
# Check if a vim folder already exists
if [[ -d "$HOME/.vim" ]]; then
  dkodie "The folder ~/.vim already exists, please move or rename it before proceeding."
fi

################################################################################
dkostatus "Symlinking vim dotfiles and .vim folder"
dkosymlink vim                 .vim
dkosymlink vim/vimrc           .vimrc
dkosymlink vim/gvimrc          .gvimrc

dkostatus "Installing neobundle"
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

dkostatus "Done! [vim.sh]"
