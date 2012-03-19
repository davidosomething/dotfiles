#!/bin/zsh
# using zsh as scripting lang, only runs if zsh is available

echo "==== dotfile and environment setup by @davidosomething ===="

function usage {
  echo
  echo "usage:          ./install.sh options"
  echo
  echo "options:"
  echo "  --all         perform all install actions (if you get through the dependencies"
  echo "  -h | --help   show usage (you're looking at it)"
  echo
}

# read parameters
while [ "$1" != "" ]; do
  case $1 in
    --all )           do_all=1
                      ;;
    -h | --help )     usage
                      exit
                      ;;
    * )               usage
                      exit 1
  esac
  shift
done

echo
echo "== checking for dependencies =="
function require {
  if ! which $1 >/dev/null 2>&1; then
    echo "[ERROR] missing $1, please install before proceeding.";
    exit 1
  else
    echo "[SUCCESS] found $1"
  fi
}
require "zsh"
require "wget"
require "ssh-keygen"
require "git"

echo
echo "== checking for recommended utilities =="
function recommend {
  if ! which $1 >/dev/null 2>&1; then
    echo "[WARNING] missing $1, recommend you install it."
  else
    echo "[SUCCESS] found $1"
  fi
}
recommend "ant"
recommend "curl"
recommend "nmap"
recommend "nodeenv"
recommend "python"
recommend "rbenv"
recommend "rsync"
recommend "tmux"
recommend "vim"

if ! which $SHELL |grep zsh >/dev/null 2>&1; then
  echo
  echo "[NOTICE] You aren't using ZSH. ZSH is awesome."
  echo -n "Switch to zsh [y/N]? ";                      read do_switch_zsh;
  ###############################################
  # change shell
  ###############################################
  [ "$do_switch_zsh" = "y" ] && {
    echo
    echo "== changing shell =="
    chsh -s `which zsh` && echo "[SUCCESS] user default shell changed to zsh"
    echo "[NOTICE] using zsh at $(which zsh) -- fix your path if this is wrong!"
    echo "         please restart your terminal session, or start a new zsh"
    echo "         You will need to run this install script again"
    exit 0
  }
else
  echo "[SUCCESS] cool, you're using zsh"
fi

if [ ! -e ~/.ssh/id_rsa.pub ]; then
  # from https://gist.github.com/1454081
  echo
  echo "[NOTICE] no ssh keys found for this user on this machine, required"
  echo
  echo "== setting up SSH keys =="
  mkdir ~/.ssh
  echo -n "Please enter your email to comment this SSH key: "; read email
  ssh-keygen -t rsa -C "$email"
  cat ~/.ssh/id_rsa.pub
  cat ~/.ssh/id_rsa.pub | pbcopy > /dev/null 2>&1
  echo "[SUCCESS] Your ssh public key is shown above and (copied to the clipboard on OSX)"
  echo "          Add it to GitHub if this computer needs push permission."
  echo "          When that's done, press [enter] to proceed."
  read
else
  echo
  echo "[SUCCESS] found SSH keys for this user"
fi

echo
echo "== begin install =="
# @TODO check for --all argument
echo -n "Symlink .cvsignore (used by rsync) [y/N]? "; read do_cvsignore;
echo -n "Symlink .tmux.conf [y/N]? ";                 read do_tmux;
echo -n "Symlink .powconfig [y/N]? ";                 read do_pow;
echo -n "Set up gitconfig [y/N]? ";                   read do_gitconfig;
echo -n "Set up github [y/N]? ";                      read do_github;
echo -n "Set up zsh [y/N]? ";                         read do_zsh;
echo -n "Set up vim [y/N]? ";                         read do_vim;
echo -n "Set up bin [y/N]? ";                         read do_bin;

echo
echo "== processing git configuration =="
GITHUB_URL='git://github.com/davidosomething'
if [ "$do_github:l" != "y" ]; then
  echo '[NOTICE] opted to skip github setup, checking for existing .gitconfig with github token'
  if ! git config --global --get github.token >/dev/null 2>&1; then
    echo '[WARNING] missing github token, disabling write access to repositories.'
    echo '          this machine will not be able to push edits back to the repository!'
  elif [ `git config --global --get github.user` = "davidosomething" ]; then
    GITHUB_URL='git@github.com:davidosomething'
    echo '[SUCCESS] github token found and github user is davidosomething,'
    echo '          your dotfiles will be cloned with write access.'
  fi
fi


[ "$do_gitconfig:l" = "y" ] && {
  echo
  echo "== setting up git == "
  echo "You can run this again if you mess up."
  echo -n "Please enter your full name: "; read fullname
  # in case we skipped the email in the ssh section
  if [ "$email" = "" ]; then
    echo -n "Please enter your email: "; read email
  fi
  [[ $fullname    != '' ]] && git config --global user.name "$fullname"
  [[ $email       != '' ]] && git config --global user.email "$email"

  # auto color all the things!
  git config --global color.ui auto

  # use cvsignore (symlink)
  git config --global core.excludesfiles ~/.dotfiles/.cvsignore

  # vim as diff tool
  git config --global diff.tool vimdiff

  echo "[SUCCESS] global .gitconfig generated/updated!"
}

[ "$do_github:l" = "y" ] && {
  echo
  echo "== setting up github == "
  echo "You can run this again if you mess up."
  echo -n "Please enter your github username:  "; read githubuser
  echo -n "Please enter your github api token: "; read githubtoken
  [[ $githubuser  != '' ]] && git config --global github.user "$githubuser"
  [[ $githubtoken != '' ]] && git config --global github.token "$githubtoken"
  echo "[SUCCESS] global .gitconfig updated with github info"
}

###############################################
# symlink config files
###############################################

[ "$do_cvsignore:l" = "y" ] && {
  echo
  echo "== symlink .cvsignore =="
  [ -f ~/.cvsignore ] && { mv ~/.cvsignore ~/.cvsignore.old && echo "[NOTICE] Moved old ~/.cvsignore folder into ~/.cvsignore.old" }
  ln -fs ~/.dotfiles/.cvsignore ~/.cvsignore && echo "[SUCCESS] .cvsignore symlinked"
}

[ "$do_tmux:l" = "y" ] && {
  echo
  echo "== symlink .tmux.conf =="
  [ -f ~/.tmux.conf ] && { mv ~/.tmux.conf ~/.tmux.conf.old && echo "[NOTICE] Moved old ~/.tmux.conf folder into ~/.tmux.conf.old" }
  ln -fs ~/.dotfiles/.tmux.conf ~/.tmux.conf && echo "[SUCCESS] .tmux.conf symlinked"
}

[ "$do_pow:l" = "y" ] && {
  echo
  echo "== symlink .powconfig =="
  [ -f ~/.powconfig ] && { mv ~/.powconfig ~/.powconfig.old && echo "[NOTICE] Moved old ~/.powconfig into ~/.powconfig.old" }
  ln -fs ~/.dotfiles/.powconfig ~/.powconfig && echo "[SUCCESS] .powconfig symlinked"
}

###############################################
# the following require git and github set up
###############################################

if [ ! -d ~/.dotfiles ]; then
  echo
  echo "== cloning dotfiles repo =="
  git clone --recursive $GITHUB_URL/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
  echo '[SUCCESS] cloned dotfiles repo'
fi

echo
echo "== cloning and updating submodules =="
git submodule update --init --quiet

[ "$do_zsh:l" = "y" ] && {
  echo
  echo "== symlink zsh dotfiles =="
  [ -f ~/.zshrc ] && mv ~/.zshrc ~/.dotfiles/.zshrc.old
  [ -f ~/.zshenv ] && mv ~/.zshenv ~/.dotfiles/.zshenv.old
  echo "[NOTICE] Your old .zshrc and .zshenv are now ~/.dotfiles/.zsh*.old"

  ln -fs ~/.dotfiles/.zshrc ~/.zshrc && ln -fs ~/.dotfiles/.zshenv ~/.zshenv && {
    echo "[SUCCESS] Your new .zshrc and .zshenv are symlinks to ~/.dotfiles/.zsh*"
    echo "          Create .zshrc.local with any additional fpaths and .zshenv.local with"
    echo "          correct paths! There are a few stock configs in ~/.dotfiles/"
  }
}

[ "$do_vim:l" = "y" ] && {
  echo
  echo "== symlink .vim folder and vim dotfiles =="
  [ -d ~/.vim ] && { mv ~/.vim ~/.vim.old && echo "[NOTICE] Moved old ~/.vim folder into ~/.vim.old (just in case)" }
  ln -fs ~/.dotfiles/vim ~/.vim && echo "[SUCCESS] Your ~/.vim folder is a symlink to ~/.dotfiles/vim"

  mkdir -p ~/.dotfiles/vim/_temp
  mkdir -p ~/.dotfiles/vim/_backup
  echo "[SUCCESS] Created backup and temp folders for vim"

  # just in case
  [ -f ~/.vimrc ] && { mv ~/.vimrc ~/.vimrc.old }
  [ -f ~/.gvimrc ] && { mv ~/.gvimrc ~/.gvimrc.old }
  echo "[NOTICE] Your old .?vimrc is now ~/.?vimrc.old"

  # create softlink to (g)vimrc
  ln -fs ~/.dotfiles/.vimrc ~/.vimrc && echo "[SUCCESS] Your new .vimrc is a symlink to ~/.dotfiles/.vimrc"
  ln -fs ~/.dotfiles/.gvimrc ~/.gvimrc && echo "[SUCCESS] Your new .gvimrc is a symlink to ~/.dotfiles/.gvimrc"
}

[ "$do_bin:l" = "y" ] && {
  echo
  echo "== create ~/bin and symlink some scripts =="
  [ ! -d ~/bin ] && { mkdir ~/bin && echo "[SUCCESS] Created local bin folder" }
  for f in ~/.dotfiles/bin/*
  do
    BIN_NAME=$(basename $f)
    [ ! -f ~/bin/$BIN_NAME ] && ln -fs $f ~/bin/$BIN_NAME && echo "[SUCCESS] ~/bin/$BIN_NAME symlinked"
  done
}

echo
echo "[SUCCESS] ALL DONE!!!!!!11111"
