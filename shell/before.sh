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

source "${DOTFILES}/shell/path.sh"       # rebuild path starting from system path
source "${DOTFILES}/shell/os.sh"         # os env requires path to detect brew
source "${DOTFILES}/shell/helpers.sh"    # useful functions
source "${DOTFILES}/shell/functions.sh"  # useful functions
source "${DOTFILES}/shell/dotfiles.sh"   # update dotfiles
source "${DOTFILES}/shell/aliases.sh"    # aliases

# ==============================================================================
# env management -- Node, PHP, Python, Ruby - These add to path
# ==============================================================================

# This also adds completions based on global nvm->npm packages
source "${DOTFILES}/shell/node.sh"
source "${DOTFILES}/shell/python.sh"
source "${DOTFILES}/shell/ruby.sh"

export DKO_SOURCE="${DKO_SOURCE} }"

# vim: ft=sh :
