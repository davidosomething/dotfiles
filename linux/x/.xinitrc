#!/bin/bash
# .xinitrc / .xsession
# .xsession applies to XDM only -- useless for GDM/startx
#
# startx -> .xinitrc -> .xprofile
#
# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile

exec openbox-session

# vim: set ft=sh :