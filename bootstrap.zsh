#!/bin/zsh
# using zsh as scripting lang, only runs if zsh is available
#
# variables:
dotfiles_debug=0
dotfiles_verbose=1
dotfiles_do_all=0
dotfiles_do_ask=1
# don't skip anything by default
dotfiles_skip_check_dependency=0
dotfiles_skip_check_shell=0
dotfiles_skip_check_ssh_keys=0
dotfiles_skip_check_git_writable=0
# don't create backups
dotfiles_skip_backups=0
dotfiles_skip_checks=0
# the following are actions and take y/n instead of 1/0
dotfiles_do_bin="n"
dotfiles_do_cvsignore="n"
dotfiles_do_gitconfig="n"
dotfiles_do_github="n"
dotfiles_do_osx="n"
dotfiles_do_pow="n"
dotfiles_do_tmux="n"
dotfiles_do_vim="n"
dotfiles_do_zsh="n"

# determine if you installed and are using the alias or are running using oneliner
if [ "$0" = "dotfiles" ]; then
  dotfiles_scriptname="dotfiles"
else
  dotfiles_scriptname="./bootstrap.sh"
fi

# save OS name
OS='linux'
if [ "`uname`" = "Darwin" ]; then
  OS='osx'
fi

function dotfiles_check_dependencies() {
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
}

function dotfiles_switch_shell() {
  if ! which $SHELL |grep zsh >/dev/null 2>&1; then
    echo
    echo "[NOTICE] You aren't using ZSH. ZSH is awesome."
    echo -n "Switch to zsh [y/N]? ";                      read dotfiles_do_switch_zsh;
    ###############################################
    # change shell
    ###############################################
    [ "$dotfiles_do_switch_zsh" = "y" ] && {
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
}

function dotfiles_setup_ssh_keys() {
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
}

##
# function is skipped if you specify --all or any setup name
function dotfiles_determine_steps() {
  echo
  echo "== begin install =="
  echo "Say no to everything to just run an update (next time use --update)"
  # @TODO check for --all argument
  echo -n "Symlink .cvsignore (used by rsync) [y/N]? "; read dotfiles_do_cvsignore;
  echo -n "Symlink .tmux.conf [y/N]? ";                 read dotfiles_do_tmux;
  echo -n "Symlink .powconfig [y/N]? ";                 read dotfiles_do_pow;
  echo -n "Set up gitconfig [y/N]? ";                   read dotfiles_do_gitconfig;
  echo -n "Set up github [y/N]? ";                      read dotfiles_do_github;
  echo -n "Set up zsh [y/N]? ";                         read dotfiles_do_zsh;
  echo -n "Set up vim [y/N]? ";                         read dotfiles_do_vim;
  echo -n "Set up bin [y/N]? ";                         read dotfiles_do_bin;

  [ "$OS" = 'osx' ] && { echo -n "Set up OSX Defaults [y/N]? "; read dotfiles_do_osx; }
}

function dotfiles_setup_git() {
  echo
  echo "== setting up git == "
  echo "You can run this again if you mess up. Leave blank to skip username/email fields."
  echo -n "Please enter your full name: "; read fullname
  # in case we skipped the email in the ssh section
  if [ "$email" = "" ]; then
    echo -n "Please enter your email: "; read email
  fi
  [ "$fullname" != '' ] && git config --global user.name "$fullname"
  [ "$email"    != '' ] && git config --global user.email "$email"

  # auto color all the things!
  git config --global color.ui auto

  # use cvsignore (symlink)
  git config --global core.excludesfile ~/.dotfiles/.cvsignore

  # vim as diff tool
  git config --global diff.tool vimdiff

  # set up browser for fugitive :Gbrowse
  [ $OS = "osx" ] && git config --global web.browser open

  # a couple aliases
  git config --global alias.co checkout
  git config --global alias.st status

  echo "[SUCCESS] global .gitconfig generated/updated!"
}

function dotfiles_setup_github() {
  echo
  echo "== setting up github == "
  echo "You can run this again if you mess up. Leave blank to skip a field."
  echo -n "Please enter your github username:  "; read githubuser
  echo -n "Please enter your github api token: "; read githubtoken
  [ "$githubuser"  != '' ] && git config --global github.user "$githubuser"
  [ "$githubtoken" != '' ] && git config --global github.token "$githubtoken"
  echo "[SUCCESS] global .gitconfig updated with github info"
}

function dotfiles_determine_github_write() {
  echo
  echo "== github configuration =="

  GITHUB_URL='git://github.com/davidosomething'

  echo "Checking for existing .gitconfig with github token..."
  if ! git config --global --get github.token >/dev/null 2>&1; then
    echo '[WARNING] missing github token, disabling write access to repositories.'
    echo '          This machine will not be able to push edits back to the repository!'
  elif [ "`git config --global --get github.user`" = "davidosomething" ]; then
    GITHUB_URL='git@github.com:davidosomething'
    echo "[SUCCESS] github token found and github user is davidosomething."
    echo "          If needed, your dotfiles will be cloned with write access."
  fi
}

###############################################
# create backups if needed
# takes a file as an argument, not a string!
###############################################

function dotfiles_backup() {
  local backup_filename=$(basename $1)
  local backup_filepath="~/.dotfiles.old/$backup_filename"

  if [ "$dotfiles_skip_backups" = 1 ]; then
    if [ "$dotfiles_verbose" = 1 ]; then
      echo "[NOTICE] skipping backup of $1"
    fi
    return
  fi

  if [ ! -e $1 ]; then
    if [ "$dotfiles_verbose" = 1 ]; then
      echo "[NOTICE] $1 doesn't exist, no backup needed"
    fi
    return
  fi

  if [ ! -L $1 ]; then
    mv $1 $backup_filepath && echo "[NOTICE] Moved $1 to $backup_filepath"
  else
    echo "[NOTICE] Your old $backup_filename was a symlink, safely overwriting it"
  fi
}

###############################################
# symlink config files
###############################################

function dotfiles_symlink_cvsignore() {
  echo
  echo "== symlink .cvsignore =="
  dotfiles_backup ~/.cvsignore
  ln -fns ~/.dotfiles/.cvsignore ~/.cvsignore && echo "[SUCCESS] .cvsignore symlinked"
}

function dotfiles_symlink_tmuxconf() {
  echo
  echo "== symlink .tmux.conf =="
  dotfiles_backup ~/.tmux.conf
  ln -fns ~/.dotfiles/.tmux.conf ~/.tmux.conf && echo "[SUCCESS] .tmux.conf symlinked"
}

function dotfiles_symlink_powconfig() {
  echo
  echo "== symlink .powconfig =="
  dotfiles_backup ~/.powconfig
  ln -fns ~/.dotfiles/.powconfig ~/.powconfig && echo "[SUCCESS] .powconfig symlinked"
}

###############################################
# the following require git and github set up
###############################################

function dotfiles_clone() {
  echo
  echo "== cloning dotfiles repo =="
  git clone --recursive $GITHUB_URL/dotfiles.git ~/.dotfiles && echo "[SUCCESS] cloned dotfiles repo"
  git submodule update --init && echo "[SUCCESS] submodules updated"
}

function dotfiles_update() {
  echo
  echo "== updating dotfiles repo =="
  cd ~/.dotfiles && git pull && echo "[SUCCESS] updated dotfiles repo"
}

function dotfiles_submodule_update() {
  echo
  echo "== updating dotfiles repo =="
  cd ~/.dotfiles && {
    git submodule foreach git pull origin master # pull the master for each submodule
  } && echo "[SUCCESS] all submodules updated from master"
}

function dotfiles_symlink_zsh() {
  echo
  echo "== symlink zsh dotfiles =="
  dotfiles_backup ~/.zshrc
  dotfiles_backup ~/.zshenv

  ln -fns ~/.dotfiles/.zshrc ~/.zshrc && ln -fns ~/.dotfiles/.zshenv ~/.zshenv && {
    echo "[SUCCESS] Your new .zshrc and .zshenv are symlinks to ~/.dotfiles/.zsh*"
    echo "          Create .zshrc.local with any additional fpaths and .zshenv.local with"
    echo "          correct paths! There are a few stock configs in ~/.dotfiles/"
  }

  [ ! -f ~/.zshenv.local ] && {
    echo "source ~/.dotfiles/.zshenv.local.$OS" >> ~/.zshenv.local
    echo "[NOTICE] You didn't have a .zshenv.local file so one was created for"
    echo "          you. It just sources ~/.dotfiles/.zshenv.local.$OS for now."
  }

  [ ! -f ~/.zshrc.local ] && {
    echo "source ~/.dotfiles/.zshrc.local.$OS" >> ~/.zshrc.local
    echo "[NOTICE] You didn't have a .zshrc.local file so one was created for"
    echo "          you. It just sources ~/.dotfiles/.zshrc.local.$OS for now."
  }
}

function dotfiles_symlink_vim() {
  echo
  echo "== symlink .vim folder and vim dotfiles =="
  dotfiles_backup ~/.vim
  dotfiles_backup ~/.vimrc
  dotfiles_backup ~/.gvimrc

  ln -fns ~/.dotfiles/vim ~/.vim && echo "[SUCCESS] Your ~/.vim folder is a symlink to ~/.dotfiles/vim"
  ln -fns ~/.dotfiles/.vimrc ~/.vimrc && echo "[SUCCESS] Your new .vimrc is a symlink to ~/.dotfiles/.vimrc"
  ln -fns ~/.dotfiles/.gvimrc ~/.gvimrc && echo "[SUCCESS] Your new .gvimrc is a symlink to ~/.dotfiles/.gvimrc"

  mkdir -p ~/.dotfiles/vim/_temp
  mkdir -p ~/.dotfiles/vim/_backup
  echo "[SUCCESS] Created backup and temp folders for vim"
}

function dotfiles_symlink_bin() {
  echo
  echo "== create ~/bin and symlink some scripts =="
  [ ! -d ~/bin ] && { mkdir ~/bin && echo "[SUCCESS] Created local bin folder" }
  for f in ~/.dotfiles/bin/*
  do
    BIN_NAME=$(basename $f)
    [ ! -f ~/bin/$BIN_NAME ] && ln -fns $f ~/bin/$BIN_NAME && echo "[SUCCESS] ~/bin/$BIN_NAME symlinked"
  done
}

function dotfiles_setup_osx() {
  echo
  echo "== set up OSX defaults =="
  . ~/.dotfiles/.osx && echo "[SUCCESS] OSX defaults written"
}

###############################################
# usage
###############################################

function dotfiles_usage() {
  echo "usage:                $dotfiles_scriptname [options] [setups]"
  echo
  echo "options:"
  echo "  -h | --help         show usage (you're looking at it)"
  echo "  -v | --version      show version info"
  echo "  --skip-dependency   don't check for dependencies"
  echo "  --skip-shell        don't check if zsh is the default shell"
  echo "  --skip-ssh          don't check for SSH keys"
  echo "  --read-only         don't check if github user is davidosomething"
  echo "  --no-backups        don't check if github user is davidosomething"
  echo "  --skip-checks       don't check for anything"
  echo "                        SKIPS ALL"
  echo "                        OVERRIDES ALL SKIPS"
  echo "                        ENABLES BACKUPS"
  echo "  --all               perform all install actions"
  echo "                        ASKS NO QUESTIONS"
  echo "                        OVERRIDES SETUPS"
  echo "  --update            perform NO install actions"
  echo "                        UPDATES REPO AND SUBMODULES"
  echo "                        ASKS NO QUESTIONS"
  echo "                        OVERRIDES SETUPS"
  echo
  echo "setups:"
  echo "  By specifying a setup you will run only the ones specified."
  echo "  Valid setups to run include:"
  echo "  bin, cvsignore, gitconfig, github, osx, pow, tmux, vim, zsh"
  echo
}

###############################################
# read parameters
###############################################

while [ "$1" != "" ]; do
  case $1 in
    -h | --help )         dotfiles_usage
                          exit 0
                          ;;
    -v | --version )      echo "davidosomething environment setup version 0.2"
                          exit 0
                          ;;
    -d | --debug )        dotfiles_debug=1
                          ;;
    --skip-dependency )   dotfiles_skip_check_dependency=1
                          ;;
    --skip-shell )        dotfiles_skip_check_shell=1
                          ;;
    --skip-ssh )          dotfiles_skip_check_ssh_keys=1
                          ;;
    --read-only )         dotfiles_skip_check_git_writable=1
                          ;;
    --no-backups )        dotfiles_skip_backups=1
                          ;;
    --skip-checks )       dotfiles_skip_checks=1
                          # see conditional section for skip-checks below
                          ;;
    --update )            dotfiles_update_only=1
                          # see conditional section for all below
                          ;;
    --all )               dotfiles_do_all=1
                          # see conditional section for all below
                          ;;
    bin )                 dotfiles_do_bin="y"
                          dotfiles_do_ask=0
                          ;;
    cvsignore )           dotfiles_do_cvsignore="y"
                          dotfiles_do_ask=0
                          ;;
    gitconfig )           dotfiles_do_gitconfig="y"
                          dotfiles_do_ask=0
                          ;;
    github )              dotfiles_do_github="y"
                          dotfiles_do_ask=0
                          ;;
    osx )                 dotfiles_do_osx="y"
                          dotfiles_do_ask=0
                          ;;
    pow )                 dotfiles_do_pow="y"
                          dotfiles_do_ask=0
                          ;;
    tmux )                dotfiles_do_tmux="y"
                          dotfiles_do_ask=0
                          ;;
    vim )                 dotfiles_do_vim="y"
                          dotfiles_do_ask=0
                          ;;
    zsh )                 dotfiles_do_zsh="y"
                          dotfiles_do_ask=0
                          ;;
    * )                   echo
                          echo "[ERROR] Invalid argument: $1"
                          dotfiles_usage
                          exit 1
  esac
  shift
done

# --skip-checks overrides all skip settings
# checks git writable
# enables backups
if [ "$dotfiles_skip_checks" = 1 ]; then
  dotfiles_skip_check_dependency=1
  dotfiles_skip_check_shell=1
  dotfiles_skip_check_ssh_keys=1
  dotfiles_skip_check_git_writable=1
  dotfiles_skip_backups=0
fi

# --all overrides all setups
if [ "$dotfiles_do_all" = 1 ]; then
  dotfiles_do_bin="y"
  dotfiles_do_cvsignore="y"
  dotfiles_do_github="y"
  dotfiles_do_gitconfig="y"
  if [ "$OS" = "osx" ]; then
    dotfiles_do_osx="y"
  fi
  dotfiles_do_pow="y"
  dotfiles_do_tmux="y"
  dotfiles_do_vim="y"
  dotfiles_do_zsh="y"
  dotfiles_do_ask=0
fi

# --all overrides all setups
if [ "$dotfiles_update_only" = 1 ]; then
  dotfiles_do_bin="n"
  dotfiles_do_cvsignore="n"
  dotfiles_do_github="n"
  dotfiles_do_gitconfig="n"
  dotfiles_do_osx="n"
  dotfiles_do_pow="n"
  dotfiles_do_tmux="n"
  dotfiles_do_vim="n"
  dotfiles_do_zsh="n"
  dotfiles_do_ask=0
fi

if [ "$dotfiles_debug" = 1 ]; then
  echo "os: $OS"
  echo "dotfiles_debug: $dotfiles_debug"
  echo "dotfiles_do_bin: $dotfiles_do_bin"
  echo "dotfiles_do_cvsignore: $dotfiles_do_cvsignore"
  echo "dotfiles_do_github: $dotfiles_do_github"
  echo "dotfiles_do_gitconfig: $dotfiles_do_gitconfig"
  echo "dotfiles_do_osx: $dotfiles_do_osx"
  echo "dotfiles_do_pow: $dotfiles_do_pow"
  echo "dotfiles_do_tmux: $dotfiles_do_tmux"
  echo "dotfiles_do_vim: $dotfiles_do_vim"
  echo "dotfiles_do_zsh: $dotfiles_do_zsh"
  echo "dotfiles_do_ask: $dotfiles_do_ask"
  echo "dotfiles_do_all: $dotfiles_do_all"
  echo "dotfiles_skip_check_dependency: $dotfiles_skip_check_dependency"
  echo "dotfiles_skip_check_shell: $dotfiles_skip_check_shell"
  echo "dotfiles_skip_check_ssh_keys: $dotfiles_skip_check_ssh_keys"
  echo "dotfiles_skip_check_git_writable: $dotfiles_skip_check_git_writable"
  echo "dotfiles_skip_backups: $dotfiles_skip_backups"
  echo "dotfiles_skip_checks: $dotfiles_skip_checks"
  exit
fi

if [ "$dotfiles_skip_backups" != 1 ]; then
  mkdir -p ~/.dotfiles.old
fi


###############################################
# start doing shit here
###############################################

if [ "$dotfiles_skip_check_shell" != 1 ]; then
  dotfiles_switch_shell
else
  echo "[NOTICE] Skipping shell check"
fi
if [ "$dotfiles_skip_check_dependency" != 1 ]; then
  dotfiles_check_dependencies
else
  echo "[NOTICE] Skipping dependency checks"
fi
if [ "$dotfiles_skip_check_ssh_keys" != 1 ]; then
  dotfiles_setup_ssh_keys
else
  echo "[NOTICE] Skipping SSH key check"
fi
if [ "$dotfiles_do_ask" = 1 ]; then
  dotfiles_determine_steps
else
  echo "[NOTICE] Skipping action checks"
fi
if [ "$dotfiles_do_gitconfig:l" = "y" ]; then
  dotfiles_setup_git
else
  echo "[NOTICE] Skipping gitconfig setup"
fi
if [ "$dotfiles_do_github:l" = "y" ]; then
  dotfiles_setup_github
else
  echo "[NOTICE] Skipping github setup"
fi
if [ -d ~/.dotfiles ]; then
  echo "[NOTICE] folder ~/.dotfiles already exists, not cloning"
  dotfiles_update
  dotfiles_submodule_update
else
  if [ "$dotfiles_skip_check_git_writable" != 1 ]; then
    dotfiles_determine_github_write
  fi
  dotfiles_clone
fi

# vim and zsh use bin
[ "$dotfiles_do_bin:l"       = "y" ] && dotfiles_symlink_bin
[ "$dotfiles_do_vim:l"       = "y" ] && dotfiles_symlink_vim
[ "$dotfiles_do_cvsignore:l" = "y" ] && dotfiles_symlink_cvsignore
[ "$dotfiles_do_pow:l"       = "y" ] && dotfiles_symlink_powconfig
[ "$dotfiles_do_tmux:l"      = "y" ] && dotfiles_symlink_tmuxconf
# do this last since it modifies paths
[ "$dotfiles_do_zsh:l"       = "y" ] && dotfiles_symlink_zsh

[ "$dotfiles_do_osx:l" = "y" ] && dotfiles_setup_osx

echo
echo "[SUCCESS] ALL DONE!!!!!!11111"
