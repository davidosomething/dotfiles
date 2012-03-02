#!/bin/zsh
# using zsh as scripting lang, only runs if zsh is available

echo
echo "+------------------------------------------------------------------------------+"
echo "| davidosomething's dotfile installation                                       |"
echo "+------------------------------------------------------------------------------+"
echo

##
# check dependencies
p="zsh";        if ! which $p >/dev/null 2>&1;then echo "[MISSING] $p\n";exit;fi # redundant??
p="wget";       if ! which $p >/dev/null 2>&1;then echo "[MISSING] $p\n";exit;fi
p="ssh-keygen"; if ! which $p >/dev/null 2>&1;then echo "[MISSING] $p\n";exit;fi
p="git";        if ! which $p >/dev/null 2>&1;then echo "[MISSING] $p\n";exit;fi

##
# what should we do?
# @TODO check for --all argument
echo -n "Set up ssh keys [y/N]? ";                    read do_ssh;
echo -n "Set up git and github [y/N]? ";              read do_git;
if [ "$do_git:l" != "y" ]; then
  echo '[SKIPPING] Set up git, checking for existing .gitconfig with github token'
  if ! cat ~/.gitconfig >/dev/null 2>&1 | grep token >/dev/null; then
    echo '[MISSING] github token, git and github are required!'
    echo
    exit;
  else
    echo '[FOUND] github already set up'
  fi
fi
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
    echo "Please enter your email to id your ssh key and git user:";
    echo -n "> "; read email
    ssh-keygen -t rsa -C "$email"
    cat ~/.ssh/id_rsa.pub
    cat ~/.ssh/id_rsa.pub | pbcopy > /dev/null 2>&1
    echo "\nYour ssh public key is shown above and copied to the clipboard on OSX."
    echo "Add it to Github and press [enter] to proceed."
    read
  }
}

##
# setup your ssh keys for github
# from https://gist.github.com/1454081
[ "$do_git:l" = "y" ] && {
  echo "You can run this again if you mess up."
  echo "Please enter your full name:"
  echo -n "> "; read fullname
  echo "Please enter your github username:"
  echo -n "> "; read githubuser
  echo "Please enter your github api token:"
  echo -n "> "; read githubtoken
  # in case we skipped the email in the ssh section
  if [ "$email" = "" ]; then
    echo "Please enter your email:"
    echo -n "> "; read email
  fi
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
  mv $HOME/.zshrc $HOME/.dotfiles/.zshrc.old
  mv $HOME/.zshenv $HOME/.dotfiles/.zshenv.old
  echo "Your old zshrc and zshenv are now ~/.dotfiles/*.old"

  ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
  ln -s $HOME/.dotfiles/.zshenv $HOME/.zshenv
  echo "Your new zshrc and zshenv are softlinks to .dotfiles/*"
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
