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

# loop through default-gems file and output if not installed
__find_missing() {
  while read -r gemname; do
    gem list -i "$gemname" >/dev/null
    if [ "$?" != "0" ]; then
      echo "${gemname} not installed"
    fi
  done < default-gems
}

__find_missing
