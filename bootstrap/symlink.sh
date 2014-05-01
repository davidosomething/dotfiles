#!/usr/bin/env bash
set -eu

################################################################################
# Basic symlinks, safe to run on any system
################################################################################

##
# initialize script and dependencies
# get this bootstrap folder
cd "$(dirname $0)"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh

##
# begin
dkostatus "Symlinking dotfiles"
dkosymlink ack/ackrc             .ackrc
dkosymlink cvs/cvsignore         .cvsignore
dkosymlink ruby/gemrc            .gemrc
dkosymlink screen/screenrc       .screenrc
dkosymlink tmux/tmux.conf        .tmux.conf

##
# symlink shells
dkosymlink bash/.bashrc         .bashrc
dkosymlink bash/.bash_profile   .bash_profile
dkosymlink zsh/.zshenv          .zshenv

dkostatus "Done! [symlink.sh]"
