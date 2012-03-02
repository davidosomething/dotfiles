#!/bin/zsh
# using zsh as scripting lang, only runs if zsh is available

##
# check dependencies
p="zsh";        if ! which $p >/dev/null 2>&1;then echo "[MISSING] $p";return 1;fi # redundant??
p="wget";       if ! which $p >/dev/null 2>&1;then echo "[MISSING] $p";return 1;fi
p="ssh-keygen"; if ! which $p >/dev/null 2>&1;then echo "[MISSING] $p";return 1;fi
p="git";        if ! which $p >/dev/null 2>&1;then echo "[MISSING] $p";return 1;fi

##
# what should we do?
# @TODO check for --all argument
echo -n "Set up ssh keys [y/N]? ";                    read do_ssh;
echo -n "Set up git and github [y/N]? ";              read do_git;
[ "$do_git:l" != "y" ] && {
  if ! cat ~/.gitconfig >/dev/null 2>&1 | grep token; then
    echo '[MISSING] github token, set up git!'
    return 1;
  fi
}
echo -n "Set up zsh [y/N]? ";                         read do_zsh;
echo -n "Symlink .cvsignore (used by rsync) [y/N]? "; read do_cvsignore;
echo -n "Set up vim [y/N]? ";                         read do_vim;

##
# set default shell to zshell
echo -n "Switch to zsh [y/N]? "; read do_switch_zsh; [ "$do_switch_zsh" = "y" ] && {
  chsh -s `which zsh`
}

##
# install shit
# @TODO: determine if osx
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

##
# set up ssh key pairs
# from https://gist.github.com/1454081
[ "$do_ssh:l" = "y" ] && {
  mkdir ~/.ssh
  [ ! -e "~/.ssh/id_rsa.pub" ] && {
    echo "Generating ssh key..."
    read -p "Please enter the email you want to associate with your ssh key: " email
    ssh-keygen -t rsa -C "$email"
    cat ~/.ssh/id_rsa.pub
    cat ~/.ssh/id_rsa.pub | pbcopy
    echo "\nYour ssh public key is shown above and copied to the clipboard. Add it to Github. [enter] to proceed."
    read
  }
}

##
# setup your ssh keys for github
# from https://gist.github.com/1454081
[ "$do_git:l" = "y" ] && {
  echo "You can run this again if you mess up."
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

##
# the following require git and github set up
##

##
# grab dotfiles from this repo
git clone --recursive git@github.com:davidosomething/dotfiles.git ~/.dotfiles
# the clone will just fail if it's already cloned (e.g., didn't run through curl | zsh)

##
# set up zsh
# @TODO should this go into ~/.zsh/install.sh? YES
[ "$do_zsh:l" = "y" ] && {
  mv ~/.zsh ~/.zsh.old
  echo "Moved old ~/.zsh folder into ~/.zsh.old (just in case)"
  git clone --recursive git@github.com:davidosomething/dotfiles-zsh.git ~/.zsh && ~/.zsh/install.sh
  /usr/bin/env zsh
  source ~/.zshrc
}

[ "$do_cvsignore:l" = "y" ] && {
  ln -s ~/.dotfiles/.cvsignore ~/.cvsignore
}

# set up vim
# @TODO should this go into ~/.vim/install.sh? YES
[ "$do_vim:l" = "y" ] && {
  mv ~/.vim ~/.vim.old
  echo "Moved old ~/.vim folder into ~/.vim.old (just in case)"
  git clone --recursive git@github.com:davidosomething/dotfiles-vim ~/.vim && ~/.vim/install.sh
}
