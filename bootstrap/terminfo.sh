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
readonly local_terminfo_dir="${HOME}/.terminfo"
mkdir -p "$local_terminfo_dir"
rsync -a --include '*/' --include '*' \
  "${dotfiles_path}/" \
  "$local_terminfo_dir/"

