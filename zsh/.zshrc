# .zshrc
# sourced only on interactive/TTY
# sourced on login after zprofile
# sourced when you type zsh

[ "$DKO_LOADER" != $$ ] && source "$HOME/.dotfiles/shell/loader"
source "$DOTFILES/shell/before"

export DKO_SOURCE="$DKO_SOURCE -> zshrc"

# ==============================================================================
# my zsh settings
# ==============================================================================

scripts=(
  "options"
  "keybindings"
  "completions"
  "title"
  "prompt"
)
for script in $scripts; do; source "$ZDOTDIR/$script.zsh"; done; unset script

# ==============================================================================
# nocorrect
# ==============================================================================

alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias mkdir="nocorrect mkdir"

# ==============================================================================
# antigen
# ==============================================================================

source_if_exists "$ZDOTDIR/antigen/antigen.zsh" && {
  antigen bundle autojump
  antigen bundle colored-man-pages
  antigen bundle git-extras
  antigen bundle golang
  antigen bundle tonyseek/oh-my-zsh-virtualenv-prompt
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle zsh-users/zsh-completions src
  antigen apply
}

# ==============================================================================
# fzf
# ==============================================================================

source_if_exists "$HOME/.fzf.zsh"

# ==============================================================================
# prefer homebrew zsh's helpfiles
# ==============================================================================

[ -d "$BREW_PREFIX/share/zsh/helpfiles" ] && {
  # use homebrew bundled zsh helpfiles for online help
  export HELPDIR="$BREW_PREFIX/share/zsh/helpfiles"
  unalias run-help
  autoload run-help
}

# ==============================================================================
# zsh_reload
# ==============================================================================

zsh_reload() {
  local cache=$ZSH_CACHE_DIR
  autoload -U compinit zrecompile
  compinit -d "$cache/zcomp-$HOST"

  for f in $ZDOTDIR/.zshrc "$cache/zcomp-$HOST"; do
    zrecompile -p $f && command rm -f $f.zwc.old
  done

  source $ZDOTDIR/.zshrc
}

# ==============================================================================
# post
# ==============================================================================

source "$DOTFILES/shell/after"
source_if_exists "$HOME/.zshrc.local"
