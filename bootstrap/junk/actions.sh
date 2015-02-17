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
  echo "  bash, cvsignore, gitconfig, github, osx, pow, vim, zsh"
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

[ "$dotfiles_do_vim:l" = "y" ] && dotfiles_symlink_vim
[[ "$dotfiles_do_vim:l" = "y" || "$dotfiles_update_only" = "1" ]] && dotfiles_update_vim

# do this last since it modifies paths
[ "$dotfiles_do_bash:l" = "y" ] && dotfiles_symlink_bash
[ "$dotfiles_do_zsh:l"  = "y" ] && dotfiles_symlink_zsh

[ "$dotfiles_do_osx:l" = "y" ] && dotfiles_setup_osx

status "ALL DONE"
