function symlink {
  ln -fns $DOTFILES_FOLDER/$1 $HOME/$2 && status "$2 symlinked to $DOTFILES_FOLDER/$1"
}
status "Symlinking dotfiles"
symlink ack/ackrc           .ackrc
symlink bash/bashrc         .bashrc
symlink bash/bash_profile   .bash_profile
symlink pow/.powconfig      .powconfig
symlink tmux/tmux.conf      .tmux.conf
symlink screen/screenrc     .screenrc
symlink zsh/zshenv          .zshenv
symlink zsh/zshrc           .zshrc
