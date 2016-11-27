# shell/after.bash
#
# Runs before local/* .zshrc and .bashrc
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/after.bash {"

# ============================================================================
# fzf
# ============================================================================

# ** is globbing completion in zsh, use tickticktab instead
export FZF_COMPLETION_TRIGGER="\`\`"

# Use fastest grepper available
if dko::has "rg"; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob ""'
elif dko::has "ag"; then
  export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
else
  # using git paths only for FZF
  export FZF_DEFAULT_COMMAND='
    (git ls-tree -r --name-only HEAD ||
     find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
        sed s/^..//) 2> /dev/null'
fi

# ==============================================================================
# Use neovim
# Now that path is available, use neovim instead of vim if it is installed
# ==============================================================================

dko::has "nvim" && {
  alias e="nvim"

  export EDITOR="nvim"
  export VISUAL="nvim"
  export VOPEN_EDITOR="nvim"
  export VOPEN_VISUAL="nvim"

  dko::has "nvr" && {
    export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
    export VOPEN_SERVERNAME="$NVIM_LISTEN_ADDRESS"
    export VOPEN_DEFAULT_COMMAND="+enew"
    export VOPEN_REUSE_COMMAND="--remote-silent +sleep"
    export VOPEN_EDITOR="nvr"
    export VOPEN_VISUAL="nvr"
  }
}

# ============================================================================
# Use vopen
# ============================================================================

dko::has "vopen" && alias e="vopen"

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

dko::source "${TRAVIS_CONFIG_PATH}/travis.bash" && \
  export DKO_SOURCE="${DKO_SOURCE} -> travis"

# ============================================================================
# yarn completion
# ============================================================================

dko::source "${DKO_DEFAULT_NODE_PATH}/lib/node_modules/yarn-completions/node_modules/tabtab/.completions/yarn.zsh"

# ==============================================================================
# Auto-manpath
# ==============================================================================

unset MANPATH

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
