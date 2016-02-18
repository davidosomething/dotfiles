#!/usr/bin/env bash
set -e

# Basic symlinks, safe to run on any system

# initialize script and dependencies -------------------------------------------
# get this bootstrap folder
cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
readonly bootstrap_path="${dotfiles_path}/bootstrap"
source "${bootstrap_path}/helpers.sh"

# begin ------------------------------------------------------------------------
dkostatus "Symlinking dotfiles"

# ctags
dkosymlink ctags/ctags                          .ctags

# markdownlint
dkosymlink mdl/.mdlrc                           .mdlrc

# XDG-compatible
dkosymlink git/.gitconfig                       .config/git/config
dkosymlink shell/.inputrc                       .config/readline/inputrc

# irssi
dkosymlink irssi                                .irssi

# (n)vim
dkosymlink vim                                  .vim
dkosymlink vim                                  .config/nvim

case "$OSTYPE" in
  darwin*)
    dkosymlink subversion/config                .subversion/config
    ;;
  linux*)
    dkosymlink linux/locale.conf                .config/locale.conf
    dkosymlink linux/subversion/config          .subversion/config
    dkosymlink linux/x/.Xresources              .Xresources
    ;;
esac


# symlink shells ---------------------------------------------------------------
dkosymlink bash/.bashrc                         .bashrc
dkosymlink bash/.bash_profile                   .bash_profile
dkosymlink zsh/.zshenv                          .zshenv

dkostatus "Done! [symlink.sh]"
