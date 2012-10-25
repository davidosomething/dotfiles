# status is in helpers.sh
# symlink is in symlink.sh
status "Symlinking vim dotfiles and .vim folder"
symlink vim                 .vim
symlink vim/vimrc           .vimrc
symlink vim/gvimrc          .gvimrc
status "Getting vim bundles"
vim +BundleInstall +qall
