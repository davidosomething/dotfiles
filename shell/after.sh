# shell/after.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/after.sh {"

# ============================================================================
# Use neovim
# Now that path is available, use neovim instead of vim if it is installed
# ============================================================================

__dko_prefer 'nvim' && {
  export EDITOR='nvim'
  export VISUAL='nvim'
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
# after zinit installation
# ============================================================================

# prefer ripgrep, but I always type ag
if __dko_has 'rg'; then
  alias ag='rg --hidden --smart-case --ignore-file "${DOTFILES}/ag/dot.ignore"'
else
  # --numbers is a default and not supported on old ag
  # --one-device not supported on old ag
  alias ag='ag --hidden --smart-case'
fi

# ============================================================================

#__dko_has 'catimg' && echo && catimg "${DOTFILES}/meta/motd.png" && echo

unset DKO_INIT
DKO_SOURCE="${DKO_SOURCE} }"
