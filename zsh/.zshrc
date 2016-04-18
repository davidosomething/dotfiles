# .zshrc
#
# sourced only on interactive/TTY
# sourced on login after zprofile
# sourced when you type zsh
#

# ============================================================================
# Before
# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} -> zshrc {"
source "${DOTFILES}/shell/before"

# ============================================================================
# Options
# In the order of `man zshoptions`
# ============================================================================

# Changing Directories
setopt AUTO_PUSHD                     # pushd instead of cd
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT                   # don't show stack after cd
setopt PUSHD_TO_HOME                  # go home if no d specified

# Completion
setopt AUTO_LIST                      # list completions
setopt AUTO_MENU                      # TABx2 to start a tab complete menu
setopt NO_COMPLETE_ALIASES            # don't expand aliases before completion
setopt LIST_PACKED                    # variable column widths

# Expansion and Globbing
setopt EXTENDED_GLOB                  # like ** for recursive dirs

# History
setopt APPEND_HISTORY                 # append instead of overwrite file
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE              # don't save in history if space prefixed
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY                    # verify when using history cmds/params

# Initialisation

# Input/Output
setopt ALIASES                        # autocomplete switches for aliases
setopt AUTO_PARAM_SLASH               # append slash if autocompleting a dir
setopt CORRECT

# Job Control
setopt CHECK_JOBS                     # prompt before exiting shell with bg job
setopt LONGLISTJOBS                   # display PID when suspending bg as well
setopt NO_HUP                         # don't kill bg processes

# Prompting

setopt PROMPT_SUBST                   # allow variables in prompt

# Scripts and Functions

# Shell Emulation
setopt INTERACTIVE_COMMENTS           # allow comments in shell

# Shell State

# Zle
setopt NO_BEEP
setopt VI

# ============================================================================
# fpath and manpath
# ============================================================================

# Completion paths
# fpath must be before compinit
if [ -d "${BREW_PREFIX}" ]; then
  # Autoload function paths, add tab completion paths, top precedence
  fpath=(
    "${BREW_PREFIX}/share/zsh-completions"
    "${BREW_PREFIX}/share/zsh/site-functions"
    $fpath
  )

  # ----------------------------------------
  # Prefer homebrew zsh's helpfiles
  # ----------------------------------------

  [ -d "${BREW_PREFIX}/share/zsh/helpfiles" ] && {
    # use homebrew bundled zsh helpfiles for online help
    # @see <https://github.com/Homebrew/homebrew/blob/master/Library/Formula/zsh.rb>
    unalias run-help
    autoload run-help
    HELPDIR="${BREW_PREFIX}/share/zsh/helpfiles"
  }
fi

# dedupe paths
typeset -gU cdpath path fpath manpath

# ============================================================================
# Modules
# ============================================================================

# color complist
zmodload -i zsh/complist

# zplug does colors and compinit
#autoload -Uz colors; colors
#autoload -Uz compinit; compinit -u
autoload -Uz terminfo
autoload -Uz vcs_info

# ============================================================================
# Plugin settings (before)
# ============================================================================

# bookmarks plugin
export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"

# knu/z
export _Z_CMD="j"
export _Z_DATA="${HOME}/.local/z"
[ ! -f "$_Z_DATA" ] && touch "$_Z_DATA"

# ============================================================================
# zplug
# Use repo format for oh-my-zsh plugins so no random crap is sourced
# ============================================================================

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

source_if_exists "${XDG_DATA_HOME}/zplug/zplug" && \
  export DKO_SOURCE="${DKO_SOURCE} -> zplug {" && {

  # ----------------------------------------
  # Mine
  # ----------------------------------------

  zplug "${ZDOTDIR}", from:local

  # ----------------------------------------
  # Bin
  # ----------------------------------------

  zplug "robbyrussell/oh-my-zsh", of:"plugins/colored-man-pages/*.zsh"

  # bunch of git extra commands (bin)
  zplug "robbyrussell/oh-my-zsh", of:"plugins/git-extras/*.zsh"

  # prompt -- unused, using only pyenv for now
  #zplug "tonyseek/oh-my-zsh-virtualenv-prompt"

  # my fork of cdbk, zsh hash based directory bookmarking
  zplug "davidosomething/cdbk"

  # ----------------------------------------
  # Completions
  # ----------------------------------------

  # gulp completion (parses file so not 100% accurate)
  zplug "akoenig/gulp.plugin.zsh"

  # Broken
  # gem completion
  #zplug "robbyrussell/oh-my-zsh", of:"plugins/gem/_*"

  # go completion
  zplug "robbyrussell/oh-my-zsh", of:"plugins/golang/*.zsh"

  # NVM completion
  zplug "robbyrussell/oh-my-zsh", of:"plugins/nvm/_*"

  # Various program completions
  zplug "zsh-users/zsh-completions"

  # In-line best history match suggestion
  zplug "tarruda/zsh-autosuggestions"

  # ----------------------------------------
  # LAST, after compinit, enforced by nice
  # ----------------------------------------

  # homebrew
  # note regular brew completion is broken:
  # @see <https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Tips-N'-Tricks.md#zsh>
  # @see <https://github.com/Homebrew/homebrew/issues/49066>
  #
  # fix by symlinking
  #     ln -s $(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh $(brew --prefix)/share/zsh/site-functions/_brew
  #
  # These addons need to be nice, otherwise won't override _brew
  zplug "vasyharan/zsh-brew-services", if:"[[ $OSTYPE == *darwin* ]]", nice:10
  zplug "robbyrussell/oh-my-zsh", of:"plugins/brew-cask/*.zsh", if:"[[ $OSTYPE == *darwin* ]]", nice:10

  # fork of rupa/z with better completion
  zplug "knu/z", of:z.sh, nice:10

  # highlight as you type
  zplug "zsh-users/zsh-syntax-highlighting", nice:19

  # ----------------------------------------
  # Load
  # ----------------------------------------

  zplug check --verbose || zplug install
  zplug load && export DKO_SOURCE="${DKO_SOURCE} }"
}

# ============================================================================
# Plugin settings (after)
# ============================================================================

# zsh-autosuggestions -- clear the suggestion when entering completion select
# menu
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=("expand-or-complete")

# ============================================================================
# fzf
# ============================================================================

source_if_exists "${HOME}/.fzf.zsh" && export DKO_SOURCE="${DKO_SOURCE} -> fzf"

# ============================================================================
# nocorrect aliases
# ============================================================================

alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias mkdir="nocorrect mkdir"

# ============================================================================
# Completion settings
# ============================================================================

# check that we're in the shell and not in something like vim terminal
if [[ "$0" == *"zsh" ]]; then
  # Use caching for commands that would like a cache.
  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/.zcache"

  # --------------------------------------------------------------------------
  # Completion display
  # --------------------------------------------------------------------------

  # group all by the description above
  zstyle ':completion:*' group-name ''

  # colorful completion
  #zstyle ':completion:*' list-colors ''

  # Updated to respect LS_COLORS
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

  zstyle ':completion:*' list-dirs-first yes

  # go into menu mode on second tab (like current vim wildmenu setting)
  # only if there's more than two things to choose from
  zstyle ':completion:*' menu select=2
  # shift-tab to select previous result
  bindkey -M menuselect '^[[Z'  reverse-menu-complete
  # fix prompt (and side-effect of exiting menuselect) on ^C
  bindkey -M menuselect '^C'    reset-prompt

  # show descriptions for options
  zstyle ':completion:*' verbose yes

  # in Bold, specify what type the completion is, e.g. a file or an alias or
  # a cmd
  zstyle ':completion:*:descriptions' format '%F{black}%B%d%b%f'

  # --------------------------------------------------------------------------
  # Results matching
  # --------------------------------------------------------------------------

  # use case-insensitive completion if case-sensitive generated no hits
  zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

  # don't complete usernames
  zstyle ':completion:*' users ''

  # don't autocomplete homedirs
  zstyle ':completion::complete:cd:*' tag-order '! users'

  # --------------------------------------------------------------------------
  # Result output transformation
  # --------------------------------------------------------------------------

  # expand completions as much as possible on tab
  # e.g. start expanding a path up to wherever it can be until error
  zstyle ':completion:*' expand 'yes'

  # colorful kill command completion
  zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"

  # process names
  zstyle ':completion:*:processes-names' command  'ps c -u ${USER} -o command | uniq'

  # --------------------------------------------------------------------------
  # Aliases (e.g. a=b use results from b when completing for a)
  # --------------------------------------------------------------------------

  compdef e=vim
  compdef vopen=vim
  compdef pkill=kill

fi

# ============================================================================
# After
# ============================================================================

source "${DOTFILES}/shell/after"
source_if_exists "${DOTFILES}/local/zshrc"

if [[ "$PROFILE_STARTUP" == true ]]; then
    unsetopt xtrace
    exec 2>&3 3>&-
fi
export DKO_SOURCE="${DKO_SOURCE} }"
