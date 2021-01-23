# shell/node.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/node.sh {"

# https://nodejs.org/api/repl.html#repl_environment_variable_options
export NODE_REPL_HISTORY="${XDG_DATA_HOME}/node_repl_history"

# ============================================================================
# npm config
# ============================================================================

[ -f "${LDOTDIR}/npmrc" ] &&
  export NPM_CONF_USERCONFIG="${LDOTDIR}/npmrc"

export NPM_CONFIG_INIT_VERSION="0.0.1"
export NPM_CONFIG_INIT_LICENSE="MIT"
export NPM_CONFIG_STRICT_SSL="TRUE"
export NPM_CONFIG_MESSAGE="Cut %s (via npm version)"
export NPM_CONFIG_SIGN_GIT_TAG="TRUE"

# ============================================================================
# npmrc
# On my machine I actually have a per-hostname set of npmrcs, so this
# particular export is overridden later
# ============================================================================

export NPMRC_STORE="${HOME}/.local/npmrcs"

# ==============================================================================
# fnm / nvm
# ==============================================================================

export NVM_SYMLINK_CURRENT=true

export NVM_DIR="${XDG_CONFIG_HOME}/nvm"
export FNM_DIR="${XDG_CONFIG_HOME}/fnm"

if [ -d "$NVM_DIR" ]; then
  # using nvm? -- store default version for prompt compare
  __dko_source "${NVM_DIR}/nvm.sh" && DKO_SOURCE="${DKO_SOURCE} -> nvm"

elif [ -d "$FNM_DIR" ]; then
  PATH="${FNM_DIR}:${PATH}"
  eval "$(fnm env)" && DKO_SOURCE="${DKO_SOURCE} -> fnm"
fi

# ==============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
