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

# Compositing
# Only use for openbox
# Consider moving out if using different compositor for other DEs
compton -b --config "$HOME/.config/compton.conf"

# Only for openbox since others might use gnome-settings-daemon or something
# Background Image
if [ -f "$HOME/.fehbg" ]; then
  "$HOME/.fehbg" &
else
  feh --bg-scale "$HOME/Dropbox/Public/03338_emptiness_1920x1080.jpg" &
fi

# Conky
# moved to .config/autostart/conky.desktop
#conky -d &

# Tint Panel
(sleep 2s && tint2 > /dev/null 2>&1) &
# Thinkpad specific battery icon using tp_smapi
# Starts on its own from /etc/xdg/autostart
#tp-battery-icon &

# My microphone status indicator
[[ -x "$HOME/src/indicator-audio-input/indicator-audio-input.py" ]] && \
  (sleep 3s && pushd "$HOME/src/indicator-audio-input" && \
  python2 "indicator-audio-input.py" && \
  popd) &

# USB disk mounting indicator
(sleep 3s && udiskie --tray) &

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
(sleep 3s && pnmixer) &

# Virtualbox applet
(sleep 3s && indicator-virtualbox) &

# Apps

# redshift-gtk starts itself
#(sleep 1s && redshift-gtk) &

# Start thunar daemon so it opens faster
# Removed it doesn't run as user
#thunar --daemon &

# moved to .config/autostart/terminator.desktop
#terminator &

# vim: set ft=sh :
