#!/usr/bin/env bash

set -eu

if [ -z "$DOTFILES" ]; then
  echo ".dotfiles repo is not set up"
  exit 1
fi
source "${DOTFILES}/bootstrap/helpers.sh"

if ! has_program "pyenv"; then
  dkoerr  "pyenv is not installed. Install it and set up a global pyenv."
  exit 1
fi

# Make sure not using macOS internal python and pip
if pip --version | grep -q /usr/lib; then
  dkoerr  "System pip detected, not running. Use a userspace python's pip."
  exit 1
fi

dkostatus "Updating global pip"
pip install --upgrade pip

dkostatus "Updating global pip requirements"
pip install --upgrade --requirement "${DOTFILES}/python/requirements.txt"

