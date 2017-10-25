# shell/dot.profile

# Used by /bin/sh shell
# Sourced on login shells only
# Sourced by ~/.bash_profile if in a BASH login shell
# Sourced by $ZDOTDIR/.zprofile if in a ZSH login shell
# NOTE: macOS always starts a login shell

DKO_SOURCE="${DKO_SOURCE} -> dot.profile {"
[ -z "$DKO_INIT" ] && . "${HOME}/.dotfiles/shell/init.sh"

# ==============================================================================
# env management -- Node, PHP, Python, Ruby - These add to path
# ==============================================================================

# This also adds completions based on global nvm->npm packages
. "${DOTFILES}/lib/helpers.sh"
. "${DOTFILES}/shell/go.sh"
. "${DOTFILES}/shell/java.sh"
. "${DOTFILES}/shell/node.sh"
. "${DOTFILES}/shell/php.sh"
. "${DOTFILES}/shell/python.sh"
. "${DOTFILES}/shell/ruby.sh"

# ============================================================================
# Local path
# ============================================================================

PATH="${HOME}/.local/bin:${PATH}"
PATH="${DOTFILES}/bin:${PATH}"
export PATH

# ============================================================================
# POSIX sh support
# ============================================================================

[ -n "$DKO_SH" ] && . "${DOTFILES}/shell/interactive.sh"

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
