# shell/node.sh
export DKO_SOURCE="${DKO_SOURCE} -> shell/node.sh {"

# ==============================================================================
# nvm
# ==============================================================================

# custom NVM_DIR so we don't pollute home
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"

# using nvm?
dko::source "${NVM_DIR}/nvm.sh" && {
  export DKO_SOURCE="${DKO_SOURCE} -> nvm"
  DKO_DEFAULT_NODE="$(cd "$(npm bin --global)/.." && pwd)"
  export DKO_DEFAULT_NODE
}

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
