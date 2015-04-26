#!/bin/bash
# .xinitrc / .xsession
# (.xsession applies to XDM only -- useless for GDM/startx)
#
# Probably don't need to add anything here -- add to .xprofile instead
#
# startx ONLY -> .xinitrc -> .xprofile

export DKOSOURCE="$DKOSOURCE -> .xinitrc"

# Copied from /etc/X11/xinitrc -------------------------------------------------
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
[ -f $sysresources ]    && xrdb -merge $sysresources
[ -f $sysmodmap ]       && xmodmap $sysmodmap
[ -f "$userresources" ] && xrdb -merge "$userresources"
[ -f "$usermodmap" ]    && xmodmap "$usermodmap"
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Begin custom -----------------------------------------------------------------

# In default X, use left_ptr instead of X cursor
xsetroot -cursor_name left_ptr

# Make sure this is before the 'exec' command or it won't be sourced.
[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

_start_session() {
  session=${1:-openbox}
  case $session in
      awesome           ) exec awesome;;
      bspwm             ) exec bspwm;;
      cinnamon          ) exec cinnamon-session;;
      dwm               ) exec dwm;;
      enlightenment     ) exec enlightenment_start;;
      gnome             ) exec gnome-session;;
      gnome-classic     ) exec env GNOME_SHELL_SESSION_MODE=classic gnome-session --session gnome-classic;;
      i3|i3wm           ) exec i3;;
      kde               ) exec startkde;;
      mate              ) exec mate-session;;
      openbox           ) exec openbox-session;;
      unity             ) exec unity;;
      xfce|xfce4        ) exec startxfce4;;
      # No known session, try to run it as command
      *) exec "$1";;
  esac
}

_start_session "$@"

# vim: set ft=sh :