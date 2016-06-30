#!/usr/bin/env bash
set -eu

# Symlink X11 settings

# initialize script and dependencies -------------------------------------------
# get this bootstrap folder
cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
readonly bootstrap_path="${dotfiles_path}/bootstrap"
source "${bootstrap_path}/helpers.sh"

# begin ------------------------------------------------------------------------
dko::status "Symlinking X11 dotfiles"
# this probably isn't sourced by your session
dko::symlink linux/.xinitrc       .xinitrc
dko::symlink linux/.xbindkeysrc   .xbindkeysrc
dko::symlink linux/.xprofile      .xprofile

