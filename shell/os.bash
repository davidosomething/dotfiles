# shell/os.bash
#
# os detection, default to Linux
# Sourced by shell/before since path needs to be set first (for brew in
# particular)
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/os.bash"

# @see https://github.com/nojhan/liquidprompt/blob/master/liquidprompt
case "$(uname -s)" in
    FreeBSD)   export DOTFILES_OS="FreeBSD" ;;
    OpenBSD)   export DOTFILES_OS="OpenBSD" ;;
    Darwin)    export DOTFILES_OS="Darwin"  ;;
    *)         export DOTFILES_OS="Linux"   ;;
esac

# ============================================================================
# mac OS/OS X
# ============================================================================

[ "$DOTFILES_OS" = "Darwin" ] && {
  export DOTFILES_DISTRO="mac"

  command -v "brew" >/dev/null 2>&1 && {
    BREW_PREFIX="$(brew --prefix)"
    export BREW_PREFIX
  }
}

# ============================================================================
# Linux
# ============================================================================

[ "$DOTFILES_OS" = "Linux" ] && {
  [ -f "/etc/debian_version" ] && export DOTFILES_DISTRO="debian"

  # ----------------------------------------------------------------------
  # Arch Linux
  # ----------------------------------------------------------------------

  [ -f "/etc/arch-release" ] && {
    export DOTFILES_DISTRO="archlinux"

    # for pacdiff
    export DIFFPROG="nvim -d"

    # for arch wiki lite
    export wiki_browser="chromium"

    # On ArchLinux, GDM sources the user .Xresources with `-nocpp` so none of the
    # includes are processed. Do a real load here (and leave /etc/gdm/Xsession
    # alone).
    # Setting $XENVIRONMENT is an option, but the -I flag here is more useful.
    # This also lets me keep .Xresources out of ~/
    [ "$DISPLAY" != "" ] \
      && dko::has "xrdb" \
      && xrdb -merge -I"$DOTFILES" "${DOTFILES}/xresources/.Xresources"
    }
}

# vim: ft=sh :
