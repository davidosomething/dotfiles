# shell/x11.sh
#
# X11 Settings
# sourced by shell/before, uses shell/functions
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/x11.sh"

# ============================================================================
# Merge .Xresources
# ============================================================================

# On ArchLinux, GDM sources the user .Xresources with `-nocpp` so none of the
# includes are processed. Do a real load here (and leave /etc/gdm/Xsession
# alone).
# Setting $XENVIRONMENT is an option, but the -I flag here is more useful.
# This also lets me keep .Xresources out of ~/
[[ "$DOTFILES_OS" == "Linux" ]] && dko::has "xrdb" && \
  xrdb -merge -I"$DOTFILES" "${DOTFILES}/xresources/.Xresources"

# vim: ft=sh :
