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

# ==============================================================================
# Autoload
# ==============================================================================

autoload -Uz colors; colors
autoload -Uz compinit; compinit -u
autoload -Uz terminfo
autoload -Uz vcs_info

# ==============================================================================
# Paths
# ==============================================================================

# remove duplicates in path arrays
typeset -U path cdpath manpath

# fpath must be before compinit
[ -d "${BREW_PREFIX}" ] && {
  # Autoload function paths, add tab completion paths, top precedence
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
# Plugin settings
# ==============================================================================

# bookmarks plugin
export ZSH_BOOKMARKS="${HOME}/.secret/.zshbookmarks"

# knu/z
export _Z_CMD="j"
export _Z_DATA="${HOME}/.local/z"
[ ! -f "$_Z_DATA" ] && touch "$_Z_DATA"

# ==============================================================================
# zplug
# ==============================================================================

# Make sure fpaths are defined before or within zplug -- it calls compinit
# again in between loading plugins and nice plugins.

# install zplug if needed
[[ -f "${XDG_DATA_HOME}/zplug/zplug" ]] || {
  echo "==> Installing zplug"
  mkdir -p "${XDG_DATA_HOME}/zplug"
  rm "${XDG_DATA_HOME}/zplug/zplug"
  curl -fLo "${XDG_DATA_HOME}/zplug/zplug" --create-dirs https://git.io/zplug \
    && source "${XDG_DATA_HOME}/zplug/zplug" \
    && zplug update --self
}

source_if_exists "${XDG_DATA_HOME}/zplug/zplug" && {

  # ----------------------------------------
  # Mine
  # ----------------------------------------

  zplug "${ZDOTDIR}", from:local

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
  # LAST, after compinit, enforced by nice
  # ----------------------------------------

  zplug "knu/z", of:z.sh, nice:10
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
# Completion settings
# ==============================================================================

# check that we're in the shell and not in something like vim terminal
if [[ "$0" == "-zsh" ]]; then
  # group all by the description above
  zstyle ':completion:*' group-name ''

  # colorful completion
  #zstyle ':completion:*' list-colors ''
  # Updated to respect LS_COLORS
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

  zstyle ':completion:*' list-dirs-first yes

  # use case-insensitive completion if case-sensitive failed generated no hits
  zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

  # expand completions as much as possible on tab
  # e.g. start expanding a path up to wherever it can be until error
  zstyle ':completion:*' expand 'yes'

  # don't autocomplete homedirs
  zstyle ':completion::complete:cd:*' tag-order '! users'

  # in Bold, specify what type the completion is, e.g. a file or an alias or a cmd
  zstyle ':completion:*:descriptions' format '%F{black}%B%d%b%f'

  # don't complete usernames
  zstyle ':completion:*' users ''

  # show descriptions for options
  zstyle ':completion:*' verbose yes

  # Use caching for commands that would like a cache.
  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/.zcache"
fi

# ==============================================================================
# After
# ==============================================================================

source "${DOTFILES}/shell/after"
source_if_exists "${DOTFILES}/local/zshrc"
