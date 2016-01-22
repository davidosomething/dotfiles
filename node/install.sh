#!/usr/bin/env bash

set -eu

npm install --force --global yo
yo doctor || exit 1

# loop through packages.txt file and install each one
while read -r package; do
  if [ "$package" != "yo" ]; then
    # npm ls --global --parseable --depth=0 "$package" ||
    npm install --force --global "$package"
  fi
done < packages.txt

