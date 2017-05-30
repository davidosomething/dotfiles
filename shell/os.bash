# shell/os.bash
#
# os detection, default to Linux
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/os.bash"

# @see https://github.com/nojhan/liquidprompt/blob/master/liquidprompt
# uname is slower
if [[ "$OSTYPE" == "darwin"* ]]; then
  export DOTFILES_OS="Darwin"
  export DOTFILES_DISTRO="mac"
  # just assume brew is in normal location, don't even check for it
  export DKO_BREW_PREFIX="/usr/local"

else
  case "$(uname -s)" in
      FreeBSD)   export DOTFILES_OS="FreeBSD" ;;
      OpenBSD)   export DOTFILES_OS="OpenBSD" ;;
      *)         export DOTFILES_OS="Linux"   ;;
  esac
fi

# ============================================================================
# Linux
# ============================================================================

if [ "$DOTFILES_OS" = "Linux" ]; then
  # for pacdiff
  export DIFFPROG="nvim -d"

  if [ -f "/etc/fedora-release" ]; then
    export DOTFILES_DISTRO="fedora"
  elif [ -f "/etc/debian_version" ]; then
    export DOTFILES_DISTRO="debian"
  elif [ -f "/etc/arch-release" ]; then
    export DOTFILES_DISTRO="archlinux"

    # for arch wiki lite, intentionally lowercase
    export wiki_browser="chromium"

    # On ArchLinux, GDM sources the user .Xresources with `-nocpp` so none of the
    # includes are processed. Do a real load here (and leave /etc/gdm/Xsession
    # alone).
    # Setting $XENVIRONMENT is an option, but the -I flag here is more useful.
    # This also lets me keep .Xresources out of ~/
    [ -n "$DISPLAY" ] && dko::has "xrdb" \
      && xrdb -merge -I"$DOTFILES" "${DOTFILES}/xresources/.Xresources"
  fi
fi
