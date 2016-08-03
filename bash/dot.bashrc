# .bashrc

# ==============================================================================
# Before
# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} -> .bashrc {"
source "${HOME}/.dotfiles/shell/vars.sh"
source "${DOTFILES}/shell/before.sh"

export INPUTRC="${DOTFILES}/shell/dot.inputrc"

# ==============================================================================
# Plugins
# ==============================================================================

source_if_exists "${HOME}/.fzf.bash"

# ==============================================================================
# Main
# ==============================================================================

source "${BASH_DOTFILES}/options.bash"
source "${BASH_DOTFILES}/completions.bash"
source "${BASH_DOTFILES}/prompt.bash"

# ==============================================================================
# After
# ==============================================================================

source "${DOTFILES}/shell/after.sh"
source_if_exists "${DOTFILES}/local/bashrc"

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: syn=sh :
