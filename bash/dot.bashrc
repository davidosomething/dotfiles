# dot.bashrc
#
# sourced on interactive/TTY
# sourced on login shells via .bash_profile
# symlinked to ~/.bashrc
#

[[ -n "$TMUX" ]] && DKO_SOURCE="${DKO_SOURCE} -> ____TMUX____ {"
export DKO_SOURCE="${DKO_SOURCE} -> .bashrc {"

# Non-interactive? Some shells/OS will source bashrc and bash_profile out of
# order or skip one entirely
[[ -z "$PS1" ]] && DKO_SOURCE="${DKO_SOURCE} }" && return

# dot.bashprofile was sourced instead, which sourced dot.bashrc, so we need
# to define stuff here
. "${HOME}/.dotfiles/shell/dot.profile"

# ============================================================================
# BASH settings
# ============================================================================

export HISTFILE="${HOME}/.local/bash_history"

# ----------------------------------------------------------------------------
# Options
# ----------------------------------------------------------------------------

set -o notify
shopt -s checkwinsize               # update $LINES and $COLUMNS
shopt -s cmdhist                    # save multi-line commands in one
shopt -s histappend
shopt -s dotglob                    # expand filenames starting with dots too
shopt -s nocaseglob
shopt -s extglob
shopt -s cdspell                    # autocorrect dir names
shopt -s cdable_vars
shopt -s no_empty_cmd_completion    # don't try to complete empty lines

# ----------------------------------------------------------------------------
# Completions
# ----------------------------------------------------------------------------

set completion-ignore-case on

__dko_source "/etc/bash_completion"
__dko_source "/usr/share/bash-completion/bash_completion"

# homebrew's bash-completion package sources the rest of bash_completion.d
__dko_source "${DKO_BREW_PREFIX}/etc/bash_completion"

__dko_source "${NVM_DIR}/bash_completion"

# following are from
# https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile

# Enable tab completion for `g` by marking it as an alias for `git`
type _git &>/dev/null \
  && [[ -f "${DKO_BREW_PREFIX}/etc/bash_completion.d/git-completion.bash" ]] \
  && complete -o default -o nospace -F _git g

# WP-CLI Bash completions
__dko_source "${WP_CLI_CONFIG_PATH}/vendor/wp-cli/wp-cli/utils/wp-completion.bash"

# ==============================================================================
# Plugins
# ==============================================================================

__dko_source "${XDG_CONFIG_HOME}/fzf/fzf.bash"

# ============================================================================
# Prompt -- needs to be after plugins since it might use them
# ============================================================================

. "${BDOTDIR}/prompt.bash"

# ==============================================================================
# After
# ==============================================================================

. "${DOTFILES}/shell/after.sh"
__dko_source "${LDOTDIR}/bashrc"

DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh
