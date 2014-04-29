####
# .dotfiles/zshenv.zsh
# zshenv is always sourced, even for bg jobs

source $HOME/.dotfiles/shell/functions
source $HOME/.dotfiles/shell/vars
source $HOME/.dotfiles/shell/paths
source $HOME/.dotfiles/shell/aliases

typeset -U path cdpath manpath

##
# Autoload function paths, add tab completion paths, top precedence
$HAS_BREW && {
  fpath=(
    $BREW_PREFIX/share/zsh/site-functions
    $BREW_PREFIX/share/zsh-completions
    $fpath
  )
}

##
# top precedence! So my dotfiles zsh-completions override the previous brew
fpath=(
  $ZSH_DOTFILES/zsh-completions/src
  $fpath
)

# remove duplicates in fpath array
typeset -U fpath
