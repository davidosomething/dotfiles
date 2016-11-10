# shell/before.sh
#
# Depends on shell/vars.sh (which should have been loaded before this file,
# via .bashrc or .zshenv)
#
# Sourced by .bashrc and .zshrc (interactive shells)
#
# Regarding tmux:
# Since my tmux shells are not login shells the path needs to be rebuilt.
# shell/vars.sh on the other hand just get inherited.
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/before.sh {"

. "${DOTFILES}/shell/path.sh"       # rebuild path starting from system path
. "${DOTFILES}/shell/os.sh"         # os env requires path to detect brew
. "${DOTFILES}/shell/helpers.sh"    # useful functions
. "${DOTFILES}/shell/functions.sh"  # useful functions
. "${DOTFILES}/shell/dotfiles.sh"   # update dotfiles
. "${DOTFILES}/shell/aliases.sh"    # aliases

# ==============================================================================
# env management -- Node, PHP, Python, Ruby - These add to path
# ==============================================================================

# This also adds completions based on global nvm->npm packages
. "${DOTFILES}/shell/node.sh"
. "${DOTFILES}/shell/python.sh"
. "${DOTFILES}/shell/ruby.sh"

export DKO_SOURCE="${DKO_SOURCE} }"

# vim: ft=sh :
