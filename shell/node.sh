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

  # Get initial nvm version using bash string manipulation instead of NVM
  # calls. While this is significantly faster, it is not correct if starting
  # a shell in a dir with a .nvmrc ~= default (which I almost never do).
  # Also does not use vX.X.X -- just X.X.X
  # This is reset if this file is re-sourced, which it is in tmux
  __nodir="$("${DOTFILES}/bin/dko-nvm-node-version")"
  # fi

  DKO_DEFAULT_NODE_VERSION="${__nodir%\/bin}"
  #DKO_DEFAULT_NODE_VERSION="$(nvm version default)"
  export DKO_DEFAULT_NODE_VERSION

elif [ -d "$FNM_DIR" ]; then
  PATH="${FNM_DIR}:${PATH}"
  eval "$(fnm env)" && DKO_SOURCE="${DKO_SOURCE} -> fnm"
fi

# ==============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
