# shell/after.bash
#
# Runs before local/* .zshrc and .bashrc
#

DKO_SOURCE="${DKO_SOURCE} -> shell/after.bash {"

# ============================================================================
# Local path
# ============================================================================

PATH="${HOME}/.local/bin:${PATH}"
PATH="${DOTFILES}/bin:${PATH}"
export PATH

# ============================================================================
# fzf
# ============================================================================

# ** is globbing completion in ZSH, use tickticktab instead
export FZF_COMPLETION_TRIGGER="\`\`"

# Use fastest grepper available
if dko::has "rg"; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob ""'
elif dko::has "ag"; then
  export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
else
  # using git paths only for FZF
  export FZF_DEFAULT_COMMAND='
    (git ls-tree -r --name-only HEAD ||
     find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
        sed s/^..//) 2> /dev/null'
fi

# Workaround bug with FZF in nvim terminal
# https://github.com/junegunn/fzf/issues/809#issuecomment-273226434
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'

# ============================================================================
# Use neovim
# Now that path is available, use neovim instead of vim if it is installed
# ============================================================================

dko::has "nvim" && {
  alias e="nvim"

  export EDITOR="nvim"
  export VISUAL="nvim"

  if dko::has "nvr"; then
    export NVIM_LISTEN_ADDRESS=~/.dotfiles/local/nvimsocket
    export VOPEN_SERVERNAME="$NVIM_LISTEN_ADDRESS"
    export VOPEN_DEFAULT_COMMAND="--remote-silent +enew"
    export VOPEN_REUSE_COMMAND="--remote-silent"
    VOPEN_EDITOR="nvr"
    VOPEN_VISUAL="nvr"
  else
    VOPEN_EDITOR="nvim"
    VOPEN_VISUAL="nvim"
  fi

  export VOPEN_EDITOR
  export VOPEN_VISUAL
}

# ============================================================================
# Use vopen
# ============================================================================

dko::has "vopen" && alias e="vopen"

# ============================================================================
# travis completion
# ============================================================================

dko::source "${TRAVIS_CONFIG_PATH}/travis.bash" && \
  DKO_SOURCE="${DKO_SOURCE} -> travis"

# ============================================================================
# npm stuff
# ============================================================================

dko::has 'trash' && alias rm=trash

# ============================================================================
# fasd or z
# ============================================================================

dko::has "fasd" && alias j="z"

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
