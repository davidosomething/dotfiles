# .zshrc

# sourced only on interactive/TTY
# sourced on login after zprofile
# sourced when you type ZSH

[[ -n "$TMUX" ]] && DKO_SOURCE="${DKO_SOURCE} -> ____TMUX____ {"
DKO_SOURCE="${DKO_SOURCE} -> .zshrc {"

. "${HOME}/.dotfiles/shell/dot.profile"
. "${DOTFILES}/shell/interactive.sh"

export HISTORY_IGNORE="(pwd|l|ls|ll|cl|clear)"

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
#setopt NO_COMPLETE_ALIASES            # no expand aliases before completion
setopt LIST_PACKED                    # variable column widths

# Expansion and Globbing
setopt EXTENDED_GLOB                  # like ** for recursive dirs

# History
setopt APPEND_HISTORY                 # append instead of overwrite file
setopt EXTENDED_HISTORY               # extended timestamps
setopt HIST_FIND_NO_DUPS              # ignore already-seen entries when cycling
setopt HIST_IGNORE_ALL_DUPS           # prune older entries when same entered
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
# Completion settings
# Order by * specificity
# ============================================================================

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

# complete .log filenames if redirecting stderr
zstyle ':completion:*:*:-redirect-,2>,*:*' file-patterns '*.log'

# ============================================================================
# zplugin
# ============================================================================

# wget is a prerequisite
if __dko_has 'wget'; then
  __dko_source "${ZDOTDIR}/.zplugin/bin/zplugin.zsh" \
    || echo "[MISSING] Install zplugin"
  __dko_has 'zplugin' && {
    autoload -Uz _zplugin
    (( ${+_comps} )) && _comps[zplugin]=_zplugin
    # Must be sourced above compinit
    __dko_source "${ZDOTDIR}/zplugin.zsh"
  }
else
  __dko_warn 'wget is required for zplugin'
fi

# ============================================================================
# Modules
# ============================================================================

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

# must be after sourcing zplugin and before cdreplay
autoload -Uz compinit
compinit

# enable menu selection
zmodload -i zsh/complist

# run compdefs provided by plugins
__dko_has 'zplugin' && zplugin cdreplay -q


# ============================================================================
# prompt & title
# @uses vcs_info
# @uses add-zsh-hook
# ============================================================================

. "${ZDOTDIR}/prompt-vcs.zsh"
. "${ZDOTDIR}/prompt-vimode.zsh"
. "${ZDOTDIR}/prompt.zsh"
. "${ZDOTDIR}/title.zsh"

# ============================================================================
# Unmanaged plugins
# ============================================================================

# ----------------------------------------------------------------------------
# Plugins: fasd (installed via package manager)
# ----------------------------------------------------------------------------

__dko_has "fasd" && eval "$(fasd --init posix-alias zsh-hook)"

# ----------------------------------------------------------------------------
# Plugins: fzf (installed via brew)
# ----------------------------------------------------------------------------

if [[ -d /usr/local/opt/fzf ]]; then
  [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]] &&
    export PATH="$PATH:/usr/local/opt/fzf/bin"
  __dko_source "/usr/local/opt/fzf/shell/completion.zsh"
  __dko_source "/usr/local/opt/fzf/shell/key-bindings.zsh"
  DKO_SOURCE="${DKO_SOURCE} -> fzf"
fi

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

# ----------------------------------------------------------------------------
# Keybindings: Custom fzf widgets
# ----------------------------------------------------------------------------

__dko_has "fzf" && {
  # <C-G> cd to MRU directory
  __dko_has "fasd" && {
    dko-zsh-widget-fzf-fasd() {
      local dir
      dir=$(fasd -d -l -R | fzf-tmux \
        +m \
        --cycle \
        --exit-0 \
        --height=25% \
        --preview="echo \"{1}\" && ls -1 {1}" \
        --prompt="cd> ") \
      && cd "$dir" \
      || return 1
      zle reset-prompt
    }
    zle -N        dko-zsh-widget-fzf-fasd
    bindkey '^G'  dko-zsh-widget-fzf-fasd
  }

  # <C-B> switch git branch
  dko-zsh-widget-fzf-branch() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
      fbr
      __dko_has vcs_info && vcs_info
      zle reset-prompt
    fi
  }
  zle -N        dko-zsh-widget-fzf-branch
  bindkey '^B'  dko-zsh-widget-fzf-branch

  # <C-X> switch xcode version
  __dko_has "xcode-select" && {
    dko-zsh-widget-fzf-xcode() {
      fxc
      zle reset-prompt
    }
    zle -N        dko-zsh-widget-fzf-xcode
    bindkey '^X'  dko-zsh-widget-fzf-xcode
  }
}

# ============================================================================
# Local
# ============================================================================

. "${DOTFILES}/shell/after.sh"
__dko_source "${LDOTDIR}/zshrc"

# ============================================================================
# End profiling
# ============================================================================

# Started xtrace in dot.zshenv
if [[ "$ITERM_PROFILE" == "PROFILE"* ]] \
  || [[ -n "$DKO_PROFILE_STARTUP" ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-
  echo "==> ZSH startup log written to"
  echo "    ${HOME}/.cache/zlog.$$"
fi

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
