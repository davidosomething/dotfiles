# zsh/prompt-vimode.zsh

export DKO_SOURCE="${DKO_SOURCE} -> prompt-vimode.zsh"

# ------------------------------------------------------------------------------
# vi mode
# ------------------------------------------------------------------------------

# zsh var, timeout between <Esc> and mode switch update
export KEYTIMEOUT=2

# http://paulgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
# use vi mode even if EDITOR is emacs
export DKOPROMPT_VIMODE="I"

# show if in vi mode
function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    (vicmd)      DKOPROMPT_VIMODE="N" ;;
    (main|viins) DKOPROMPT_VIMODE="I" ;;
    (*)          DKOPROMPT_VIMODE="I" ;;
  esac
  export DKOPROMPT_VIMODE

  # force redisplay
  zle reset-prompt
  zle -R
}

# on end of cmd, back to ins mode
function zle-line-finish {
  vim_mode='I'
  zle reset-prompt
  zle -R
}

# bind the new widgets
zle -N zle-line-init
zle -N zle-keymap-select
zle -N zle-line-finish

# fix ctrl-c mode display
TRAPINT() {
  export DKOPROMPT_VIMODE="I"
  return $(( 128 + $1 ))
}

# Ensure that the prompt is redrawn when the terminal size changes.
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh#L7
TRAPWINCH() {
  zle && zle -R
}
