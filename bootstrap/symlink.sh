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
dkosymlink ctags/.ctags.symlink       .ctags
dkosymlink mdl/.mdlrc.symlink         .mdlrc
dkosymlink ruby/.gemrc.symlink        .gemrc
dkosymlink subversion/config.symlink  .subversion/config

##
# symlink shells
dkosymlink bash/.bashrc.symlink         .bashrc
dkosymlink bash/.bash_profile.symlink   .bash_profile
dkosymlink zsh/.zshenv.symlink          .zshenv

dkostatus "Done! [symlink.sh]"
