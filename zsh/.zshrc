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
# ============================================================================

export ZPLUG_HOME="${XDG_DATA_HOME}/zplug"
export ZPLUG_LOADFILE="${ZDOTDIR}/zplug.zsh"  # plugin definitions

# auto-install
if [ ! -f "${ZPLUG_HOME}/init.zsh" ]; then
  rm -rf "${ZPLUG_HOME}" \
    && git clone https://github.com/zplug/zplug.git "$ZPLUG_HOME" \
    && source "${ZPLUG_HOME}/init.zsh" \
    && zplug update --self
fi

# run
{ has_program "zplug" || source_if_exists "${ZPLUG_HOME}/init.zsh" } && {
  export DKO_SOURCE="${DKO_SOURCE} -> zplug {"
  zplug check --verbose || zplug install
  zplug load && export DKO_SOURCE="${DKO_SOURCE} }"

}

# ============================================================================
# Plugin settings (after plugin loaded)
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
  # compdef here assumes zplug loaded compinit
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
