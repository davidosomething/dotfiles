#!/usr/bin/env bash
set -eu

################################################################################
# Basic symlinks, safe to run on any system
################################################################################

##
# initialize script and dependencies
# get this bootstrap folder
cd "$(dirname "$0")"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source "$bootstrap_path/helpers.sh"

##
# begin
dkostatus "Symlinking dotfiles"
dkosymlink ack/.ackrc.symlink         .ackrc
dkosymlink ctags/.ctags.symlink       .ctags
dkosymlink cvs/.cvsignore.symlink     .cvsignore
dkosymlink git/.gitconfig.symlink     .gitconfig
dkosymlink subversion/config.symlink  .subversion/config
dkosymlink shell/.inputrc.symlink     .inputrc
dkosymlink ruby/.gemrc.symlink        .gemrc
dkosymlink screen/.screenrc.symlink   .screenrc

##
# symlink shells
dkosymlink bash/.bashrc.symlink         .bashrc
dkosymlink bash/.bash_profile.symlink   .bash_profile
dkosymlink zsh/.zshenv.symlink          .zshenv

dkostatus "Done! [symlink.sh]"
