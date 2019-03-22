# .zshrc

# sourced only on interactive/TTY
# sourced on login after zprofile
# sourced when you type ZSH

[[ -n "$TMUX" ]] && DKO_SOURCE="${DKO_SOURCE} -> ____TMUX____ {"
DKO_SOURCE="${DKO_SOURCE} -> .zshrc {"

. "${HOME}/.dotfiles/shell/dot.profile"
. "${DOTFILES}/shell/interactive.sh"

# dedupe these path arrays (they shadow PATH, FPATH, etc)
typeset -gU cdpath path fpath manpath

# ============================================================================
# nocorrect aliases
# These may be re-aliased later (e.g. rm=trash from trash-cli node module)
# ============================================================================

alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias mkdir="nocorrect mkdir"

# ============================================================================
# Options
# In the order of `man zshoptions`
# ============================================================================

# Changing Directories
setopt AUTO_PUSHD                     # pushd instead of cd
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT                   # hide stack after cd
setopt PUSHD_TO_HOME                  # go home if no d specified

# Completion
setopt AUTO_LIST                      # list completions
setopt AUTO_MENU                      # TABx2 to start a tab complete menu
setopt NO_COMPLETE_ALIASES            # no expand aliases before completion
setopt LIST_PACKED                    # variable column widths

# Expansion and Globbing
setopt EXTENDED_GLOB                  # like ** for recursive dirs

# History
setopt APPEND_HISTORY                 # append instead of overwrite file
setopt EXTENDED_HISTORY               # extended timestamps
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE              # omit from history if space prefixed
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
setopt NO_HUP                         # do not kill bg processes

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
# Modules
# ============================================================================

# color complist
zmodload -i zsh/complist
#autoload -Uz colors; colors

# hooks -- used for prompt too
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

. "${ZDOTDIR}/prompt-vcs.zsh"
. "${ZDOTDIR}/prompt-vimode.zsh"
. "${ZDOTDIR}/prompt.zsh"
. "${ZDOTDIR}/title.zsh"

# ============================================================================
# Plugins
# ============================================================================

# ----------------------------------------------------------------------------
# Plugins: Settings that must be defined before loading
# ----------------------------------------------------------------------------

# davidosomething/cdbk
export ZSH_BOOKMARKS="${HOME}/.local/zshbookmarks"

# zsh-users/zsh-autosuggestions
# don't suggest lines longer than
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=48
# as of v4.0 use ZSH/zpty module to async retrieve
#export ZSH_AUTOSUGGEST_USE_ASYNC=1

# ----------------------------------------------------------------------------
# Plugins: fasd (package install)
# ----------------------------------------------------------------------------

__dko_has "fasd" && eval "$(fasd --init posix-alias zsh-hook)"

# ----------------------------------------------------------------------------
# Plugins: fzf (package install)
# ----------------------------------------------------------------------------

# This needs to happen before sourcing the default fzf bind scripts
if __dko_has "fd"; then
  # Use fd (https://github.com/sharkdp/fd) instead of the default find
  # command for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
fi
__dko_source "${HOME}/.fzf.zsh" && DKO_SOURCE="${DKO_SOURCE} -> fzf"

# ============================================================================
# Keybindings (after plugins since some are custom for fzf)
# These keys should also be set in shell/.inputrc
#
# `cat -e` to test out keys
#
# \e is the same as ^[ is the escape code for <Esc>
# Prefer ^[ since it mixes better with the letter form [A
#
# Tested on macbook, iterm2 (default key codes), xterm-256color-italic
# - Need both normal mode and vicmd mode
# ============================================================================

# disable ^S and ^Q terminal freezing
unsetopt flowcontrol

# VI mode
bindkey -v

# ----------------------------------------------------------------------------
# Keybindings - Completion with tab
# Cancel and reset prompt with ctrl-c
# ----------------------------------------------------------------------------

# shift-tab to select previous result
bindkey -M menuselect '^[[Z'  reverse-menu-complete

# fix prompt (and side-effect of exiting menuselect) on ^C
bindkey -M menuselect '^C'    reset-prompt

# ----------------------------------------------------------------------------
# Keybindings - Movement keys
# ----------------------------------------------------------------------------

# Home/Fn-Left
bindkey           '^[[H'    beginning-of-line
bindkey -M vicmd  '^[[H'    beginning-of-line

# End/Fn-Right
bindkey           '^[[F'    end-of-line
bindkey -M vicmd  '^[[F'    end-of-line

# Left and right should jump through words
# Opt-Left
bindkey           '^[^[[D'  backward-word
bindkey -M vicmd  '^[^[[D'  backward-word
# Opt-Right
bindkey           '^[^[[C'  forward-word
bindkey -M vicmd  '^[^[[C'  forward-word
# C-Left
bindkey           '^[[1;5D' vi-backward-word
bindkey -M vicmd  '^[[1;5D' vi-backward-word
# C-Right
bindkey           '^[[1;5C' vi-forward-word
bindkey -M vicmd  '^[[1;5C' vi-forward-word

# C-n to partially accept
bindkey           '^N'  forward-word

# ----------------------------------------------------------------------------
# Keybindings: Editing keys
# ----------------------------------------------------------------------------

# fix delete - Fn-delete
# Don't bind in vicmd mode
bindkey '^[[3~' delete-char

# Allow using backspace from :normal [A]ppend
bindkey -M viins '^?' backward-delete-char

# ----------------------------------------------------------------------------
# Keybindings: History navigation
# Don't bind in vicmd mode, so I can edit multiline commands properly.
# ----------------------------------------------------------------------------

# Up/Down search history filtered using already entered contents
bindkey '^[[A'  history-search-backward
bindkey '^[[B'  history-search-forward

# PgUp/Dn navigate through history like regular up/down
bindkey '^[[5~' up-history
bindkey '^[[6~' down-history

# ----------------------------------------------------------------------------
# Keybindings: Plugin - zsh-autosuggestions
# ----------------------------------------------------------------------------

# native forward-word in insert mode to partially accept autosuggestion
bindkey '^K' forward-word

# ============================================================================
# Custom widget: fzf
# ============================================================================

__dkofzfbranch() {
  if git rev-parse --git-dir >/dev/null 2>&1; then
    fbr
    zle accept-line
  fi
}

# <C-b> to open git branch menu
if __dko_has "fzf"; then
  zle     -N      __dkofzfbranch
  bindkey '^B'    __dkofzfbranch
fi

# ============================================================================
# Completion settings
# Order by * specificity
# ============================================================================

# check that we're in the shell and not in something like vim terminal
if [[ "$0" == *"zsh" ]]; then
  # --------------------------------------------------------------------------
  # Completion: Caching
  # --------------------------------------------------------------------------

  zstyle ':completion:*' use-cache true
  zstyle ':completion:*' cache-path "${XDG_CACHE_HOME}/.zcache"

  # --------------------------------------------------------------------------
  # Completion: Display
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

  # show descriptions for options
  zstyle ':completion:*' verbose yes

  # in Bold, specify what type the completion is, e.g. a file or an alias or
  # a cmd
  zstyle ':completion:*:descriptions' format '%F{black}%B%d%b%f'

  # --------------------------------------------------------------------------
  # Completion: Matching
  # --------------------------------------------------------------------------

  # use case-insensitive completion if case-sensitive generated no hits
  zstyle ':completion:*' matcher-list \
    'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

  # don't complete usernames
  zstyle ':completion:*' users ''

  # don't autocomplete homedirs
  zstyle ':completion::complete:cd:*' tag-order '! users'

  # --------------------------------------------------------------------------
  # Completion: Output transformation
  # --------------------------------------------------------------------------

  # expand completions as much as possible on tab
  # e.g. start expanding a path up to wherever it can be until error
  zstyle ':completion:*' expand yes

  # process names
  zstyle ':completion:*:processes-names' command \
    'ps c -u ${USER} -o command | uniq'

  # rsync and SSH use hosts from ~/.ssh/config
  [ -r "$HOME/.ssh/config" ] && {
    # Vanilla parsing of config file :)
    # @see {@link https://github.com/Eriner/zim/issues/46#issuecomment-219344931}
    hosts=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
    #hosts=($(egrep '^Host ' "$HOME/.ssh/config" | grep -v '*' | awk '{print $2}' ))
    zstyle ':completion:*:ssh:*'    hosts $hosts
    zstyle ':completion:*:rsync:*'  hosts $hosts
  }

  # colorful kill command completion -- probably overridden by fzf
  zstyle ':completion:*:*:kill:*:processes' list-colors \
    "=(#b) #([0-9]#)*=36=31"

  # complete .log filenames if redirecting stderr
  zstyle ':completion:*:*:-redirect-,2>,*:*' file-patterns '*.log'
fi

# ============================================================================
# zplugin
# ============================================================================

# wget is a prerequisite
if __dko_has 'wget'; then
  __dko_source "${ZDOTDIR}/.zplugin/bin/zplugin.zsh" || {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)" \
    && source "${ZDOTDIR}/.zplugin/bin/zplugin.zsh"
  }

  __dko_has 'zplugin' && {
    autoload -Uz _zplugin
    (( ${+_comps} )) && _comps[zplugin]=_zplugin
    __dko_source "${ZDOTDIR}/zplugin.zsh"
  }
else
  __dko_warn 'wget is required for zplugin'
fi

# ============================================================================
# Local: can add more zplugins here
# ============================================================================

. "${DOTFILES}/shell/after.sh"
__dko_source "${LDOTDIR}/zshrc"

# ============================================================================
# zplugin: after
# ============================================================================

if ! __dko_has 'zplugin'; then
  autoload -Uz compinit
  compinit
fi

# ============================================================================
# End profiling
# ============================================================================

# Started xtrace in dot.zshenv
if [[ "$ITERM_PROFILE" == "PROFILE"* ]] \
  || [[ -n "$DKO_PROFILE_STARTUP" ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-
  echo "==> ZSH startup log written to"
  echo "    ${HOME}/tmp/startlog.$$"
fi

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
