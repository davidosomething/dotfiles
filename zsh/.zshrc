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
# ZSH vars
# ==============================================================================

export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zshcache"
export HISTFILE="${ZDOTDIR}/.zhistory"

export ZSH_BOOKMARKS="${HOME}/.secret/.zshbookmarks"

# ==============================================================================
# zplug
# ==============================================================================

# install zplug if needed
[[ -e ~/.local/share/zplug/zplug ]] || {
  curl -fLo "${XDG_DATA_HOME}/zplug/zplug" --create-dirs https://git.io/zplug \
    && source "${XDG_DATA_HOME}/zplug/zplug" \
    && zplug update --self
}

source_if_exists "${XDG_DATA_HOME}/zplug/zplug" && {

  # ----------------------------------------
  # Bin
  # ----------------------------------------

  zplug "b4b4r07/zplug"
  zplug "robbyrussell/oh-my-zsh", of:"plugins/autojump/*.zsh"
  zplug "robbyrussell/oh-my-zsh", of:"plugins/colored-man-pages/*.zsh"
  zplug "robbyrussell/oh-my-zsh", of:"plugins/git-extras/*.zsh"
  zplug "tonyseek/oh-my-zsh-virtualenv-prompt"
  zplug "davidosomething/cdbk"

  # ----------------------------------------
  # Completions
  # ----------------------------------------

  zplug "akoenig/gulp.plugin.zsh"
  zplug "robbyrussell/oh-my-zsh", of:"plugins/golang/*.zsh"
  zplug "robbyrussell/oh-my-zsh", of:"plugins/nvm/_*"
  zplug "zsh-users/zsh-completions"
  zplug "yonchu/grunt-zsh-completion"

  # ----------------------------------------
  # Mine, inits completion
  # ----------------------------------------

  zplug "${ZDOTDIR}", from:local

  # ----------------------------------------
  # LAST, after compinit, enforced by nice
  # ----------------------------------------

  zplug "zsh-users/zsh-syntax-highlighting", nice:10

  # ----------------------------------------
  # Load
  # ----------------------------------------

  if ! zplug check; then zplug install; fi
  zplug load
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
# nocorrect aliases
# ==============================================================================

alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias mkdir="nocorrect mkdir"

# ==============================================================================
# Paths
# ==============================================================================

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
