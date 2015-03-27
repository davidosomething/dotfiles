#!/usr/bin/env bash

set -eu

git clone https://github.com/creationix/nvm.git ~/.nvm

# checkout latest tag
cd ~/.nvm
git checkout "$(git describe --abbrev=0 --tags)"

# install stable node and use as default
nvm install stable
nvm use stable
nvm alias default stable

