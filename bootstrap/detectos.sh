#!/usr/bin/env bash
#
# detect OS
# This step is skipped if OS flag was given

set -eu

################################################################################
# initialize script and dependencies
# get this bootstrap folder
cd "$(dirname $0)"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh

################################################################################
case $OSTYPE in
  darwin*)  export DOTFILES_OS="osx"
    case "$(sw_vers -productVersion)" in
              10.7*) export DOTFILES_DISTRO="lion"
                     ;;
              10.8*) export DOTFILES_DISTRO="mountainlion"
                     ;;
              10.9*) export DOTFILES_DISTRO="mavericks"
                     ;;
            esac
            ;;
  linux*)   export DOTFILES_OS="linux"
            if [[ -f "/etc/debian_version" ]]; then
              export DOTFILES_DISTRO="debian"
            fi
            if [[ -f "/etc/arch-release" ]]; then
              export DOTFILES_DISTRO="archlinux"
            fi
            ;;
  *)        dkodie "Failed to detect operating system"
            ;;
esac
dkostatus "Detected $DOTFILES_OS $DOTFILES_DISTRO"
