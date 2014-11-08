# .xsession
# Run on all X Sessions, regardless of DE used

# Keymaps
# GDM reads .Xmodmap -- don't do this, stalls everything for a few secs
#xmodmap "$HOME/src/davidosomething-config/potatoW510/.Xmodmap" &

# Start Thinkpad OSD daemon
if [ -x /usr/bin/tpb ] &&  [ -w /dev/nvram ] && [ -r /dev/nvram ]; then
  /usr/bin/tpb -d &
fi

# Launcher
# Can start on its own but I turned it off
#kupfer &
(sleep 1s && synapse --startup) &

# Clipboard manager
# Started in /etc/xdg/autostart
#(sleep 1s && parcellite -d) &

# Volume applet
pnmixer &

indicator-virtualbox &

# Apps
# Start thunar daemon so it opens faster
shutter --min_at_startup &
thunar --daemon &
(sleep 1s && gnome-terminal --hide-menubar) &
(sleep 1s && chromium) &

# vim: set ft=sh :
