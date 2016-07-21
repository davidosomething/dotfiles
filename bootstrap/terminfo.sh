#!/usr/bin/env bash
#
# Copy compiled terminfo files
#

# errors are okay.
#set -eu

# ============================================================================
# initialize script and dependencies
# ============================================================================

cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
source "${dotfiles_path}/shell/helpers.sh"

# ==============================================================================
# Main
# ==============================================================================

dko::status "Copying terminfo files"

# RXVT
mkdir -p "${HOME}/.terminfo/r"
[ -d "${dotfiles_path}/terminfo/r" ] && \
  cp -R "${dotfiles_path}/terminfo/r" "${HOME}/.terminfo/r/"

# tmux
mkdir -p "${HOME}/.terminfo/t"
[ -d "${dotfiles_path}/terminfo/t" ] && \
  cp -R "${dotfiles_path}/terminfo/t" "${HOME}/.terminfo/t/"

# Install all uncompiled terminfo files
# xterm-256color-italic for iterm2
find "${dotfiles_path}/terminfo/" -name '*.terminfo' -exec tic -x {} \;

# xterm-termite
tic -x "${dotfiles_path}/termite/termite.terminfo"

