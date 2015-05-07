#!/usr/bin/env bash
set -e

# Basic symlinks, safe to run on any system

# initialize script and dependencies -------------------------------------------
# get this bootstrap folder
cd "$(dirname "$0")"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source "$bootstrap_path/helpers.sh"

# begin ------------------------------------------------------------------------
dkostatus "Symlinking dotfiles"
dkosymlink shell/.inputrc.symlink     .inputrc
dkosymlink ctags/.ctags.symlink       .ctags
dkosymlink git/.gitconfig.symlink     .gitconfig
dkosymlink mdl/.mdlrc.symlink         .mdlrc
dkosymlink ruby/.gemrc.symlink        .gemrc

mkdir -p "$HOME/.subversion"
case "$OSTYPE" in
  darwin*)
    dkosymlink subversion/config.symlink  .subversion/config
    ;;
  linux*)
    dkosymlink linux/subversion/config.symlink  .subversion/config
    ;;
esac

# symlink shells ---------------------------------------------------------------
dkosymlink bash/.bashrc.symlink         .bashrc
dkosymlink bash/.bash_profile.symlink   .bash_profile
dkosymlink zsh/.zshenv.symlink          .zshenv

dkostatus "Done! [symlink.sh]"
