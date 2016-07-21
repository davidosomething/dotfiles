#!/usr/bin/env bash
#
# Symlink GTK config
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

dko::status "COPYING ~/.config/gtk-3.0"
if [ -d "${XDG_CONFIG_HOME}/gtk-3.0" ]; then
  mv "${XDG_CONFIG_HOME}/gtk-3.0" "${XDG_CONFIG_HOME}/gtk-3.0.old"
fi
cp  -R  "${dotfiles_path}/linux/gtk-3.0"  "${XDG_CONFIG_HOME}/"
