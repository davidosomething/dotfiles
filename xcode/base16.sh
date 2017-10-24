#!/usr/bin/env bash

set -e

mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes
cd -- ~/Library/Developer/Xcode/UserData/FontAndColorThemes || exit 1
git clone https://github.com/joedynamite/base16-xcode Base16
ln -s -- Base16/* ./
