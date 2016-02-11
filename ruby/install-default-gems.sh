#!/bin/bash

set -eu
if [ -z "$DOTFILES" ]; then exit 1; fi
source "${DOTFILES}/bootstrap/helpers.sh"

dkostatus "Cleaning up gems with broken names"
gem uninstall scss-lint

# loop through default-gems file and install each one
dkostatus "Installing default gems"
while read gemname; do gem install "$gemname"; done < default-gems

