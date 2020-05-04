# shell/interactive.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/interactive.sh[interactive] {"
[ -f "${HOME}/.local/dotfiles.lock" ] &&
  "${DOTFILES}/shell/dko-wait-for-dotfiles-lock"

# need this here in case not starting a login shell
. "${DOTFILES}/lib/helpers.sh"

# ==============================================================================
# env management -- Node, PHP, Python, Ruby - These add to path
# ==============================================================================

. "${DOTFILES}/shell/go.sh"
. "${DOTFILES}/shell/java.sh"
. "${DOTFILES}/shell/node.sh"
. "${DOTFILES}/shell/php.sh"
. "${DOTFILES}/shell/python.sh"
. "${DOTFILES}/shell/ruby.bash"
. "${DOTFILES}/shell/rust.sh"

# ============================================================================
# interactive aliases and functions
# source aliases late so command -v (as in __dko_has) doesn't detect them
# ============================================================================

. "${DOTFILES}/shell/functions.sh" # shell functions

. "${DOTFILES}/shell/aliases.sh"   # generic aliases

if [ "$DOTFILES_OS" = 'Linux' ]; then
  . "${DOTFILES}/shell/aliases-linux.sh"
  case "$DOTFILES_DISTRO" in
  "archlinux" | "debian" | "fedora")
    . "${DOTFILES}/shell/aliases-${DOTFILES_DISTRO}.sh"
    ;;
  esac
else
  . "${DOTFILES}/shell/aliases-darwin.sh"
fi

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
