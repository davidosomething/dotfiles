# zsh/prompt-vimode.zsh

export DKO_SOURCE="${DKO_SOURCE} -> prompt-vimode.zsh"

# ------------------------------------------------------------------------------
# vi mode
# ------------------------------------------------------------------------------

# http://paulgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
# use vi mode even if EDITOR is emacs
vimode='I'

# show if in vi mode
function zle-line-init zle-keymap-select {
  # We only show [I]nsert and [N]ormal even when in R and C modes
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
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh#L7
TRAPWINCH() {
  zle && zle -R
}
