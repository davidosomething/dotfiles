#!/usr/bin/env bash
#
# detect OS
# This step is skipped if OS flag was given
#

set -e

case $OSTYPE in
  darwin*)  export DOTFILES_OS="osx"
    case "$(sw_vers -productVersion)" in
              10.7*) export DOTFILES_DISTRO="lion"
                     ;;
              10.8*) export DOTFILES_DISTRO="mountainlion"
                     ;;
            esac
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
