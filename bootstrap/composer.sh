#!/usr/bin/env bash

# Install or update composer

set -e

# initialize script and dependencies -------------------------------------------
# get this bootstrap folder
cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
readonly bootstrap_path="${dotfiles_path}/bootstrap"
source "${bootstrap_path}/helpers.sh"


_install_composer() {
  if [[ "$DOTFILES_OS" == "Darwin" ]]; then

    brew install composer

  elif [[ -f "/etc/arch-release" ]]; then

    pacaur -S php-composer
    rehash

  else

    export COMPOSER_HOME="${XDG_CONFIG_HOME}/composer"
    mkdir -p "${COMPOSER_HOME}/bin"
    curl -sS https://getcomposer.org/installer | php -- --install-dir="${COMPOSER_HOME}/bin"

  fi
}

_after_install() {
  dkostatus_ "You should remove open_basedir from php settings"
  dkostatus_ "Un-comment extension=phar.so"
  dkostatus_ "Un-comment extension=openssl.so"
}


_update() {
  composer_user="$(stat -c %U "$(which composer)")"
  if [ "$composer_user" = "root" ]; then
    sudo composer selfupdate
  else
    composer selfupdate
  fi
}


if ! has_program "composer"; then
  dkostatus "Installing composer..."
  _install_composer && _after_install && _update
else
  dkostatus "Composer already installed, updating..."
  _update
fi

