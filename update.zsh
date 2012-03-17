#!/bin/zsh

echo "==== Updating dotfiles, zsh, and vim ===="
pushd ~/.dotfiles
git pull
git submodule update --init --quiet
popd

echo "[SUCCESS] ALL DONE!!!!!!!!11"
