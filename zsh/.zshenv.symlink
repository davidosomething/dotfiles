####
# .dotfiles/zshenv.zsh
# zshenv is always sourced, even for bg jobs

for script in "functions" "vars" "aliases" "paths" "keyring"; do
  source $HOME/.dotfiles/shell/${script}
done

# remove duplicates in path arrays
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
  $ZDOTDIR/zsh-completions/src
  $fpath
)

# remove duplicates in fpath array
typeset -U fpath
