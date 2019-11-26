# shell/after.sh

DKO_SOURCE="${DKO_SOURCE} -> shell/after.sh {"

# ============================================================================
# Use neovim
# Now that path is available, use neovim instead of vim if it is installed
# ============================================================================

__dko_prefer 'nvim' && {
  export EDITOR='nvim'
  export VISUAL='nvim'
  alias e='$EDITOR'

  #__dko_prefer 'nvr' && alias e='nvr --attach-retry=60 -s'
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

#__dko_has 'catimg' && echo && catimg "${DOTFILES}/meta/motd.png" && echo

unset DKO_INIT
export DKO_SOURCE="${DKO_SOURCE} }"
