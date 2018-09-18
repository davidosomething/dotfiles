# shell/after.sh

DKO_SOURCE="${DKO_SOURCE} -> shell/after.sh {"

# ============================================================================
# fzf
# ============================================================================

# ** is globbing completion in ZSH, use tickticktab instead
export FZF_COMPLETION_TRIGGER="\`\`"

# Use fastest grepper available
if __dko_has "rg"; then
  export FZF_DEFAULT_COMMAND='rg --files --glob ""'
elif __dko_has "ag"; then
  export FZF_DEFAULT_COMMAND='ag -g ""'
else
  # using git paths only for FZF
  export FZF_DEFAULT_COMMAND='
    (git ls-tree -r --name-only HEAD ||
      find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
        sed s/^..//) 2> /dev/null'
fi

export FZF_DEFAULT_OPTS='--height=20 --min-height=4 --tiebreak=index'

# ============================================================================
# Use neovim
# Now that path is available, use neovim instead of vim if it is installed
# ============================================================================

__dko_has "nvim" && {
  alias e="nvim"

  export EDITOR="nvim"
  export VISUAL="nvim"

  __dko_has "nvr" && alias e="PYTHONWARNINGS=ignore nvr -s"
}

# ============================================================================
# npm stuff
# ============================================================================

__dko_has 'trash' && alias rm=trash

# ============================================================================
# fasd or z
# ============================================================================

__dko_has "fasd" && alias j="z"

# ============================================================================

unset DKO_INIT
export DKO_SOURCE="${DKO_SOURCE} }"
