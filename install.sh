#!/bin/zsh
# using zsh as scripting lang, only runs if zsh is available

# set default shell to zshell
echo -n "Switch to zsh [y/N]? "; read dothis; [ "$dothis" = Y ] && {
  chsh -s `which zsh`
}

# set up zsh
# @TODO should this go into ~/.zsh/install.sh?
echo -n "Set up zsh [y/N]? "; read dothis; [ "$dothis" = Y ] && {
  mv ~/.zsh ~/.zsh.old
  echo "Moved old ~/.zsh folder into ~/.zsh.old (just in case)"
  git clone --recursive git@github.com:davidosomething/dotfiles-zsh.git ~/.zsh && ~/.zsh/install.sh
  /usr/bin/env zsh
  source ~/.zshrc
}

# from https://gist.github.com/1454081
# setup your ssh keys for github
echo -n "Set up ssh keys [y/N]? "; read dothis; [ "$dothis" = Y ] && {
  mkdir ~/.ssh
  [ ! -e "$HOME/.ssh/id_rsa.pub" ] && {
    echo "Generating ssh key..."
    read -p "Please enter the email you want to associate with your ssh key: " email
    ssh-keygen -t rsa -C "$email"
  }
}

# @TODO: check for make

# @TODO: check for macports
#sudo port install ant-contrib
#sudo port install apache-ant
#sudo port install apache2
#sudo port install curl
#sudo port install git-core +svn
#sudo port install macvim
#sudo port install openssh
#sudo port install openssl
#sudo port install php5
#sudo port install php5-soap
#sudo port install rsync
#sudo port install wget

echo -n "Symlink .cvsignore (used by rsync) [y/N]? "; read dothis; [ "$dothis" = Y ] && {
  ln -s ~/.dotfiles/.cvsignore ~/.cvsignore
}

# @TODO: check for git
echo -n "Set up git [y/N]? "; read dothis; [ "$dothis" = Y ] && {
  read -p "Please enter your full name: " fullname
  read -p "Please enter your github username: " githubuser
  read -p "Please enter your github api token: " githubtoken
  [[ $fullname    != '' ]] && git config --global user.name "$fullname"
  [[ $email       != '' ]] && git config --global user.email "$email"
  [[ $githubuser  != '' ]] && git config --global github.user "$githubuser"
  [[ $githubtoken != '' ]] && git config --global github.token "$githubtoken"
  git config --global color.ui auto
  git config --global core.excludesfiles ~/.dotfiles/.cvsignore # use cvsignore (symlink)
}

# set up vim
# @TODO should this go into ~/.vim/install.sh?
echo -n "Set up vim [y/N]? "; read dothis; [ "$dothis" = Y ] && {
  mv ~/.vim ~/.vim.old
  echo "Moved old ~/.vim folder into ~/.vim.old (just in case)"
  git clone --recursive git@github.com:davidosomething/dotfiles-vim ~/.vim && ~/.vim/install.sh
}
