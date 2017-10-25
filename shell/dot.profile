# shell/dot.profile

# Used by /bin/sh shell
# Sourced on login shells only
# Sourced by ~/.bash_profile if in a BASH login shell
# Sourced by $ZDOTDIR/.zprofile if in a ZSH login shell
# NOTE: macOS always starts a login shell

DKO_SOURCE="${DKO_SOURCE} -> dot.profile {"

[ -z "$BASH" ] && [ -z "$ZSH_VERSION" ] && {
  export DKO_POSIX=1
}

if [ -z "$DOTFILES" ]; then
  . "${HOME}/.dotfiles/shell/xdg.sh"
  . "${HOME}/.dotfiles/shell/vars.sh"
fi

# ==============================================================================
# env management -- Node, PHP, Python, Ruby - These add to path
# ==============================================================================

# This also adds completions based on global nvm->npm packages
. "${DOTFILES}/shell/go.sh"
. "${DOTFILES}/shell/java.sh"
. "${DOTFILES}/shell/node.sh"
. "${DOTFILES}/shell/php.sh"
. "${DOTFILES}/shell/python.sh"
. "${DOTFILES}/shell/ruby.sh"

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
