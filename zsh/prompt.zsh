# prompt
setopt PROMPT_SUBST                   # allow variables in prompt
autoload -U colors && colors

# version control in prompt
autoload -Uz vcs_info
precmd() { vcs_info; }
zstyle ':vcs_info:*' enable bzr git svn
zstyle ':vcs_info:git*' get-revision true
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' unstagedstr '*'  # display this when there are unstaged changes
zstyle ':vcs_info:git*' stagedstr '+'    # display this when there are staged changes
zstyle ':vcs_info:git*' formats '(%b%m%c%u)'
zstyle ':vcs_info:git*' actionformats '(%b%m%c%u)[%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat 'r%r'
zstyle ':vcs_info:(svn|bzr):*' formats '%b'

# vi mode
# http://paulgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
# use vi mode even if EDITOR is emacs
bindkey -v
vimode='I'

# show if in vi mode
function zle-line-init zle-keymap-select {
  vimode="${${KEYMAP/vicmd/N}/(main|viins)/I}"
  zle reset-prompt
  zle -R
}

# on end of cmd, back to ins mode
function zle-line-finish {
  vim_mode='I'
  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish

# fix ctrl-c mode display
TRAPINT() {
  vimode='I'
  return $(( 128 + $1 ))
}

# Ensure that the prompt is redrawn when the terminal size changes.
TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
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

