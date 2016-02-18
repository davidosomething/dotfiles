#!/usr/bin/env bash
set -eu

# Symlink termite config

# initialize script and dependencies -------------------------------------------
# get this bootstrap folder
cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
readonly bootstrap_path="${dotfiles_path}/bootstrap"
source "${bootstrap_path}/helpers.sh"

# begin ------------------------------------------------------------------------
dkostatus "Symlinking termite config"
dkosymlink termite/config       .config/termite/config

dkostatus "Installing terminfo"
tic -x "${dotfiles_path}/termite/termite.terminfo"
