#!/usr/bin/env bash
set -eu

# Copy compiled terminfo files

# initialize script and dependencies -------------------------------------------
# get this bootstrap folder
cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
readonly bootstrap_path="${dotfiles_path}/bootstrap"
source "${bootstrap_path}/helpers.sh"

# begin ------------------------------------------------------------------------
dkostatus "Copying terminfo files"
dkosymlink  terminfo              .terminfo
tic -x "${dotfiles_path}/termite/termite.terminfo"

