# zshrc - only run on interactive/TTY

source "$HOME/.dotfiles/shell/loader"
source "$HOME/.dotfiles/shell/aliases"

# helpfiles
if [ -n "$HAS_BREW" ]; then
  # use homebrew bundled zsh helpfiles for online help
  export HELPDIR="$BREW_PREFIX/share/zsh/helpfiles"
  unalias run-help
  autoload run-help
fi

# env programs
source_if_exists "$CHRUBY_PREFIX/share/chruby/chruby.sh"
source_if_exists "$NVM_DIR/nvm.sh"
source_if_exists "$DOTFILES/z/z.sh"

# commands
has_program "hub" && eval "$(hub alias -s)"

scripts=(
  "options"
  "aliases"
  "keybindings"
  "completions"
  "title"
  "prompt"
  "zsh-syntax-highlighting/zsh-syntax-highlighting"
  # "zsh-history-substring-search/zsh-history-substring-search"
  # "zsh-autosuggestions/autosuggestions"
  "after"
)
for script in $scripts; do
  source "$ZDOTDIR/${script}.zsh"
done

# local
source_if_exists "$HOME/.zshrc.local"

