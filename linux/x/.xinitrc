#!/bin/bash
# .xinitrc / .xsession
# .xsession applies to XDM only -- useless for GDM/startx
#
# startx -> .xinitrc -> .xprofile
#
# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && /etc/xprofile
[ -f ~/.xprofile ] && ~/.xprofile

exec openbox-session

# vim: set ft=sh :