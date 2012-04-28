#!/usr/bin/env bash
# using zsh as scripting lang, only runs if zsh is available

# helpers from http://serverwizard.heroku.com/script/
status()     { echo -e "\033[0;34m==>\033[0;32m $*\033[0;m"; }
status_()    { echo -e "\033[0;32m    $*\033[0;m"; }
err()        { echo -e "\033[0;31m==> \033[0;33mERROR: \033[0;31m$*\033[0;m"; }
err_()       { echo -e "\033[0;31m    $*\033[0;m"; }

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
dotfiles_do_cvsignore="n"
dotfiles_do_gitconfig="n"
dotfiles_do_github="n"
dotfiles_do_pow="n"
dotfiles_do_tmux="n"
dotfiles_do_vim="n"
dotfiles_do_bash="n"
dotfiles_do_zsh="n"
# only ask for these on OSX
dotfiles_do_homebrew="n"
dotfiles_do_brew="n"
dotfiles_do_osx="n"

# determine if you installed and are using the alias or are running using oneliner
if [ "$0" = "dotfiles" ]; then
  dotfiles_scriptname="dotfiles"
else
  dotfiles_scriptname="./bootstrap.zsh"
fi

# save OS name
case $OSTYPE in
  darwin*)  dotfiles_local_suffix="osx"
            ;;
  linux*)   dotfiles_local_suffix="linux"
            ;;
esac

# TODO check for XCode
function dotfiles_check_dependencies() {
  echo "== checking for dependencies =="
  function require {
    if ! which $1 >/dev/null 2>&1; then
      err "missing $1, please install before proceeding.";
      exit 1
    else
      status "found $1"
    fi
  }
  require "zsh"
  require "ssh-keygen"
  require "git"
}

function dotfiles_switch_shell() {
  if ! which $SHELL |grep zsh >/dev/null 2>&1; then
    status "You aren't using ZSH. ZSH is awesome."
    echo -n "Switch to zsh [y/N]? ";                      read dotfiles_do_switch_zsh;
    ###############################################
    # change shell
    ###############################################
    [ "$dotfiles_do_switch_zsh" = "y" ] && {
      echo "== changing shell =="
      chsh -s `which zsh` && status "user default shell changed to zsh"
      status  "using zsh at $(which zsh) -- fix your path if this is wrong!"
      exec $(which zsh)
    }
  else
    status "cool, you're using zsh"
  fi
}

function dotfiles_setup_ssh_keys() {
  if [ ! -e ~/.ssh/id_rsa.pub ]; then
    # from https://gist.github.com/1454081
    status "no ssh keys found for this user on this machine, required"
    mkdir ~/.ssh
    echo -n "Please enter your email to comment this SSH key: "; read email
    if [ "$email" != "" ]; then
      ssh-keygen -t rsa -C "$email"
      cat ~/.ssh/id_rsa.pub
      cat ~/.ssh/id_rsa.pub | pbcopy > /dev/null 2>&1
      status  "Your ssh public key is shown above and (copied to the clipboard on OSX)"
      status_ "Add it to GitHub if this computer needs push permission."
      status_ "When that's done, press [enter] to proceed."
      read
    else
      status "no email entered, skipping SSH key generation"
    fi
  else
    status "found SSH keys for this user"
  fi
}

##
# function is skipped if you specify --all or any setup name
function dotfiles_determine_steps() {
  status "begin install"
  echo "Say no to everything to just run an update (next time use --update)"
  # @TODO check for --all argument
  echo -n "Symlink .cvsignore (used by rsync) [y/N]? "; read dotfiles_do_cvsignore;
  echo -n "Symlink .tmux.conf [y/N]? ";                 read dotfiles_do_tmux;
  echo -n "Symlink .powconfig [y/N]? ";                 read dotfiles_do_pow;
  echo -n "Set up gitconfig [y/N]? ";                   read dotfiles_do_gitconfig;
  echo -n "Set up github [y/N]? ";                      read dotfiles_do_github;
  echo -n "Set up bash [y/N]? ";                        read dotfiles_do_bash;
  echo -n "Set up zsh [y/N]? ";                         read dotfiles_do_zsh;
  echo -n "Set up vim [y/N]? ";                         read dotfiles_do_vim;

  [ "$dotfiles_local_suffix" = 'osx' ] && {
    echo -n "Install Homebrew [y/N]? ";               read dotfiles_do_homebrew;
    echo -n "Brew recommended formulae [y/N]? ";      read dotfiles_do_brew;
    echo -n "Set up OSX Defaults [y/N]? ";            read dotfiles_do_osx;
  }
}

function dotfiles_setup_git() {
  echo "== setting up git == "
  echo "You can run this again if you mess up. Leave blank to skip username/email fields."
  echo -n "Please enter your full name: "; read fullname
  # in case we skipped the email in the ssh section
  if [ "$email" = "" ]; then
    echo -n "Please enter your email: "; read email;
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
  [ "$dotfiles_local_suffix" = "osx" ] && git config --global web.browser open

  # a couple aliases
  git config --global alias.b     branch
  git config --global alias.co    checkout
  git config --global alias.dc    "diff --cached"
  git config --global alias.st    "status -bs"
  git config --global alias.graph "log --graph --oneline"

  status "global .gitconfig generated/updated!"
}

function dotfiles_setup_github() {
  echo "== setting up github == "
  echo "You can run this again if you mess up. Leave blank to skip a field."
  echo -n "Please enter your github username:  "; read githubuser
  echo -n "Please enter your github api token: "; read githubtoken
  [ "$githubuser"  != '' ] && git config --global github.user "$githubuser"
  [ "$githubtoken" != '' ] && git config --global github.token "$githubtoken"
  status "global .gitconfig updated with github info"
}

function dotfiles_determine_github_write() {
  echo "== github configuration =="

  GITHUB_URL='git://github.com/davidosomething'

  echo "Checking for existing .gitconfig with github token..."
  if ! git config --global --get github.token >/dev/null 2>&1; then
    echo '[WARNING] missing github token, disabling write access to repositories.'
    echo '          This machine will not be able to push edits back to the repository!'
  elif [ "`git config --global --get github.user`" = "davidosomething" ]; then
    GITHUB_URL='git@github.com:davidosomething'
    status  "github token found and github user is davidosomething."
    status_ "If needed, your dotfiles will be cloned with write access."
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
      status "skipping backup of $1"
    fi
    return
  fi

  if [ ! -e $1 ]; then
    if [ "$dotfiles_verbose" = 1 ]; then
      status "$1 doesn't exist, no backup needed"
    fi
    return
  fi

  if [ ! -L $1 ]; then
    mv $1 $backup_filepath && status "Moved $1 to $backup_filepath"
  else
    status "Your old $backup_filename was a symlink, safely overwriting it"
  fi
}

###############################################
# symlink config files
###############################################

function dotfiles_symlink_cvsignore() {
  echo "== symlink .cvsignore =="
  dotfiles_backup ~/.cvsignore
  ln -fns ~/.dotfiles/.cvsignore ~/.cvsignore && status ".cvsignore symlinked"
}

function dotfiles_create_tmuxconf() {
  echo "== create .tmux.conf =="
  dotfiles_backup ~/.tmux.conf
  [ ! -f ~/.tmux.conf ] && {
    echo "source-file ~/.dotfiles/tmux/.tmux.conf" >> ~/.tmux.conf
    status  "You didn't have a .tmux.conf file so one was created for"
    status_ "you. It sources ~/.dotfiles/tmux/.tmux.conf."
    [ "$dotfiles_local_suffix" = "osx" ] && {
      echo "source-file ~/.dotfiles/tmux/osx" >> ~/.tmux.conf
      status "Your new ~/.tmux.conf file also includes ~/.dotfiles/tmux/osx"
    }
  }
}

function dotfiles_symlink_powconfig() {
  echo "== symlink .powconfig =="
  dotfiles_backup ~/.powconfig
  ln -fns ~/.dotfiles/.powconfig ~/.powconfig && status ".powconfig symlinked"
}

###############################################
# the following require git and github set up
###############################################

function dotfiles_clone() {
  git clone --recursive $GITHUB_URL/dotfiles.git ~/.dotfiles && status "cloned dotfiles repo"
}

function dotfiles_update() {
  echo "== updating dotfiles repo =="
  cd ~/.dotfiles && git checkout master && {
    status "Checked out master"
    git pull && status "Pulling latest dotfiles"
    git submodule update --init --recursive && status "Updating/init submodules"
    git checkout @{-1}                # go back to last branch or just fail
  } && status "Updated dotfiles repo"
}

function dotfiles_symlink_bash() {
  echo "== symlink bash dotfiles =="
  dotfiles_backup ~/.bashrc       && ln -fns ~/.dotfiles/bash/.bashrc ~/.bashrc             && status "Your .bashrc is a symlink to ~/.dotfiles/bash/.bashrc"
  dotfiles_backup ~/.bash_profile && ln -fns ~/.dotfiles/bash/.bash_profile ~/.bash_profile && status "Your .zshenv is a symlink to ~/.dotfiles/bash/.bash_profile"
}

function dotfiles_symlink_zsh() {
  echo "== symlink zsh dotfiles =="
  dotfiles_backup ~/.zshrc  && ln -fns ~/.dotfiles/zsh/.zshrc ~/.zshrc   && status "Your .zshrc is a symlink to ~/.dotfiles/zsh/.zshrc"
  dotfiles_backup ~/.zshenv && ln -fns ~/.dotfiles/zsh/.zshenv ~/.zshenv && status "Your .zshenv is a symlink to ~/.dotfiles/zsh/.zshenv"
  dotfiles_backup ~/.zlogin && ln -fns ~/.dotfiles/zsh/.zlogin ~/.zlogin && status "Your .zlogin is a symlink to ~/.dotfiles/zsh/.zlogin"

  [ ! -f ~/.zshenv.local ] && {
    echo "source ~/.dotfiles/.zshenv.local.$dotfiles_local_suffix" >> ~/.zshenv.local
    status "You didn't have a .zshenv.local file so one was created for you."
  }

  [ ! -f ~/.zshrc.local ] && {
    echo "source ~/.dotfiles/.zshrc.local.$dotfiles_local_suffix" >> ~/.zshrc.local
    status "You didn't have a .zshrc.local file so one was created for you."
  }
}

function dotfiles_symlink_vim() {
  echo "== symlink .vim folder and vim dotfiles =="
  dotfiles_backup ~/.vim    && ln -fns ~/.dotfiles/vim ~/.vim             && status "Your ~/.vim folder is a symlink to ~/.dotfiles/vim"
  dotfiles_backup ~/.vimrc  && ln -fns ~/.dotfiles/vim/.vimrc ~/.vimrc    && status "Your new .vimrc is a symlink to ~/.dotfiles/.vimrc"
  dotfiles_backup ~/.gvimrc && ln -fns ~/.dotfiles/vim/.gvimrc ~/.gvimrc  && status "Your new .gvimrc is a symlink to ~/.dotfiles/.gvimrc"

  mkdir -p ~/.dotfiles/vim/_temp && mkdir -p ~/.dotfiles/vim/_backup && status "Created backup and temp folders for vim"

  [ ! -d ~/.vim/bundle/vundle ] && {
    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle && status "Installed vundle for vim"
  }
}

function dotfiles_update_vim() {
  [ -d ~/.vim/bundle/vundle ] && {
    vim +BundleInstall +qall && status "Updated/Installed vim plugins"
  }
}

function dotfiles_setup_osx() {
  status "Set up OSX defaults"
  . ~/.dotfiles/.osx && status "OSX defaults written"
}

# TODO check for curl
# See https://github.com/37signals/pow/wiki/Installation
function dotfiles_install_pow() {
  status "Installing pow"
  curl get.pow.cx | sh
}

# TODO check for curl
# See https://rvm.io/
function dotfiles_install_rvm() {
  status "Installing rvm"
  curl -L get.rvm.io | bash -s stable
}

# See https://github.com/mxcl/homebrew/wiki/installation
function dotfiles_update_homebrew() {
  status "Updating homebrew"
  brew update
  brew upgrade
}

# See https://github.com/mxcl/homebrew/wiki/installation
function dotfiles_install_homebrew() {
  status "Installing homebrew"
  /usr/bin/ruby -e "$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
  # TODO check for homebrew
  brew doctor
}

# TODO check for homebrew
function dotfiles_brew_formulae() {
  echo "== Brewing Formulae =="
  brew install ack
  brew install git
  brew install imagemagick
  brew install imagesnap
  brew install jsl
  brew install jsmin
  brew install macvim --custom-icons --with-cscope --override-system-vim --with-lua
  brew install pngcrush
  brew install tmux

  brew linkapps
}

function dotfiles_brew_phpmyadmin() {
  brew install phpmyadmin
  pushd /usr/local/share/phpmyadmin
    cp config.sample.inc.php config.inc.php
  popd
  status  "Installed phpmyadmin"
  status  "You need to do the apache thing ('brew info phpmyadmin' for help),"
  status_ "and add a blowfish secret value to"
  status_ "/usr/local/share/phpmyadmin/config.inc.php"
}

function dotfiles_brew_php() {
  brew tap josegonzalez/php
  brew install php --with-mssql --with-imap --with-mysql
  brew install imagick-php
  status  "Installed php and imagick-php. You need to enable it in the apache"
  status_ "config file ('brew info php' for help)."
}

function dotfiles_brew_bash() {
  brew install bash
  brew install bash-completion
  status "Installed bash and bash-completion"
}

function dotfiles_brew_zsh() {
  brew install zsh
  status "Installed zsh"
}

function dotfiles_brew_mysql() {
  brew install mysql
  mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp

  mkdir -p ~/Library/LaunchAgents

  launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

  local installed_version="`mysql --version | awk '{print $5}' | sed s/,//`"
  cp /usr/local/Cellar/mysql/$installed_version/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/

  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
  status "Installed MySQL and set up as a service."
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
  echo "  -d | --debug        show debugging flags"
  echo "  -V | --vim-plugins  list directories under vim/bundle/"
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
  echo "  bash, cvsignore, gitconfig, github, osx, pow, tmux, vim, zsh"
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
    -V | --vim-plugins )  pushd ~/.dotfiles/vim/bundle && ls -d * && popd
                          exit 0
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
    bash )                dotfiles_do_bash="y"
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
                          err "Invalid argument: $1"
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
  dotfiles_do_bash="y"
  dotfiles_do_cvsignore="y"
  dotfiles_do_github="y"
  dotfiles_do_gitconfig="y"
  if [ "$dotfiles_local_suffix" = "osx" ]; then
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
  dotfiles_do_bash="n"
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
  echo "OSTYPE: $OSTYPE"
  echo "os: $dotfiles_local_suffix"
  echo "dotfiles_debug: $dotfiles_debug"
  echo "dotfiles_do_bash: $dotfiles_do_bash"
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
  status "Skipping shell check"
fi
if [ "$dotfiles_skip_check_dependency" != 1 ]; then
  dotfiles_check_dependencies
else
  status "Skipping dependency checks"
fi
if [ "$dotfiles_skip_check_ssh_keys" != 1 ]; then
  dotfiles_setup_ssh_keys
else
  status "Skipping SSH key check"
fi
if [ "$dotfiles_do_ask" = 1 ]; then
  dotfiles_determine_steps
else
  status "Skipping action checks"
fi
if [ "$dotfiles_do_gitconfig:l" = "y" ]; then
  dotfiles_setup_git
else
  status "Skipping gitconfig setup"
fi
if [ "$dotfiles_do_github:l" = "y" ]; then
  dotfiles_setup_github
else
  status "Skipping github setup"
fi

if [ -d ~/.dotfiles ]; then
  status "folder ~/.dotfiles already exists, not cloning"
  dotfiles_update
else
  if [ "$dotfiles_skip_check_git_writable" != 1 ]; then
    dotfiles_determine_github_write
  fi
  dotfiles_clone
fi

[ "$dotfiles_do_cvsignore:l" = "y" ] && dotfiles_symlink_cvsignore
[ "$dotfiles_do_pow:l"  = "y" ] && dotfiles_symlink_powconfig
[ "$dotfiles_do_tmux:l" = "y" ] && dotfiles_create_tmuxconf

[ "$dotfiles_do_vim:l" = "y" ] && dotfiles_symlink_vim
[[ "$dotfiles_do_vim:l" = "y" || "$dotfiles_update_only" = "1" ]] && dotfiles_update_vim

# do this last since it modifies paths
[ "$dotfiles_do_bash:l" = "y" ] && dotfiles_symlink_bash
[ "$dotfiles_do_zsh:l"  = "y" ] && dotfiles_symlink_zsh

[ "$dotfiles_do_osx:l" = "y" ] && dotfiles_setup_osx

status "ALL DONE"
