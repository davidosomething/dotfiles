#
# Make sure repo was cloned with submodules
# e.g. zshcompletion and vundle for vim
#
status "Updating dotfiles submodules"
pushd $DOTFILES_FOLDER
git submodule update --init
popd
