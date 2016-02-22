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

# RXVT
mkdir -p "${HOME}/.terminfo/r"
[ -d "${dotfiles_path}/terminfo/r" ] && \
  cp  "${dotfiles_path}/terminfo/r"/*  "${HOME}/.terminfo/r/"

# tmux
mkdir -p "${HOME}/.terminfo/t"
[ -d "${dotfiles_path}/terminfo/t" ] && \
  cp  "${dotfiles_path}/terminfo/t"/*  "${HOME}/.terminfo/t/"

# xterm-256color-italic for iterm2
tic -x "${dotfiles_path}/terminfo/xterm-256color-italic.terminfo"

