# .zshrc

# sourced only on interactive/TTY
# sourced when you type ZSH

[[ -n "$TMUX" ]] && DKO_SOURCE="${DKO_SOURCE} -> ____TMUX____ {"
export DKO_SOURCE="${DKO_SOURCE} -> .zshrc {"

# export to global and dedupe entries (lowercase are arrays that shadow PATH,
# FPATH, etc). zsh docs recommends setting the flag for both interfaces (i.e.,
# add both PATH var and path array)
typeset -gU cdpath PATH path FPATH fpath MANPATH manpath

. "${DOTFILES}/shell/interactive.sh"

# ============================================================================
# Interactive vars
# ============================================================================

export HISTFILE="${HOME}/.local/zsh_history"

# ============================================================================
# nocorrect aliases
# These may be re-aliased later (e.g. rm=trash from trash-cli node module)
# ============================================================================

alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias mkdir="nocorrect mkdir"

# ============================================================================
# Modules: compinit and more completion
# ============================================================================

export DOTFILES_ZSH_COMPDIR="${LDOTDIR}/completions"
mkdir -pv "$DOTFILES_ZSH_COMPDIR"

build_fnm_completions() {
  fnm completions --shell zsh >"${DOTFILES_ZSH_COMPDIR}/_fnm" 2>/dev/null &&
    printf "Wrote fnm completions to %s\n" "${DOTFILES_ZSH_COMPDIR}/_fnm"
}
[ ! -f "${DOTFILES_ZSH_COMPDIR}/_fnm" ] && build_fnm_completions

# ============================================================================
# zplug
# ============================================================================

# file is required and missing on busybox
__dko_has 'awk' && __dko_has 'git' && {
  export ZPLUG_HOME="${XDG_DATA_HOME}/zplug"
  function {
    local zplug_script="${ZPLUG_HOME}/init.zsh"
    . "$zplug_script" 2>/dev/null || {
      # install if needed
      command git clone https://github.com/zplug/zplug "$ZPLUG_HOME" &&
        . "$zplug_script"
    }
  }
}
__dko_has 'zplug' && . "${ZDOTDIR}/zplug.zsh" 2>/dev/null

# ============================================================================
# Finish up managed completions
# ============================================================================

autoload -Uz compinit && compinit
compdef g=git

# ============================================================================
# Options
# In the order of `man zshoptions`
# ============================================================================

# disable ^S and ^Q terminal freezing
unsetopt flowcontrol

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
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

# automatically fix things when pasted, works with url-quote-magic
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

# automatically quote URLs as they are typed
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

. "${ZDOTDIR}/prompt.zsh"

# ============================================================================
# Keybindings
# These keys should also be set in shell/.inputrc
#
# `cat -e` to test out keys
#
# \e is the same as ^[ is the escape code for <Esc>
# Prefer ^[ since it mixes better with the letter form [A
#
# Tested on macbook iterm2 and magic keyboard+arch, xterm-256color
# - Need both normal mode and vicmd mode
# ============================================================================

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
# Keybindings: Movement, also triggers zsh-autosuggest partials
# ----------------------------------------------------------------------------

bindkey '^e' vi-forward-word-end
bindkey '^w' vi-forward-word

# ----------------------------------------------------------------------------
# alt+left to previous dir
# ----------------------------------------------------------------------------

__dkoprevdir() {
  popd 2>/dev/null
  zle accept-line
}
zle -N __dkoprevdir
bindkey '^[[1;3D' __dkoprevdir

# ============================================================================
# FZF keybindings
# ============================================================================

if __dko_has 'fzf'; then
  if . "${XDG_CONFIG_HOME}/fzf/fzf.zsh" 2>/dev/null || {
    # linux package managers throw it here
    . "/usr/share/fzf/completion.zsh" 2>/dev/null
    . "/usr/share/fzf/key-bindings.zsh" 2>/dev/null
  }; then
    DKO_SOURCE="${DKO_SOURCE} -> fzf"
  fi

  # <C-b> to open git branch menu and switch to one
  __dkofzfbranch() {
    fzf-git-branch
    zle accept-line
  }
  zle     -N      __dkofzfbranch
  bindkey '^B'    __dkofzfbranch

  # <A-w> to open git worktree list and cd into one
  __dkofzfworktree() {
    local wt
    wt="$(fzf-git-worktree)"
    [ -d "$wt" ] && cd "${wt}"
    zle accept-line
  }
  zle     -N      __dkofzfworktree
  bindkey '^[w'   __dkofzfworktree
fi

# ============================================================================
# Completion settings
# Order by * specificity
# ============================================================================

# --------------------------------------------------------------------------
# Completion: Caching
# --------------------------------------------------------------------------

zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

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
[ -r "${HOME}/.ssh/config" ] && {
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

# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------

# terse zsh-specific up
# skip synology because zsh compiled without regex
if [[ "$DOTFILES_DISTRO" != "synology" ]]; then
  up() {
    local limit=1
    local d=""
    [[ $1 =~ '^[0-9]+$' ]] && limit=$1
    while (( limit-- )); do d="../${d}"; done
    cd "$d"
  }
fi

# ============================================================================
# Local
# ============================================================================

. "${DOTFILES}/shell/after.sh"
. "${LDOTDIR}/zshrc" 2>/dev/null

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
