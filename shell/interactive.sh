# shell/interactive.sh

DKO_SOURCE="${DKO_SOURCE} -> shell/interactive.sh {"

if [ -f "${HOME}/.dotfiles/local/dotfiles.lock" ]; then
  "${DOTFILES}/shell/dko-wait-for-dotfiles-lock"
fi

# need this here in case not starting a login shell
. "${DOTFILES}/lib/helpers.sh"
. "${DOTFILES}/shell/functions.sh" # shell functions
. "${DOTFILES}/shell/aliases.sh"   # generic aliases

# ============================================================================
# os specific aliases
# ============================================================================

if [ "$DOTFILES_OS" = 'Linux' ]; then
  . "${DOTFILES}/shell/aliases-linux.sh"
  case "$DOTFILES_DISTRO" in
  "archlinux" | "debian" | "fedora")
    . "${DOTFILES}/shell/aliases-${DOTFILES_DISTRO}.sh"
    ;;
  esac
fi

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
