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
dkosymlink vim/spell/en.utf-8.add               .aspell.en.pws
dkosymlink mdl/.mdlrc.symlink                   .mdlrc

# XDG-compatible
dkosymlink git/.gitconfig.symlink               .config/git/config
dkosymlink shell/.inputrc.symlink               .config/readline/inputrc

# irssi
dkosymlink irssi                                .irssi

# (n)vim
dkosymlink vim                                  .vim
dkosymlink vim                                  .config/nvim

case "$OSTYPE" in
  darwin*)
    dkosymlink subversion/config.symlink        .subversion/config
    ;;
  linux*)
    dkosymlink linux/locale.conf                .config/locale.conf
    dkosymlink linux/subversion/config.symlink  .subversion/config
    dkosymlink linux/x/.Xresources              .Xresources
    ;;
esac


# symlink shells ---------------------------------------------------------------
dkosymlink bash/.bashrc.symlink                 .bashrc
dkosymlink bash/.bash_profile.symlink           .bash_profile
dkosymlink zsh/.zshenv.symlink                  .zshenv

dkostatus "Done! [symlink.sh]"
