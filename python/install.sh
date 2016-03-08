#!/usr/bin/env bash

set -eu
if [ -z "$DOTFILES" ]; then
  echo ".dotfiles repo is not set up"
  exit 1
fi
source "${DOTFILES}/bootstrap/helpers.sh"

if pip --version | grep -q /usr/lib; then
  dkoerr "System pip detected, not running."
  dkoerr_ "Set up a global pyenv instead."
  exit 1
fi

dkostatus "Updating global pip"
pip install --upgrade pip

dkostatus "Updating global pip requirements"
pip install --upgrade --requirement "${DOTFILES}/python/requirements.txt"

