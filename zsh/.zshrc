# .zshrc
# sourced only on interactive/TTY
# sourced on login after zprofile
# sourced when you type zsh

export DKO_SOURCE="$DKO_SOURCE -> zshrc"

[ "$DKO_LOADER" != $$ ] && source "$DOTFILES/shell/loader"

source "$DOTFILES/shell/before"

# helpfiles
has_program "brew" && {
  # use homebrew bundled zsh helpfiles for online help
  export HELPDIR="$BREW_PREFIX/share/zsh/helpfiles"
  unalias run-help
  autoload run-help
}

# load autojump before autoload compinit
source_if_exists "$HOME/.autojump/etc/profile.d/autojump.sh"

# load all zsh specific scripts
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
  source "$ZDOTDIR/$script.zsh"
done
unset script

source "$DOTFILES/shell/after"

source_if_exists "$HOME/.fzf.zsh"

source_if_exists "$HOME/.zshrc.local"

