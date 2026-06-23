#!/usr/bin/env zsh
# .zshrc

# sourced only on interactive/TTY
# sourced when you type ZSH

[[ -n "$TMUX" ]] && DKO_SOURCE="${DKO_SOURCE} -> ____TMUX____ {"
export DKO_SOURCE="${DKO_SOURCE} -> .zshrc {"

# Add an XDG site-functions dir to store manually generated completions
# E.g. the completion for ripgrep on mise tool postinstall
fpath+=("${XDG_DATA_HOME}/zsh/site-functions")
# export to global and dedupe entries (lowercase are arrays that shadow PATH,
# FPATH, etc). You MUST do both upper and lower ones, or else they will be out
# of sync.
typeset -gU cdpath PATH path FPATH fpath MANPATH manpath # shuck: ignore=C001

. "${DOTFILES}/shell/interactive.sh"

# Doesn't need export for current shell, but do want in subshells
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
mkdir -p -- "${HISTFILE:h}"

# ============================================================================
# nocorrect aliases
# These may be re-aliased later (e.g. rm=trash from trash-cli node module)
# ============================================================================

alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias mkdir="nocorrect mkdir"

# ==========================================================================
# noglob
# makes it easier to edit files in next.js and stuff
# e.g. /[...slug].tsx should not be a pattern
# ==========================================================================

alias e="noglob e"
# with glob
alias eg="\e"

# ============================================================================
# zinit
# ============================================================================

# file is required and missing on busybox
(( $+commands[git] )) && {
  declare -A ZINIT
  ZINIT[HOME_DIR]="${XDG_DATA_HOME}/zinit"
  ZINIT[COMPINIT_OPTS]=-C

  # part of zinit's install, found by compaudit
  mkdir -p "${ZINIT[HOME_DIR]}" && chmod g-rwX "${ZINIT[HOME_DIR]}"
  alias unzinit='rm -rf "${ZINIT[HOME_DIR]}"'
  function {
    local zinit_dest="${ZINIT[HOME_DIR]}/bin"
    local zinit_script="${zinit_dest}/zinit.zsh"
    . "$zinit_script" 2>/dev/null || {
      # install if needed
      command git clone https://github.com/zdharma-continuum/zinit "${zinit_dest}" &&
        . "$zinit_script"
    }
  }
}

if (( $+functions[zinit] )); then
  . "${ZDOTDIR}/zinit.zsh" 2>/dev/null
  autoload -Uz _zinit && ((${+_comps})) && _comps['zinit']=_zinit
  # the last zinit plugin will run zicompinit which inits compinit
else
  autoload -Uz compinit && compinit
fi

# ============================================================================
# Finish up managed completions
# ============================================================================

compdef g=git
compdef e=nvim

if (( $+commands[pipx] )) && ! eval "$(register-python-argcomplete pipx)"; then
  __dko_warn "Failed to run register-python-argcomplete!"
  __dko_warn_ "Was python upgraded? Maybe do a 'pipx reinstall-all'"
fi

# ============================================================================
# Options
# In the order of `man zshoptions`
# ============================================================================

# disable ^S and ^Q terminal freezing
unsetopt flowcontrol

# Changing Directories
setopt AUTO_PUSHD # pushd instead of cd
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT  # hide stack after cd
setopt PUSHD_TO_HOME # go home if no d specified

# Completion
setopt AUTO_LIST           # list completions
setopt AUTO_MENU           # TABx2 to start a tab complete menu
setopt NO_COMPLETE_ALIASES # no expand aliases before completion
setopt LIST_PACKED         # variable column widths

# Expansion and Globbing
setopt EXTENDED_GLOB # like ** for recursive dirs

# History
setopt APPEND_HISTORY   # append instead of overwrite file
setopt EXTENDED_HISTORY # extended timestamps
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE # omit from history if space prefixed
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY # verify when using history cmds/params

# Initialisation

# Input/Output
setopt ALIASES          # autocomplete switches for aliases
setopt AUTO_PARAM_SLASH # append slash if autocompleting a dir
setopt COMBINING_CHARS  # unicode allowed when using wezterm
setopt CORRECT

# Job Control
setopt CHECK_JOBS   # prompt before exiting shell with bg job
setopt LONGLISTJOBS # display PID when suspending bg as well
setopt NO_HUP       # do not kill bg processes

# Prompting

setopt PROMPT_SUBST # allow variables in prompt

# Scripts and Functions

# Shell Emulation
setopt INTERACTIVE_COMMENTS # allow comments in shell

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
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
. "${ZDOTDIR}/prompt.zsh"
. "${ZDOTDIR}/title.zsh"

# automatically fix things when pasted, works with url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# automatically quote URLs as they are typed
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

. "${ZDOTDIR}/bindkey.zsh"
. "${ZDOTDIR}/functions.zsh"
. "${ZDOTDIR}/fzf.zsh"
. "${ZDOTDIR}/zstyle.zsh"

. "${DOTFILES}/shell/after.sh"
[[ -f "${LDOTDIR}/zshrc" ]] && . "${LDOTDIR}/zshrc"

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=zsh
