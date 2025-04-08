# shellcheck shell=bash
# shell/node.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/node.sh {"

# https://nodejs.org/api/repl.html#repl_environment_variable_options
export NODE_REPL_HISTORY="${XDG_STATE_HOME}/node_repl_history"

# ============================================================================
# npm config
# ============================================================================

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

# ============================================================================
# pnpm
# ============================================================================

export PNPM_HOME="${XDG_DATA_HOME}/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) PATH="$PNPM_HOME:$PATH" ;;
esac

# ==============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
