# shell/before.sh
#
# Sourced by .bashrc and .zshrc (interactive shells)
# Depends on shell/vars (which should have been loaded into env by login shell)
#
# Stuff here is used by .zshrc and .bashrc (so unlike vars, this is updated on
# every TTY and not loaded once in env/profile).
#
# Regarding tmux:
# Since my tmux shells are not login shells the path needs to be rebuilt.
# shell/vars on the other hand just get inherited.
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

# vim: ft=zsh :
