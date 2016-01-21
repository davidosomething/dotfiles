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

# bookmarks plugin
export ZSH_BOOKMARKS="${HOME}/.secret/.zshbookmarks"

# ==============================================================================
# Paths
# ==============================================================================

# remove duplicates in path arrays
typeset -U path cdpath manpath

# Autoload function paths, add tab completion paths, top precedence
[ -d "${BREW_PREFIX}" ] && {
  fpath=(
    "${BREW_PREFIX}/share/zsh/site-functions"
    "${BREW_PREFIX}/share/zsh-completions"
    $fpath
  )
  # remove duplicates in fpath array
  typeset -U fpath

  # ----------------------------------------
  # Prefer homebrew zsh's helpfiles
  # ----------------------------------------

  [ -d "${BREW_PREFIX}/share/zsh/helpfiles" ] && {
    # use homebrew bundled zsh helpfiles for online help
    export HELPDIR="${BREW_PREFIX}/share/zsh/helpfiles"
    unalias run-help
    autoload run-help
  }
}

# ==============================================================================
# zplug
# ==============================================================================

# install zplug if needed
[[ -d "${XDG_DATA_HOME}/zplug" ]] || {
  curl -fLo "${XDG_DATA_HOME}/zplug/zplug" --create-dirs https://git.io/zplug \
    && source "${XDG_DATA_HOME}/zplug/zplug" \
    && zplug update --self
}

source_if_exists "${XDG_DATA_HOME}/zplug/zplug" && {

  # ----------------------------------------
  # Bin
  # ----------------------------------------

  zplug "robbyrussell/oh-my-zsh", of:"plugins/colored-man-pages/*.zsh"
  zplug "robbyrussell/oh-my-zsh", of:"plugins/git-extras/*.zsh"
  zplug "tonyseek/oh-my-zsh-virtualenv-prompt"
  zplug "davidosomething/cdbk"

  # ----------------------------------------
  # Completions
  # ----------------------------------------

  zplug "akoenig/gulp.plugin.zsh"

  # Broken
  #zplug "robbyrussell/oh-my-zsh", of:"plugins/gem/_*"

  zplug "robbyrussell/oh-my-zsh", of:"plugins/golang/*.zsh"
  zplug "robbyrussell/oh-my-zsh", of:"plugins/nvm/_*"
  zplug "zsh-users/zsh-completions"

  # ----------------------------------------
  # Mine
  # ----------------------------------------

  zplug "${ZDOTDIR}", from:local

  # ----------------------------------------
  # LAST, after compinit, enforced by nice
  # ----------------------------------------

  zplug "zsh-users/zsh-syntax-highlighting", nice:19

  # ----------------------------------------
  # Load
  # ----------------------------------------

  zplug check --verbose || zplug install
  zplug load
}

# ==============================================================================
# fzf
# ==============================================================================

source_if_exists "${HOME}/.fzf.zsh" && export DKO_SOURCE="$DKO_SOURCE -> fzf"

# ==============================================================================
# nocorrect aliases
# ==============================================================================

alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias mkdir="nocorrect mkdir"

# ==============================================================================
# After
# ==============================================================================

source "${DOTFILES}/shell/after"
source_if_exists "${DOTFILES}/local/zshrc"
