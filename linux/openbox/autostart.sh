#!/usr/bin/env bash

# openbox autostart.sh
#
# environment -> autostart.sh
#
# Check ~/.config/autostart/ and /etc/xdg/autostart/ for other places programs
# might be starting from


export DKOSOURCE="$DKOSOURCE -> ob autostart"

# Keymaps
# GDM reads .Xmodmap -- don't do this, stalls everything for a few secs
#xmodmap "$HOME/src/davidosomething-config/potatoW510/.Xmodmap" &
if ! pgrep xbindkeys; then
  xbindkeys &
fi

# Only for openbox since others might use gnome-settings-daemon or something
# Background Image
if [ -f "$HOME/.fehbg" ]; then
  "$HOME/.fehbg" &
else
  feh --bg-scale "$HOME/Dropbox/Public/03338_emptiness_1920x1080.jpg" &
fi

# Tint Panel
(sleep 1s && tint2 -c "$HOME/.config/tint2/tint2rc") &
# Thinkpad specific battery icon using tp_smapi
# Starts on its own from /etc/xdg/autostart
#tp-battery-icon &

# My microphone status indicator
[[ -x "$HOME/src/indicator-audio-input/indicator-audio-input.py" ]] && \
  (sleep 1s && pushd "$HOME/src/indicator-audio-input" && \
  python2 "indicator-audio-input.py" && \
  popd) &

# USB disk mounting indicator
(sleep 1s && udiskie --tray) &

# Conky
(sleep 1s && conky -d) &

# Start Thinkpad OSD daemon
if [ -x /usr/bin/tpb ] && [ -w /dev/nvram ] && [ -r /dev/nvram ]; then
  /usr/bin/tpb -d &
fi

# Launcher
# using xdg autostart
#(sleep 1s && synapse --startup) &

# Clipboard manager
# using xdg autostart
#(sleep 1s && parcellite -d) &

# Volume applet
(sleep 2s && pnmixer) &

# Virtualbox applet
(sleep 2s && indicator-virtualbox) &

# Apps

# redshift-gtk starts itself
#(sleep 1s && redshift-gtk) &

# Start thunar daemon so it opens faster
# Removed it doesn't run as user
#thunar --daemon &

(sleep 1s && terminator) &

# vim: set ft=sh :
