# zsh/prompt-vimode.zsh
#
# VI mode for ZSH readline
#

export DKO_SOURCE="${DKO_SOURCE} -> prompt-vimode.zsh"

# ZSH var, timeout between <Esc> and mode switch update
export KEYTIMEOUT=2

# http://paulgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
# use vi mode even if EDITOR is emacs
export DKO_PROMPT_VIMODE='%K{blue}%F{white} I '

# ============================================================================
# Show VI mode indicator
# ============================================================================

function zle-line-init zle-keymap-select {
  case ${KEYMAP} in
    (vicmd)       export DKO_PROMPT_VIMODE='%K{green}%F{black} N ' ;;
    (main|viins)  export DKO_PROMPT_VIMODE='%K{blue}%F{white} I ' ;;
  esac

  # force redisplay
  zle reset-prompt
  zle -R
}
zle -N zle-line-init
zle -N zle-keymap-select

# ============================================================================
# End of cmd (after pressing <CR> at any point), back to ins mode
# ============================================================================

function zle-line-finish {
  # This will be the prompt for the current line that we're leaving.
  export DKO_PROMPT_VIMODE='%K{blue}%F{white} I '
  # Redraw the current line's prompt before advancing to a readline.
  zle reset-prompt
  zle -R
}
zle -N zle-line-finish

# ============================================================================
# On interrupt (<C-c>)
# ============================================================================

TRAPINT() {
  export DKO_PROMPT_VIMODE='%K{blue}%F{white} I '
  export DKO_PROMPT_IS_TRAPPED=1
  return $(( 128 + $1 ))
}
