# .zshrc
# sourced only on interactive/TTY
# sourced on login after zprofile
# sourced when you type zsh

[ "$DKO_LOADER" != $$ ] && source "$DOTFILES/shell/loader"
source "$DOTFILES/shell/before"

export DKO_SOURCE="$DKO_SOURCE -> zshrc"

# helpfiles
has_program "brew" && {
  # use homebrew bundled zsh helpfiles for online help
  export HELPDIR="$BREW_PREFIX/share/zsh/helpfiles"
  unalias run-help
  autoload run-help
}

# plugins ----------------------------------------------------------------------
# antigen
source "$ZDOTDIR/antigen/antigen.zsh"
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions src
antigen apply
# local
# load autojump before autoload compinit
source_if_exists "$HOME/.autojump/etc/profile.d/autojump.sh"
source_if_exists "$HOME/.fzf.zsh"

# load all zsh specific scripts ------------------------------------------------
scripts=(
  "options"
  "aliases"
  "keybindings"
  "completions"
  "title"
  "prompt"
)
for script in $scripts; do; source "$ZDOTDIR/$script.zsh"; done; unset script

source "$DOTFILES/shell/after"
source_if_exists "$HOME/.zshrc.local"

