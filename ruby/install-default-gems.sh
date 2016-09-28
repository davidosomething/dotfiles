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

__install() {
  # @TODO check for chruby

  dko::status "Cleaning up gems with broken names"
  gem uninstall scss-lint

  # loop through default-gems file and install each one
  dko::status "Installing default gems"
  while read -r gemname; do
    gem install "$gemname"
  done < "${DOTFILES}/ruby/default-gems"
}

__install

