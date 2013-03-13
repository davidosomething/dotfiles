#!/usr/bin/env bash
set -e

function symlink {
  local dotfile="$1"
  local homefile="$2"
  ln -fns $DOTFILES_FOLDER/$dotfile $HOME/$homefile && status "$homefile symlinked to $DOTFILES_FOLDER/$dotfile"
}

status "Symlinking dotfiles"
symlink ack/ackrc             .ackrc

symlink tmux/tmux.conf        .tmux.conf

symlink screen/screenrc       .screenrc

symlink bash/bashrc.sh        .bashrc
symlink bash/bash_profile.sh  .bash_profile

symlink zsh                   .zsh
symlink zsh/zshenv.zsh        .zshenv
