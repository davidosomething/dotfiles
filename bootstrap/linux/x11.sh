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
dkosymlink x/Xresources        .Xresources
dkosymlink x/xinitrc           .xinitrc
dkosymlink x/xinitrc           .xsession
dkosymlink x/xinitrc           .xprofile

dkostatus "Merging Xresources"
xrdb -merge $HOME/.Xresources

if [[ -d "$dotfiles_path/solarized" ]]; then
  dkostatus_ "and Solarized colors for terminal"
  xrdb -merge $dotfiles_path/solarized/xresources-colors-solarized/Xresources
else
  dkoerror_ "Your dotfiles repo is missing the solarized submodule. Skipping."
fi
