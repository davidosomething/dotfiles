#!/usr/bin/env bash
#
# Symlink X11 settings
#

set -eu

# ============================================================================
# initialize script and dependencies
# ============================================================================

cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
source "${dotfiles_path}/shell/helpers.sh"

# ==============================================================================
# Main
# ==============================================================================

dko::status "Symlinking X11 dotfiles"
# this probably isn't sourced by your session
dko::symlink linux/.xinitrc       .xinitrc
dko::symlink linux/.xbindkeysrc   .xbindkeysrc
dko::symlink linux/.xprofile      .xprofile

