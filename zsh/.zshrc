source "$HOME/.dotfiles/shell/loader"

# only run on interactive/TTY
export HISTFILE="$ZDOTDIR/.zhistory"

# env programs
source_if_exists "$HOME/.nvm/nvm.sh"

source_if_exists /usr/local/share/chruby/chruby.sh
has_program chruby && chruby ruby-2.1.2

# program aliases
if [[ -n $HAS_BREW ]]; then
  source_if_exists "$BREW_PREFIX/etc/profile.d/z.sh"

  # use homebrew bundled zsh helpfiles for online help
  export HELPDIR="$BREW_PREFIX/share/zsh/helpfiles"
  unalias run-help
  autoload run-help
else
  source_if_exists "$DOTFILES/z/z.sh"
fi

for script in "options" "aliases" "keybindings" "completions" "prompt" "zsh-syntax-highlighting/zsh-syntax-highlighting"; do
  source "$ZDOTDIR/${script}.zsh"
done


##
# local
source_if_exists "$HOME/.zshrc.local"
