# shell/node.bash
export DKO_SOURCE="${DKO_SOURCE} -> shell/node.bash {"

# ============================================================================
# npm config
# ============================================================================

[ -f "${LDOTDIR}/npmrc" ] \
  && export NPM_CONF_USERCONFIG="${LDOTDIR}/npmrc"

export NPM_CONFIG_INIT_VERSION="0.0.1"
export NPM_CONFIG_INIT_LICENSE="MIT"
export NPM_CONFIG_STRICT_SSL="TRUE"
export NPM_CONFIG_MESSAGE="Cut %s (via npm version)"

# more user overrides in ~/.dotfiles/local/{bash,zsh}rc

# ==============================================================================
# nvm
# ==============================================================================

# custom NVM_DIR so we don't pollute home
export NVM_DIR="${XDG_CONFIG_HOME}/nvm"

# using nvm?
dko::source "${NVM_DIR}/nvm.sh" && {
  export DKO_SOURCE="${DKO_SOURCE} -> nvm"

  dko::has 'npm' && {
    DKO_DEFAULT_NODE_PATH="$(cd "$(npm bin --global)/.." && pwd)"
    export DKO_DEFAULT_NODE_PATH
  }

  DKO_DEFAULT_NODE_VERSION="$(nvm version default)"
  export DKO_DEFAULT_NODE_VERSION
}

# ============================================================================
# npm global packages
# ============================================================================

dko::has 'trash' && alias rm=trash

dko::has 'yarn' && PATH="${PATH}:$(yarn global bin)" && export PATH

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
