#/usr/bin/env bash

#
# Get paths
#

./helpers.sh
./rbenv.sh
./symlink.sh

#
# Determine OS
#
case $OSTYPE in
  darwin*)  DOTFILES_OS="osx"
            status "Detected OSX"
            ;;
  linux*)   DOTFILES_OS="linux"
            status "Detected Linux"
            if [ -f /etc/debian_version ]; then
              DOTFILES_DISTRO="debian"
              status_ "Specifically debian"
              $DOTFILES_FOLDER/bootstrap/debian.sh
            fi
            ;;
  *)        die "Failed to detect operating system"
            ;;
esac
