# shell/interactive.bash
#
# Depends on shell/vars.bash (which should have been loaded before this file,
# via .bashrc or .zshenv)
#
# Sourced by .bashrc and .zshrc (interactive shells)
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/interactive.bash {"

# ============================================================================

# Rebuild path starting from system path
# Regarding tmux:
# Since my tmux shells are not login shells the path needs to be rebuilt.
# shell/vars.bash on the other hand just get inherited.
. "${DOTFILES}/shell/path.bash"

# ============================================================================

. "${DOTFILES}/shell/helpers.bash"    # scripting helpers
. "${DOTFILES}/shell/functions.bash"  # shell functions
. "${DOTFILES}/shell/dotfiles.bash"   # update dotfiles
. "${DOTFILES}/shell/aliases.bash"    # aliases

# ==============================================================================
# env management -- Node, PHP, Python, Ruby - These add to path
# ==============================================================================

# This also adds completions based on global nvm->npm packages
. "${DOTFILES}/shell/java.bash"
. "${DOTFILES}/shell/node.bash"
. "${DOTFILES}/shell/php.bash"
. "${DOTFILES}/shell/python.bash"
. "${DOTFILES}/shell/ruby.bash"

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
