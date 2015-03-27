# prompt
setopt PROMPT_SUBST                   # allow variables in prompt
autoload -U colors && colors

# version control in prompt
autoload -Uz vcs_info
precmd() { vcs_info; }
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'  # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '+'    # display this when there are staged changes
zstyle ':vcs_info:*' formats '(%b%m%c%u)'
zstyle ':vcs_info:*' actionformats '(%b%m%c%u)[%a]'

# vi mode
# http://paulgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
# use vi mode even if EDITOR is emacs
bindkey -v

# show if in vi mode
function zle-line-init zle-keymap-select {
  vimode="${${KEYMAP/vicmd/N}/(main|viins)/I}"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# on end of cmd, back to ins mode
function zle-line-finish {
  vim_mode='I'
  zle reset-prompt
  zle -R
}
zle -N zle-line-finish

# default is ins mode
vimode='I'

# fix ctrl-c mode display
function TRAPINT() {
  vimode='I'
  return $(( 128 + $1 ))
}

_set_prompt() {
  # logname»username (e.g. david»root)
  PROMPT='%F{green}$(logname)'
  [ "$USER" != "$(logname)" ] && PROMPT+="%F{blue}»%F{white}%n"

  PROMPT+='%F{blue}@'

  # host
  prompt_host='%F{green}%m'
  [ "$SSH_CONNECTION" != '' ] && prompt_host='%F{white}%m'
  PROMPT+='${prompt_host}'

  PROMPT+='%F{blue}:'

  # path
  PROMPT+='%F{yellow}%~'

  PROMPT+=$'\n'

  # time
  PROMPT+='%f%*'

  # mode
  PROMPT+='%F{blue}${vimode}'

  # version control
  PROMPT+='%F{magenta}${vcs_info_msg_0_}'

  # root or normal
  PROMPT+='%#'

  PROMPT+=' %f'
}

_set_prompt

