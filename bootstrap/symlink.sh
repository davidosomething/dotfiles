#!/usr/bin/env bash
#
# Basic symlinks, safe to run on any system

set -eu

################################################################################
# initialize script and dependencies
# get this bootstrap folder
cd "$(dirname $0)"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh

################################################################################
dkostatus "Symlinking dotfiles"
dkosymlink ack/ackrc             .ackrc
dkosymlink cvs/cvsignore         .cvsignore

dkosymlink tmux/tmux.conf        .tmux.conf

dkosymlink ruby/gemrc            .gemrc
dkosymlink screen/screenrc       .screenrc

dkosymlink bash/bashrc.sh        .bashrc
dkosymlink bash/bash_profile.sh  .bash_profile

dkosymlink zsh                   .zsh
dkosymlink zsh/zshenv.zsh        .zshenv
