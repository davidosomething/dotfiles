#!/bin/bash

set -eu
if [ -z "$DOTFILES" ]; then exit 1; fi
source "${DOTFILES}/bootstrap/helpers.sh"

dko::status "Cleaning up gems with broken names"
gem uninstall scss-lint

# loop through default-gems file and install each one
dko::status "Installing default gems"
while read -r gemname; do gem install "$gemname"; done < default-gems

