# shell/interactive.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/interactive.sh {"
[ -f "${HOME}/.local/dotfiles.lock" ] &&
  "${DOTFILES}/shell/dko-wait-for-dotfiles-lock"

# need this here in case not starting a login shell
. "${DOTFILES}/lib/helpers.sh"

# ==============================================================================
# env management -- Node, Python, Ruby - These add to path
# ==============================================================================

. "${DOTFILES}/shell/go.sh"
. "${DOTFILES}/shell/java.sh"
. "${DOTFILES}/shell/node.sh"
. "${DOTFILES}/shell/python.sh"
. "${DOTFILES}/shell/ruby.bash"
. "${DOTFILES}/shell/rust.sh"

# ============================================================================
# interactive shells
# ============================================================================

. "${DOTFILES}/shell/functions.sh" # shell functions

case "$DOTFILES_OS" in
  Darwin) . "${DOTFILES}/shell/interactive-darwin.zsh" ;;
  Linux)
    . "${DOTFILES}/shell/interactive-linux.sh"
    ;;
esac

# source aliases late so command -v (as in __dko_has) doesn't detect them

. "${DOTFILES}/shell/aliases.sh"   # generic aliases
case "$DOTFILES_DISTRO" in
  "archlinux" | "debian" | "fedora")
    . "${DOTFILES}/shell/aliases-${DOTFILES_DISTRO}.sh"
    ;;
esac

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
