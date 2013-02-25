#!/usr/env/bin bash
set -e

# assumes the dotfiles repo was cloned with submodules, which includes vundle
# in the .vim folder
installing "vim dotfiles and .vim folder"
symlink vim                 .vim
symlink vim/vimrc           .vimrc
symlink vim/gvimrc          .gvimrc
installing "vim bundles"
vim +BundleInstall +qall
