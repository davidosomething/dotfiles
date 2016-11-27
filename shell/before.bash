# shell/before.bash
#
# Depends on shell/vars.bash (which should have been loaded before this file,
# via .bashrc or .zshenv)
#
# Sourced by .bashrc and .zshrc (interactive shells)
#
# Regarding tmux:
# Since my tmux shells are not login shells the path needs to be rebuilt.
# shell/vars.bash on the other hand just get inherited.
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/before.bash {"

. "${DOTFILES}/shell/path.bash"       # rebuild path starting from system path
. "${DOTFILES}/shell/os.bash"         # os env requires path to detect brew
. "${DOTFILES}/shell/helpers.bash"    # useful functions
. "${DOTFILES}/shell/functions.bash"  # useful functions
. "${DOTFILES}/shell/dotfiles.bash"   # update dotfiles
. "${DOTFILES}/shell/aliases.bash"    # aliases

# ==============================================================================
# env management -- Node, PHP, Python, Ruby - These add to path
# ==============================================================================

# This also adds completions based on global nvm->npm packages
. "${DOTFILES}/shell/node.bash"
. "${DOTFILES}/shell/python.bash"
. "${DOTFILES}/shell/ruby.bash"

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
