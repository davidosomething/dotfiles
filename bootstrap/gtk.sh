#!/usr/bin/env bash
set -eu

# Symlink GTK config

# initialize script and dependencies -------------------------------------------
# get this bootstrap folder
cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
readonly bootstrap_path="${dotfiles_path}/bootstrap"
source "${bootstrap_path}/helpers.sh"

# begin ------------------------------------------------------------------------
dkostatus "COPYING ~/.config/gtk-3.0"
if [ -d "${XDG_CONFIG_HOME}/gtk-3.0" ]; then
  mv "${XDG_CONFIG_HOME}/gtk-3.0" "${XDG_CONFIG_HOME}/gtk-3.0.old"
fi
cp  -R  "${dotfiles_path}/linux/gtk-3.0"  "${XDG_CONFIG_HOME}/"
