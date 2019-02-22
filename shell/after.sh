# shell/after.sh

DKO_SOURCE="${DKO_SOURCE} -> shell/after.sh {"

# ============================================================================
# fzf
# ============================================================================

fzfopts="--height=20 --inline-info --min-height=4 --preview 'head -100 {}'"
export FZF_DEFAULT_OPTS="${fzfopts} --tiebreak=index"

# ** is globbing completion in ZSH, use tickticktab instead
export FZF_COMPLETION_TRIGGER="\`\`"

# Use fastest grepper available
if __dko_prefer "rg"; then
  grepper="rg --glob ''"
  grepargs="--files --ignore-file \"${DOTFILES}/ag/dot.ignore\""
elif __dko_has "ag"; then
  grepper='ag'
  grepargs='-g ""'
elif __dko_has "fd"; then
  grepper='fd'
  grepargs='--type f'
else
  # using git paths only for FZF
  grepper='
    (git ls-tree -r --name-only HEAD ||
      find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
        sed s/^..//) 2> /dev/null'
  grepargs=''
fi
export FZF_DEFAULT_COMMAND="${grepper} ${grepargs}"
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"

# ============================================================================
# Use neovim
# Now that path is available, use neovim instead of vim if it is installed
# ============================================================================

__dko_prefer 'nvim' && {
  alias e='nvim'

  export EDITOR='nvim'
  export VISUAL='nvim'

  __dko_prefer 'nvr' && alias e='PYTHONWARNINGS=ignore nvr -s'
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
