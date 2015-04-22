#!/bin/bash
# .xinitrc / .xsession
# .xsession applies to XDM only -- useless for GDM/startx
#
# Probably don't need to add anything here -- add to .xprofile instead
#
# startx -> .xinitrc -> .xprofile

export DKOSOURCE="$DKOSOURCE -> .xinitrc"

# from skeleton
# GDM's Xsession runs this too
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Make sure this is before the 'exec' command or it won't be sourced.
[ -f ~/.xprofile ] && ~/.xprofile

_start_session() {
  session=${1:-openbox}
  case $session in
      awesome           ) exec awesome;;
      bspwm             ) exec bspwm;;
      catwm             ) exec catwm;;
      cinnamon          ) exec cinnamon-session;;
      dwm               ) exec dwm;;
      enlightenment     ) exec enlightenment_start;;
      ede               ) exec startede;;
      fluxbox           ) exec startfluxbox;;
      gnome             ) exec gnome-session;;
      gnome-classic     ) exec gnome-session --session=gnome-classic;;
      i3|i3wm           ) exec i3;;
      icewm             ) exec icewm-session;;
      jwm               ) exec jwm;;
      kde               ) exec startkde;;
      mate              ) exec mate-session;;
      monster|monsterwm ) exec monsterwm;;
      notion            ) exec notion;;
      openbox           ) exec openbox-session;;
      unity             ) exec unity;;
      xfce|xfce4        ) exec startxfce4;;
      xmonad            ) exec xmonad;;
      # No known session, try to run it as command
      *) exec "$1";;
  esac
}

_start_session "$@"

# vim: set ft=sh :