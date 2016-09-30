#!/usr/bin/env bash

set -e

# =============================================================================
# Require DOTFILES
# =============================================================================

if [ -z "$DOTFILES" ]; then
  echo ".dotfiles repo is not set up"
  exit 1
fi
source "${DOTFILES}/shell/helpers.sh"

# =============================================================================
# Main
# =============================================================================

# @TODO check for nvm node
__install() {
  dko::status "Installing latest NPM"
  npm install --global --production npm@latest

  dko::status "Installing Yeoman"
  npm install --global --production yo

  dko::status "Checking npm environment using yo doctor"
  yo doctor || exit 1

  dko::status "Installing global node packages"
  # peer dep packages
  npm install --global --production eslint

  # loop through packages.txt file and install each one
  while read -r package; do
    if [ "$package" != "yo" ] \
      && [ "$package" != "eslint" ]; then
      # npm ls --global --parseable --depth=0 "$package" ||
      npm install --global --production "$package"
    fi
  done < "${DOTFILES}/node/packages.txt"
}

__install "$@"
