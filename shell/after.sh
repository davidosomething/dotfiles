# shell/after.sh

DKO_SOURCE="${DKO_SOURCE} -> shell/after.sh {"

# ============================================================================
# Use neovim
# Now that path is available, use neovim instead of vim if it is installed
# ============================================================================

__dko_prefer 'nvim' && {
  e() {
    nvim "$@"
  }

  export EDITOR='nvim'
  export VISUAL='nvim'

  __dko_prefer 'nvr' && {
    e() {
      PYTHONWARNINGS=ignore nvr -s "$@"
    }
  }
}

# ============================================================================
# create-react-app
# ============================================================================

export REACT_EDITOR="$VISUAL"

# ============================================================================
# npm stuff
# ============================================================================

__dko_prefer 'trash' && alias rm=trash

# ============================================================================
# fasd or z
# ============================================================================

__dko_prefer 'fasd' && alias j='z'

# ============================================================================

#__dko_has 'catimg' && echo && catimg "${DOTFILES}/meta/motd.png" && echo

unset DKO_INIT
export DKO_SOURCE="${DKO_SOURCE} }"
