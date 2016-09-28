#!/usr/bin/env bash

set -eu

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
  npm install --global npm@latest

  dko::status "Installing Yeoman"
  npm install --force --global yo

  dko::status "Checking npm environment"
  yo doctor || exit 1

  dko::status "Installing global node packages"
  # loop through packages.txt file and install each one
  while read -r package; do
    if [ "$package" != "yo" ]; then
      # npm ls --global --parseable --depth=0 "$package" ||
      npm install --force --global "$package"
    fi
  done < "${DOTFILES}/node/packages.txt"
}

__install
