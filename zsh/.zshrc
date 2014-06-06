#####
# only run on interactive/TTY
export HISTFILE="$ZDOTDIR/.zhistory"

for script in "options" "aliases" "keybindings" "completions" "prompt" "zsh-syntax-highlighting/zsh-syntax-highlighting"; do
  source $ZDOTDIR/${script}.zsh
done

# program aliases
if [[ -n $HAS_BREW ]]; then
  source_if_exists "$BREW_PREFIX/etc/profile.d/z.sh"

  # use homebrew bundled zsh helpfiles for online help
  HELPDIR="$BREW_PREFIX/share/zsh/helpfiles"
  unalias run-help
  autoload run-help
else
  source_if_exists "$DOTFILES/z/z.sh"
fi

source_if_exists /usr/local/share/chruby/chruby.sh

##
# local
source_if_exists ~/.zshrc.local
