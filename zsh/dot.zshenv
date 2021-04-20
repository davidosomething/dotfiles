# dot.zshenv

# Symlinked to ~/.zshenv
# OUTPUT FORBIDDEN
# zshenv is always sourced, even for bg jobs

export DKO_SOURCE="${DKO_SOURCE} -> .zshenv {"

# using prompt expansion and modifiers to get
#   realpath(dirname(absolute path to this file)
#   https://github.com/filipekiss/dotfiles/commit/c7288905178be3e6c378cc4dea86c1a80ca60660#r29121191
export ZDOTDIR="${${(%):-%N}:A:h}"

# Here so it can be skipped in dot.profile later
# Defines XDG dirs
export DKO_INIT=1
. "${HOME}/.dotfiles/shell/vars.sh"
. "${DOTFILES}/shell/path.sh" # depends on vars
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zshcache"

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=zsh
