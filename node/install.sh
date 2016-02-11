#!/usr/bin/env bash

set -eu
if [ -z "$DOTFILES" ]; then exit 1; fi
source "${DOTFILES}/bootstrap/helpers.sh"

dkostatus "Installing Yeoman"
npm install --force --global yo

dkostatus "Checking npm environment"
yo doctor || exit 1

dkostatus "Installing global node packages"
# loop through packages.txt file and install each one
while read -r package; do
  if [ "$package" != "yo" ]; then
    # npm ls --global --parseable --depth=0 "$package" ||
    npm install --force --global "$package"
  fi
done < packages.txt

