# shell/go.bash
#
# uses vars from shell/vars and functions from shell/functions
#

DKO_SOURCE="${DKO_SOURCE} -> shell/go.bash {"

# ==============================================================================
# goenv
# ==============================================================================

export GOENV_ROOT="${XDG_CONFIG_HOME}/goenv"

dko::has "goenv" && {
  DKO_SOURCE="${DKO_SOURCE} -> goenv"
  eval "$(goenv init -)"
}

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
