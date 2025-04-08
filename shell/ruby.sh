# shellcheck shell=bash
# shell/ruby.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/ruby.sh {"

export GEMRC="${DOTFILES}/ruby/gemrc"

# ============================================================================
# Solargraph
# ==============================================================================

export SOLARGRAPH_CACHE="${XDG_CACHE_HOME}/solargraph"

# ==============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
