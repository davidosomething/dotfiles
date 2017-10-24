# shell/dot.profile
#
# Sourced on login shells only
# Sourced by ~/.bash_profile if in a BASH login shell
# Sourced by $ZDOTDIR/.zprofile if in a ZSH login shell
# Used by /bin/sh shell
# macOS always starts a login shell.
#
DKO_SOURCE="${DKO_SOURCE} -> ~/.profile {"

[ -z "$BASH" ] && [ -z "$ZSH_VERSION" ] && return

if [ -z "$DOTFILES" ]; then
  . "${HOME}/.dotfiles/shell/xdg.bash"
  . "${HOME}/.dotfiles/shell/vars.bash"
fi

# ==============================================================================
# env management -- Node, PHP, Python, Ruby - These add to path
# ==============================================================================

# This also adds completions based on global nvm->npm packages
. "${DOTFILES}/shell/go.bash"
. "${DOTFILES}/shell/java.bash"
. "${DOTFILES}/shell/node.bash"
. "${DOTFILES}/shell/php.bash"
. "${DOTFILES}/shell/python.bash"
. "${DOTFILES}/shell/ruby.bash"

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
