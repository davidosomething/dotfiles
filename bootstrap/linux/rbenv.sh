#!/usr/bin/env bash
#
# Install rbenv using script
# Only used for linux -- osx should use brew install rbenv

set -eu

################################################################################
# initialize script and dependencies
# get this bootstrap folder
cd "$(dirname $0)"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh

################################################################################
# TODO make this work again
# dkorequire "rbenv"
if [[ $(! which rbenv >/dev/null) ]]; then
  dkoinstalling "rbenv"
  curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
else
  dkostatus "rbenv found"
fi
