#/usr/bin/env bash

set -e

#
# @TODO read flags and args
# [-o|--os] [darwin|osx|archlinux|debian]   set OS and distro
# --vim                                     do vim only
# [-u|--update] [all|self|vim]              update self, submodules, and vim

#
# Get paths
#
DOTFILES_BOOTSTRAP_FOLDER=`dirname $0`
cd $DOTFILES_BOOTSTRAP_FOLDER
export DOTFILES_BOOTSTRAP_FOLDER=`pwd`
export DOTFILES_FOLDER=`dirname $DOTFILES_BOOTSTRAP_FOLDER`

#
# helper output functions
#
source $DOTFILES_BOOTSTRAP_FOLDER/helpers.sh

# @TODO self-update? -- bash < <(curl -s https://github.com/ohrite/eyelet/raw/master/install)

#
# update/init dotfiles submodules
#
source $DOTFILES_BOOTSTRAP_FOLDER/update.sh

#
# download and install rbenv
# @TODO: move to OS specific since OSX can install via brew
#
source $DOTFILES_BOOTSTRAP_FOLDER/rbenv.sh

#
# clone solarized to $HOME/src
#
source $DOTFILES_BOOTSTRAP_FOLDER/solarized.sh

#
# symlink all dotfiles
#
source $DOTFILES_BOOTSTRAP_FOLDER/symlink.sh

#
# only detect OS if not forced
#
source $DOTFILES_BOOTSTRAP_FOLDER/detectos.sh

#
# OS and distro specific stuff
#
status "Performing actions for $DOTFILES_OS"
if [ "$DOTFILES_DISTRO" != "" ]; then
  status_ "OS distro is $DOTFILES_DISTRO"
  if [ -f $DOTFILES_BOOTSTRAP_FOLDER/$DOTFILES_DISTRO.sh ]; then
    status "Installing dependencies for $DOTFILES_DISTRO"
    source $DOTFILES_BOOTSTRAP_FOLDER/$DOTFILES_DISTRO.sh
  fi
fi

status Dependencies should be installed at this point

#
# setup vim and vundle
#
source $DOTFILES_BOOTSTRAP_FOLDER/vim.sh

#
# setup X11 if needed
#
if [ "$DISPLAY" != "" ]; then
  source $DOTFILES_BOOTSTRAP_FOLDER/x11.sh
fi
