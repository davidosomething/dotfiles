#/usr/bin/env bash

set -e

#
# Get paths
#
DOTFILES_BOOTSTRAP_FOLDER=`dirname $0`
cd $DOTFILES_BOOTSTRAP_FOLDER
export DOTFILES_BOOTSTRAP_FOLDER=`pwd`
export DOTFILES_FOLDER=`dirname $DOTFILES_BOOTSTRAP_FOLDER`

# @TODO self-update? -- bash < <(curl -s https://github.com/ohrite/eyelet/raw/master/install)

#
# Make sure repo was cloned with submodules
#
pushd $DOTFILES_FOLDER
git submodule update --init
popd

source $DOTFILES_BOOTSTRAP_FOLDER/helpers.sh
source $DOTFILES_BOOTSTRAP_FOLDER/update.sh
source $DOTFILES_BOOTSTRAP_FOLDER/rbenv.sh
source $DOTFILES_BOOTSTRAP_FOLDER/solarized.sh
source $DOTFILES_BOOTSTRAP_FOLDER/symlink.sh

#
# Determine OS
#
case $OSTYPE in
  darwin*)  export DOTFILES_OS="osx"
            ;;
  linux*)   export DOTFILES_OS="linux"
            if [ -f /etc/debian_version ]; then
              export DOTFILES_DISTRO="debian"
            fi
            if [ -f /etc/arch-release ]; then
              export DOTFILES_DISTRO="archlinux"
            fi
            ;;
  *)        die "Failed to detect operating system"
            ;;
esac

status "Detected $DOTFILES_OS"

if [ "$DOTFILES_DISTRO" != "" ]; then
  status_ "Specifically $DOTFILES_DISTRO"
  if [ -f $DOTFILES_BOOTSTRAP_FOLDER/$DOTFILES_DISTRO.sh ]; then
    status "Installing dependencies for $DOTFILES_DISTRO"
    source $DOTFILES_BOOTSTRAP_FOLDER/$DOTFILES_DISTRO.sh
  fi
fi

source $DOTFILES_BOOTSTRAP_FOLDER/vim.sh

if [ "$DISPLAY" != "" ]; then
  source $DOTFILES_BOOTSTRAP_FOLDER/x11.sh
fi
