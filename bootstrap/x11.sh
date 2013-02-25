#!/usr/env/bin bash
set -e

status "Symlinking X11 dotfiles"
symlink x/Xresources        .Xresources
symlink x/xinitrc           .xinitrc
symlink x/xinitrc           .xsession
symlink x/xinitrc           .xprofile

status "Merging Xresources"
xrdb -merge $HOME/.Xresources
if [ -d "$HOME/src/solarized" ]; then
  status_ "and Solarized colors for terminal"
  xrdb -merge $HOME/src/solarized/xresources-colors-solarized/Xresources
fi
