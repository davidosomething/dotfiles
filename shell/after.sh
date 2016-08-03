# shell/after.sh
#
# Runs before local/* .zshrc and .bashrc
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/after.sh {"

# ==============================================================================
# Use neovim
# Now that path is available, use neovim instead of vim if it is installed
# ==============================================================================

dko::has "nvim" && {
  export EDITOR="nvim"
  export VISUAL="nvim"
}

# ==============================================================================
# Grunt completion
# ==============================================================================

# ZSH one loaded by plugin
dko::has "grunt" && {
  [ -n "$ZSH_VERSION" ] && eval "$(grunt --completion=zsh)"
  [ -n "$BASH" ] && eval "$(grunt --completion=bash)"
}

# ==============================================================================
# npm completion
# Now only on zsh via zsh-better-npm-completion
# ==============================================================================

#eval "$(npm completion 2>/dev/null)"

# ==============================================================================
# travis completion
# ==============================================================================

source_if_exists "${TRAVIS_CONFIG_PATH}/travis.sh" && \
  export DKO_SOURCE="${DKO_SOURCE} -> travis"

# ==============================================================================
# Auto-manpath
# ==============================================================================

unset MANPATH

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=zsh :
