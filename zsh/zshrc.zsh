#####
# only run on interactive/TTY
source $SHELL_DOTFILES/aliases
source $SHELL_DOTFILES/functions

export HISTFILE="$ZDOTDIR/.zhistory"
source $ZSH_DOTFILES/options.zsh
source $ZSH_DOTFILES/aliases.zsh
source $ZSH_DOTFILES/keybindings.zsh
source $ZSH_DOTFILES/completions.zsh
source $ZSH_DOTFILES/prompt.zsh
source $ZSH_DOTFILES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# program aliases
has_program rbenv && eval "$(rbenv init -)"
has_program hub   && eval "$(hub alias -s)"
has_program brew && {
  unalias run-help
  autoload run-help
  HELPDIR="$(brew --prefix)/share/zsh/helpfiles"

  source_if_exists "`brew --prefix`/etc/profile.d/z.sh"
}

##
# local
source_if_exists $ZDOTDIR/.zshrc.local
