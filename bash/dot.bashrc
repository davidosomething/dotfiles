# dot.bashrc
#
# sourced on interactive/TTY
# sourced on login shells via .bash_profile
# symlinked to ~/.bashrc
#

export DKO_SOURCE="${DKO_SOURCE} -> .bashrc {"

# ============================================================================
# Shell init
# ============================================================================

. "${HOME}/.dotfiles/shell/init.bash"
. "${DOTFILES}/shell/interactive.bash"

# ============================================================================
# BASH settings
# ============================================================================

export HISTFILE="${LDOTDIR}/bash_history"

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

dko::source /etc/bash_completion
dko::source /usr/share/bash-completion/bash_completion

# homebrew's bash-completion package sources the rest of bash_completion.d
dko::source "${DKO_BREW_PREFIX}/etc/bash_completion"

dko::source "${NVM_DIR}/bash_completion"

# following are from
# https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile

# Enable tab completion for `g` by marking it as an alias for `git`
type _git &>/dev/null \
  && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ] \
  && complete -o default -o nospace -F _git g

# WP-CLI Bash completions
dko::source "${WP_CLI_CONFIG_PATH}/vendor/wp-cli/wp-cli/utils/wp-completion.bash"

# ==============================================================================
# Plugins
# ==============================================================================

dko::source "${HOME}/.fzf.bash"

# ============================================================================
# Prompt -- needs to be after plugins since it might use them
# ============================================================================

. "${BDOTDIR}/prompt.bash"

# ==============================================================================
# After
# ==============================================================================

. "${DOTFILES}/shell/after.bash"
dko::source "${LDOTDIR}/bashrc"

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
