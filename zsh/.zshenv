# .zshenv
#
# OUTPUT FORBIDDEN
# zshenv is always sourced, even for bg jobs
#

export DKO_SOURCE="${DKO_SOURCE} -> zshenv {"
source "${HOME}/.dotfiles/shell/vars"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zshcache"
export HISTFILE="${ZDOTDIR}/.zhistory"
export DKO_SOURCE="${DKO_SOURCE} }"
