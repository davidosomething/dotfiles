# shell/interactive.bash
#
# Depends on shell/vars.bash (which should have been loaded before this file,
# via .bashrc or .zshenv)
#
# Sourced by .bashrc and .zshrc (interactive shells)
#

DKO_SOURCE="${DKO_SOURCE} -> shell/interactive.bash {"

# ============================================================================

[ -f "${HOME}/.dotfiles/local/dotfiles.lock" ] && {
  echo -e "\033[0;33m==> Found dotfiles.lock, waiting 3 secs or press [enter] to continue"
  # shellcheck disable=SC2162
  read -t 3
  if rm "${HOME}/.dotfiles/local/dotfiles.lock" 2>/dev/null; then
    echo -e "\033[0;33m==> Force cleared dotfiles.lock. Starting shell..."
  else
    echo -e "\033[0;32m==> Successfully cleared dotfiles.lock. Starting shell..."
  fi
  echo
}

# ============================================================================

. "${DOTFILES}/shell/functions.bash"  # shell functions
. "${DOTFILES}/shell/dotfiles.bash"   # update dotfiles
. "${DOTFILES}/shell/aliases.bash"    # generic aliases

# ============================================================================
# os specific aliases
# ============================================================================

case "$OSTYPE" in
  darwin*) . "${DOTFILES}/shell/aliases-darwin.bash" ;;
  linux*)  . "${DOTFILES}/shell/aliases-linux.bash"
    case "$DOTFILES_DISTRO" in
      "archlinux"|"debian"|"fedora")
        . "${DOTFILES}/shell/aliases-${DOTFILES_DISTRO}.bash"
        ;;
    esac
    ;;
esac

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
