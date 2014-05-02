#!/usr/bin/env bash
#
# Symlink X11 settings

set -eu

################################################################################
# initialize script and dependencies
# get this bootstrap folder
cd "$(dirname $0)"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh

################################################################################
dkostatus "Symlinking X11 dotfiles"
#dkosymlink x/.xinitrc .xinitrc
dkosymlink x/.xprofile .xprofile
