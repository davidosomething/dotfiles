#####
# only run on interactive/TTY
export HISTFILE="$ZDOTDIR/.zhistory"

for script in "options" "aliases" "keybindings" "completions" "prompt"; do
  source $ZDOTDIR/${script}.zsh
done

source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# program aliases
has_program hub   && eval "$(hub alias -s)"
has_program rbenv && eval "$(rbenv init -)"
$HAS_BREW && {
  source_if_exists "$BREW_PREFIX/etc/profile.d/z.sh"

  # use homebrew bundled zsh helpfiles for online help
  HELPDIR="$BREW_PREFIX/share/zsh/helpfiles"
  unalias run-help
  autoload run-help
}

##
# local
source_if_exists $ZDOTDIR/.zshrc.local
