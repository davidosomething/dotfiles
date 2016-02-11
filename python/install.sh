#!/usr/bin/env bash

set -eu
if [ -z "$DOTFILES" ]; then exit 1; fi
source "${DOTFILES}/bootstrap/helpers.sh"

dkostatus "Updating global pip requirements"
pip install --upgrade --requirement "${DOTFILES}/python/requirements.txt"

