# shell/node.bash
export DKO_SOURCE="${DKO_SOURCE} -> shell/node.bash {"

# ==============================================================================
# nvm
# ==============================================================================

# custom NVM_DIR so we don't pollute home
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"

# using nvm?
dko::source "${NVM_DIR}/nvm.sh" && {
  export DKO_SOURCE="${DKO_SOURCE} -> nvm"

  DKO_DEFAULT_NODE_PATH="$(cd "$(npm bin --global)/.." && pwd)"
  export DKO_DEFAULT_NODE_PATH

  DKO_DEFAULT_NODE_VERSION="$(nvm version default)"
  export DKO_DEFAULT_NODE_VERSION
}

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
