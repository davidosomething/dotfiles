# shell/os.sh
#
# os detection, default to Linux
# Sourced by shell/before since path needs to be set first (for brew in
# particular)
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/os.sh"

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

[[ "$DOTFILES_OS" = "Darwin" ]] && {
  export DOTFILES_DISTRO="mac"

  # ----------------------------------------------------------------------
  # homebrew


  command -v "brew" >/dev/null 2>&1 && {
    BREW_PREFIX="$(brew --prefix)"
    export BREW_PREFIX
  }
}

# ============================================================================
# Linux
# ============================================================================

[[ "$DOTFILES_OS" = "Linux" ]] && {
  [[ -f "/etc/debian_version" ]] && export DOTFILES_DISTRO="debian"

  # ----------------------------------------------------------------------
  # Arch Linux
  # ----------------------------------------------------------------------

  [[ -f "/etc/arch-release" ]] && {
    export DOTFILES_DISTRO="archlinux"

    # for pacdiff
    export DIFFPROG="${DOTFILES}/bin/vopen-nofork -d"

    # for arch wiki lite
    export wiki_browser="chromium"
  }
}

# vim: ft=sh :
