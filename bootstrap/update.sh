#!/usr/bin/env bash
set -eu

################################################################################
# Update dotfiles and provide instructions for updating the system
################################################################################

################################################################################
# initialize script and dependencies
# get this bootstrap folder
pushd "$(dirname $0)"/.. >> /dev/null
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh
popd >> /dev/null

################################################################################
# Begin
has_args=0
if [[ $# -eq 0 ]]; then
  dkousage "update [thing]"
  dkousage_ "thing is one of:"
  dkousage_ "  dotfiles"
  dkousage_ "  gem"
  dkousage_ "  heroku"
  dkousage_ "  npm"
  dkousage_ "  pip"
  dkousage_ "  vim"
  dkousage_ "  docker # osx only"
  dkousage_ "  osx    # osx only"
  dkousage_ "  brew   # osx only"
  dkousage_ "  rbenv  # linux only"
  dkousage_ "  wp-cli # linux only"
  exit 1
fi

################################################################################
case "$OSTYPE" in
  linux*)
    if [[ $OSTYPE = "linux-gnu" ]]; then
      if [[ "$1" = "wp" ]]; then
        dkostatus "Update wp-cli"
        pushd ~/.wp-cli &&
        php composer.phar self-update &&
        php composer.phar update --no-dev &&
        popd
      fi

      if [[ "$1" = "rbenv" ]]; then
        dkostatus "Update rbenv"
        rbenv update                  # update rbenv and installed gems
      fi
    fi
    ;;

  darwin*)
    if [[ "$1" = "docker" ]]; then
      dkostatus "Updating boot2docker"
      brew update
      brew upgrade docker
      brew upgrade boot2docker
      boot2docker stop
      boot2docker delete
      boot2docker download
      boot2docker init
      boot2docker up
    fi

    if [[ "$1" = "osx" ]]; then
      dkostatus "Repairing permissions"
      diskutil repairPermissions /  # fix file system permissions

      dkostatus "OSX system update"
      sudo softwareupdate -i -a
    fi

    if [[ "$1" = "brew" ]]; then
      dkostatus "Updating homebrew"
      brew update && brew upgrade && brew cleanup
    fi
  ;;
esac

################################################################################
# Common
if [[ "$1" = "dotfiles" ]]; then
  dkostatus "Updating dotfiles"
  # Make sure there are no untracked changes before updating dotfiles

  # Update dotfiles
  dkostatus_ "Jumping to dotfiles directory" && pushd $HOME/.dotfiles >> /dev/null
  dkostatus_ "Getting latest updates" && git pull --rebase --recurse-submodules && git submodule update
  updated_dotfiles=$?
  dkostatus_ "Back to original directory" && popd >> /dev/null
  if [[ $updated_dotfiles -ne 0 ]]; then
    dkodie "You have unsaved changes in your ~/.dotfiles folder."
  fi
fi

if [[ "$1" = "gem" ]]; then
  dkostatus "Updating gems"
  gem update --system && gem update && gem clean
fi

if [[ "$1" = "heroku" ]]; then
  heroku update
fi

if [[ "$1" = "npm" ]]; then
  dkostatus "Updating global npm modules"
  npm update npm -g
  npm update -g
fi

if [[ "$1" = "pip" ]]; then
  dkostatus "Updating pip"
  sudo easy_install -U pip
fi

if [[ "$1" = "vim" ]]; then
  dkostatus "Updating vim bundles"
  vim -N -u ~/.vimrc -c "try | \
    NeoBundleClean! | \
    NeoBundleUpdate! | \
    NeoBundleUpdatesLog $* | \
    finally | qall! | endtry" -U NONE -i NONE -V1 -e -s
fi
