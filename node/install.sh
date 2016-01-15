#!/usr/bin/env bash

set -eu

# loop through packages.txt file and install each one
while read -r package; do
  npm ls --global --parseable --depth=0 "$package" || npm install --global "$package"
done < packages.txt

