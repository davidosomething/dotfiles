# shell/go.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/go.sh {"

# ==============================================================================
# goenv
# ==============================================================================

export GOENV_ROOT="${XDG_CONFIG_HOME}/goenv"

__dko_has "goenv" && {
  DKO_SOURCE="${DKO_SOURCE} -> goenv"
  eval "$(goenv init -)"
}

# ==============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
