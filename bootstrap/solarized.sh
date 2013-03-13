#!/usr/bin/env bash
set -e

if [ -d "$HOME/src/solarized" ]; then
  status "Updating solarized repo"
  pushd $HOME/src/solarized
  git pull origin master
  popd
else
  status "Cloning solarized repo"
  mkdir -p $HOME/src
  git clone https://github.com/altercation/solarized.git $HOME/src/solarized
fi
