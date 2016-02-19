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

# XDG-compatible
dkosymlink git/gitconfig                        .config/git/config
dkosymlink git/gitignore                        .config/git/ignore
dkosymlink shell/.inputrc                       .config/readline/inputrc

# (n)vim
dkosymlink vim                                  .vim
dkosymlink vim                                  .config/nvim

case "$OSTYPE" in
  darwin*)
    dkosymlink subversion/config                .subversion/config
    ;;
  linux*)
    dkosymlink linux/subversion/config          .subversion/config
    ;;
esac


# symlink shells ---------------------------------------------------------------
dkosymlink bash/.bashrc                         .bashrc
dkosymlink bash/.bash_profile                   .bash_profile
dkosymlink zsh/.zshenv                          .zshenv

dkostatus "Done! [symlink.sh]"
