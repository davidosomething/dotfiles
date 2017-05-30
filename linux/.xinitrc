# linux/.xinitrc

# (also serves as .xsession which applies to XDM only -- useless for
# GDM/startx)
# Probably don't need to add anything here -- add to .xprofile instead
#
# startx ONLY -> .xinitrc -> .xprofile
#

DKO_SOURCE="${DKO_SOURCE} -> .xinitrc {"

# ============================================================================
# Copied from /etc/X11/xinitrc
# ============================================================================

usermodmap="${HOME}/.Xmodmap"
sysmodmap=/etc/X11/xinit/.Xmodmap
userresources="${HOME}/.Xresources"
sysresources=/etc/X11/xinit/.Xresources
[ -f "$sysmodmap" ]       && xmodmap "$sysmodmap"
[ -f "$usermodmap" ]      && xmodmap "$usermodmap"
[ -f "$sysresources" ]    && xrdb -merge "$sysresources"
[ -f "$userresources" ]   && xrdb -merge "$userresources"

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && source "$f"
  done
  unset f
fi

# ============================================================================
# Begin custom xinit
# ============================================================================

# xdg-user-dirs-gtk-update will update gtk app user dirs -- run after
# xdg-user-dirs are set (done in /etc/X11/xinit/xinitrc.d/xdg-user-dirs)
xdg-user-dirs-gtk-update &
# linux/.xprofile will source the dirs later

# In default X, use left_ptr instead of X cursor
xsetroot -cursor_name left_ptr

# Make sure this is before the 'exec' command or it won't be sourced.
[ -f "${HOME}/.xprofile" ] && source "${HOME}/.xprofile"

export DKO_SOURCE="${DKO_SOURCE} }"

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

# vim: ft=sh :
