####
# ~/.dotfiles/.zshrc
# zsh options
# only run on interactive/TTY

##
# command history
# these exports only needed when there's a TTY
export HISTSIZE=500
export SAVEHIST=500
export HISTFILE="$ZDOTDIR/.zhistory"
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY                 # append instead of overwrite file
setopt SHARE_HISTORY                  # append after each new command instead
                                      # of after shell closes, share between
                                      # shells

##
# shell options
setopt AUTO_CD
setopt AUTO_PUSHD                     # pushd instead of cd
setopt EXTENDED_GLOB                  # like ** for recursive dirs
setopt PUSHD_TO_HOME                  # go home if no d specified
setopt PUSHD_SILENT                   # don't show stack after cd
setopt CDABLE_VARS
setopt NO_HUP                         # don't kill bg processes
setopt AUTO_LIST                      # list completions
setopt CORRECT

##
# functions
source $ZDOTDIR/.zshfunctions

##
# aliases
source ~/.dotfiles/bash/.bash_aliases      # sh independent aliases
source $ZDOTDIR/.zshaliases

##
# prompt
setopt PROMPT_SUBST                   # allow variables in prompt
autoload -U colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
# version control info in prompt
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'  # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '+'    # display this when there are staged changes
zstyle ':vcs_info:*' formats '(%b%m%c%u)'
zstyle ':vcs_info:*' actionformats '(%b%m%c%u)[%a]'
# show if in vi mode
VIMODE='I';
function zle-line-init zle-keymap-select {
  VIMODE="${${KEYMAP/vicmd/N}/(main|viins)/I}"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
bindkey -v                            # use vi mode even if EDITOR is emacs
# prompt itself
PROMPT_HOST='%F{green}%m'
if [[ $SSH_CONNECTION != '' ]]; then PROMPT_HOST='%F{white}%m'; fi
PROMPT='%F{green}%n%F{blue}@${PROMPT_HOST}%F{blue}:%F{yellow}%~
%f%*%F{blue}${VIMODE}%F{magenta}${vcs_info_msg_0_}%# %f'

##
# key bindings
autoload -U compinit && compinit
# search through history starting with current buffer contents
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
# fix backspace
bindkey '^?' backward-delete-char
# fix delete
bindkey '^[[3~' delete-char
# fix up and down to end of line after history
bindkey '\e[A'  history-search-backward  # Up
bindkey '\e[B'  history-search-forward   # Down
# option+ left and right should jump through words
bindkey '\e\e[C' forward-word            # Right
bindkey '\e\e[D' backward-word           # Left

##
# zstyles
# case-insensitive tab completion for filenames (useful on Mac OS X)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' expand 'yes'
# don't autocomplete usernames/homedirs
zstyle ':completion::complete:cd::' tag-order '! users' -

##
# zsh-syntax-highlighting plugin
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh >/dev/null 2>&1 # may or may not exist

##
# os specific
case "$OSTYPE" in
  darwin*)  source $ZDOTDIR/.zshrc.local.osx
            ;;
  linux*)   source $ZDOTDIR/.zshrc.local.linux
            ;;
esac

##
# local
source ~/.zshrc.local >/dev/null 2>&1 # may or may not exist
