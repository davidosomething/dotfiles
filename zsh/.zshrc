#####
# only run on interactive/TTY
source $HOME/.dotfiles/shell/aliases
source $HOME/.dotfiles/shell/functions

export HISTFILE="$ZDOTDIR/.zhistory"
source $ZDOTDIR/options.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/keybindings.zsh

source $ZDOTDIR/completions.zsh
source $DOTFILES/npm/completion

source $ZDOTDIR/prompt.zsh
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# program aliases
has_program rbenv && eval "$(rbenv init -)"
has_program hub   && eval "$(hub alias -s)"
$HAS_BREW && {
  HELPDIR="$BREW_PREFIX/share/zsh/helpfiles"

  source_if_exists "$BREW_PREFIX/etc/profile.d/z.sh"
}

$HAS_BREW && {
  unalias run-help
  autoload run-help
}

##
# local
source_if_exists $ZDOTDIR/.zshrc.local
