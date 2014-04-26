####
# .dotfiles/zshenv.zsh
# zshenv is always sourced, even for bg jobs

source $HOME/.dotfiles/shell/vars
source $SHELL_DOTFILES/paths
typeset -U path cdpath manpath

source $SHELL_DOTFILES/aliases
source $SHELL_DOTFILES/functions

##
# Autoload function paths, add tab completion paths, top precedence
has_program brew && {
  fpath=(
    $(brew --prefix)/share/zsh/site-functions
    $(brew --prefix)/share/zsh-completions
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
