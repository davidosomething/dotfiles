#!/usr/bin/env bash

while getopts ":a" opt; do
  case $opt in
    a)
      echo "-a was triggered!" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

exit

# save OS name
case $OSTYPE in
  darwin*)  dotfiles_local_suffix="osx"
            ;;
  linux*)   dotfiles_local_suffix="linux"
            ;;
esac

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

###############################################
# the following require git and github set up
###############################################

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
  echo "  gitconfig, github, osx"
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
    gitconfig )           dotfiles_do_gitconfig="y"
                          dotfiles_do_ask=0
                          ;;
    github )              dotfiles_do_github="y"
                          dotfiles_do_ask=0
                          ;;
    osx )                 dotfiles_do_osx="y"
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
  dotfiles_do_github="y"
  dotfiles_do_gitconfig="y"
  if [ "$dotfiles_local_suffix" = "osx" ]; then
    dotfiles_do_osx="y"
  fi
  dotfiles_do_ask=0
fi

# --all overrides all setups
if [ "$dotfiles_update_only" = 1 ]; then
  dotfiles_do_github="n"
  dotfiles_do_gitconfig="n"
  dotfiles_do_osx="n"
  dotfiles_do_ask=0
fi

if [ "$dotfiles_debug" = 1 ]; then
  echo "OSTYPE: $OSTYPE"
  echo "os: $dotfiles_local_suffix"
  echo "dotfiles_debug: $dotfiles_debug"
  echo "dotfiles_do_github: $dotfiles_do_github"
  echo "dotfiles_do_gitconfig: $dotfiles_do_gitconfig"
  echo "dotfiles_do_osx: $dotfiles_do_osx"
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
if [ -d ~/.dotfiles ]; then
  status "folder ~/.dotfiles already exists, not cloning"
  dotfiles_update
fi

[ "$dotfiles_do_osx:l" = "y" ] && dotfiles_setup_osx

status "ALL DONE"
