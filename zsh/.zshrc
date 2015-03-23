# zshrc - only run on interactive/TTY

source "$HOME/.dotfiles/shell/loader"
source "$HOME/.dotfiles/shell/aliases"

# helpfiles
has_program "brew" && {
  # use homebrew bundled zsh helpfiles for online help
  export HELPDIR="$BREW_PREFIX/share/zsh/helpfiles"
  unalias run-help
  autoload run-help
}

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
  "plugins"
)
for script in $scripts; do
  source "$ZDOTDIR/${script}.zsh"
done

source "$HOME/.dotfiles/shell/after"
source_if_exists "$HOME/.zshrc.local"

