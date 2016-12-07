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
# macOS/OS X
# ============================================================================

[ "$DOTFILES_OS" = "Darwin" ] && {
  export DOTFILES_DISTRO="mac"

  command -v "brew" >/dev/null && {
    BREW_PREFIX="$(brew --prefix)"
    export BREW_PREFIX
  }

  # command -v "keychain" >/dev/null \
  #   && eval "$(keychain --eval --agents ssh --inherit any id_rsa)"
}

# ============================================================================
# Linux
# ============================================================================

[ "$DOTFILES_OS" = "Linux" ] && {
  # for pacdiff
  export DIFFPROG="nvim -d"

  if [ -f "/etc/fedora-release" ]; then
    export DOTFILES_DISTRO="fedora"
  elif [ -f "/etc/debian_version" ]; then
    export DOTFILES_DISTRO="debian"
  elif [ -f "/etc/arch-release" ]; then
    export DOTFILES_DISTRO="archlinux"

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
  fi
}

# vim: ft=sh :
