#!/usr/bin/env bash
set -e

function symlink {
  ln -fns $DOTFILES_FOLDER/$1 $HOME/$2 && status "$2 symlinked to $DOTFILES_FOLDER/$1"
}

status "Symlinking dotfiles"
symlink ack/ackrc             .ackrc

symlink tmux/tmux.conf        .tmux.conf

symlink screen/screenrc       .screenrc

symlink bash/bashrc.sh        .bashrc
symlink bash/bash_profile.sh  .bash_profile

symlink zsh                   .zsh
symlink zsh/zshenv.zsh        .zshenv
