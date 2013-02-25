#!/usr/env/bin bash
set -e

#
# Make sure repo was cloned with submodules
# e.g. zshcompletion and vundle for vim
#
status "Updating dotfiles submodules"
pushd $DOTFILES_FOLDER
git submodule init
git submodule foreach git fetch --tags
git submodule update
popd
