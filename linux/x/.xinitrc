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

exec openbox-session

# vim: set ft=sh :