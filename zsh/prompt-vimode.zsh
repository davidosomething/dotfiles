# zsh/prompt-vimode.zsh
#
# VI mode for zsh readline
#

export DKO_SOURCE="${DKO_SOURCE} -> prompt-vimode.zsh"

# zsh var, timeout between <Esc> and mode switch update
export KEYTIMEOUT=2

# http://paulgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
# use vi mode even if EDITOR is emacs
export DKOPROMPT_VIMODE="I"

# show if in vi mode
function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    (vicmd)      export DKOPROMPT_VIMODE='%K{green}%F{black} N ' ;;
    (main|viins) export DKOPROMPT_VIMODE='%K{blue}%F{white} I ' ;;
  esac

  # force redisplay
  zle reset-prompt
  zle -R
}
zle -N zle-line-init
zle -N zle-keymap-select

# on end of cmd, back to ins mode
function zle-line-finish {
  export DKOPROMPT_VIMODE="I"
  zle reset-prompt
  zle -R
}
zle -N zle-line-finish

# fix ctrl-c mode display
TRAPINT() {
  export DKOPROMPT_VIMODE="I"
  return $(( 128 + $1 ))
}
