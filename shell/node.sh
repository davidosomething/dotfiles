# shell/node.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/node.sh {"

# ==============================================================================
# nvm
# ==============================================================================

# custom NVM_DIR so we don't pollute home
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"

# using nvm?
dko::source "${NVM_DIR}/nvm.sh" && export DKO_SOURCE="${DKO_SOURCE} -> nvm"

export DKO_SOURCE="${DKO_SOURCE} }"

# vim: ft=sh :
