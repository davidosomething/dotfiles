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
dko::status "Symlinking dotfiles"

# ctags
dko::symlink ctags/ctags                          .ctags

# XDG-compatible
dko::symlink git/gitconfig                        .config/git/config
dko::symlink git/gitignore                        .config/git/ignore
dko::symlink shell/.inputrc                       .config/readline/inputrc

# (n)vim
dko::symlink vim                                  .vim
dko::symlink vim                                  .config/nvim

case "$OSTYPE" in
  darwin*)
    dko::symlink subversion/config                .subversion/config
    ;;
  linux*)
    dko::symlink linux/subversion/config          .subversion/config
    ;;
esac


# symlink shells ---------------------------------------------------------------
dko::symlink bash/.bashrc                         .bashrc
dko::symlink bash/.bash_profile                   .bash_profile
dko::symlink zsh/.zshenv                          .zshenv

dko::status "Done! [symlink.sh]"
