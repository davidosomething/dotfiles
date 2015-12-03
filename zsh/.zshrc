# .zshrc
#
# sourced only on interactive/TTY
# sourced on login after zprofile
# sourced when you type zsh
#

# ==============================================================================
# Before
# ==============================================================================

export DKO_SOURCE="$DKO_SOURCE -> zshrc {"
source "${HOME}/.dotfiles/shell/vars"
source "${DOTFILES}/shell/before"

# ==============================================================================
# Antigen
# ==============================================================================

source_if_exists "${ZDOTDIR}/antigen/antigen.zsh" && {
  antigen bundles <<EOBUNDLES
  autojump
  colored-man-pages
  git-extras
  golang
  tonyseek/oh-my-zsh-virtualenv-prompt
  yonchu/grunt-zsh-completion
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-completions src
EOBUNDLES
  antigen apply
}

# ==============================================================================
# fzf
# ==============================================================================

source_if_exists "${HOME}/.fzf.zsh" && export DKO_SOURCE="$DKO_SOURCE -> fzf"

# ==============================================================================
# zsh_reload
# ==============================================================================

zsh_reload() {
  local cache=$ZSH_CACHE_DIR
  autoload -U compinit zrecompile
  compinit -d "${cache}/zcomp-${HOST}"

  for f in "${ZDOTDIR}/.zshrc" "${cache}/zcomp-${HOST}"; do
    zrecompile -p $f && command rm -f $f.zwc.old
  done

  source "${ZDOTDIR}/.zshrc"
}

# ==============================================================================
# Main
# ==============================================================================

scripts=(
  "options"
  "keybindings"
  "completions"
  "title"
  "prompt"
)
for script in $scripts; do;
  source "${ZDOTDIR}/${script}.zsh" && export DKO_SOURCE="$DKO_SOURCE -> ${script}.zsh"
done; unset script

# ==============================================================================
# nocorrect aliases
# ==============================================================================

alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias mkdir="nocorrect mkdir"

# ==============================================================================
# Paths
# ==============================================================================

export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zshcache"

# remove duplicates in path arrays
typeset -U path cdpath manpath

# Autoload function paths, add tab completion paths, top precedence
# Doesn't matter if no BREW_PREFIX
fpath=(
  "${BREW_PREFIX}/share/zsh/site-functions"
  "${BREW_PREFIX}/share/zsh-completions"
  $fpath
)
# remove duplicates in fpath array
typeset -U fpath

export HISTFILE="${ZDOTDIR}/.zhistory"

# ==============================================================================
# Prefer homebrew zsh's helpfiles
# ==============================================================================

[ -d "${BREW_PREFIX}/share/zsh/helpfiles" ] && {
  # use homebrew bundled zsh helpfiles for online help
  export HELPDIR="${BREW_PREFIX}/share/zsh/helpfiles"
  unalias run-help
  autoload run-help
}

# ==============================================================================
# After
# ==============================================================================

source "${DOTFILES}/shell/after"
source_if_exists "${DOTFILES}/local/zshrc"
