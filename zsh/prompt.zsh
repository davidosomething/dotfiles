# zsh/prompt.zsh
#
# prompt-*.zsh should be loaded first
# Use add-zsh-hook for precmd or else the other zsh prompt plugins may break
#

export DKO_SOURCE="${DKO_SOURCE} -> prompt.zsh"

# ============================================================================
# Generic traps
# ============================================================================

# Ensure that the prompt is redrawn when the terminal size changes. This is
# for RPROMPT position, (VI indicator is fine without it).
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh#L7
TRAPWINCH() {
  zle && zle -R
}

# ============================================================================
# components
# ============================================================================

__dko_prompt_left_colors=()
__dko_prompt_left_parts=()
if [[ "$USER" = 'root' ]]
then __dko_prompt_left_colors+=('%F{red}')
else __dko_prompt_left_colors+=('%F{green}')
fi
__dko_prompt_left_parts+=('%n')  # User
__dko_prompt_left_colors+=('%F{blue}')
__dko_prompt_left_parts+=('@')
if [[ -n "$SSH_CONNECTION" ]]
then __dko_prompt_left_colors+=('%F{red}')
else __dko_prompt_left_colors+=('%F{green}')
fi
__dko_prompt_left_parts+=('%m')
__dko_prompt_left_colors+=('%F{blue}')
__dko_prompt_left_parts+=(':')
__dko_prompt_left_colors+=('%F{yellow}')
__dko_prompt_left_parts+=('%~')

__dko_prompt_right_colors=()
__dko_prompt_right_parts=()
dko::has "nvm" && {
  __dko_prompt_right_colors+=('%F{blue}')
  __dko_prompt_right_parts+=('js:')
  __dko_prompt_right_colors+=('$( [ "${(e)$(nvm_ls current 2>/dev/null)}" = "$DKO_DEFAULT_NODE_VERSION" ] && echo "%F{blue}" || echo "%F{red}")')
  __dko_prompt_right_parts+=('${$(nvm_ls current 2>/dev/null):-?}')
}
dko::has "pyenv" && {
  [[ "${#__dko_prompt_right_parts}" -eq 0 ]] && {
    __dko_prompt_right_colors+=('%F{blue}')
    __dko_prompt_right_parts+=('|')
  }
  __dko_prompt_right_colors+=('%F{blue}')
  __dko_prompt_right_parts+=('py:')
  __dko_prompt_right_colors+=('%F{blue}')
  __dko_prompt_right_parts+=('${$(pyenv version-name 2>/dev/null):-sys}')
}
dko::has "chruby" && {
  [[ "${#__dko_prompt_right_parts}" -eq 0 ]] && {
    __dko_prompt_right_colors+=('%F{blue}')
    __dko_prompt_right_parts+=('|')
  }
  __dko_prompt_right_colors+=('%F{blue}')
  __dko_prompt_right_parts+=('rb:')
  __dko_prompt_right_colors+=('%F{blue}')
  __dko_prompt_right_parts+=('${RUBY_VERSION:-sys}')
}

# ============================================================================
# precmd - set field values before promptline
# ============================================================================

__dko::prompt::precmd::state() {
  local left_raw="${(%j::)__dko_prompt_left_parts} "
  local left_len=${#left_raw}
  local right_raw=" ${(ej::)__dko_prompt_right_parts}"
  local right_len=${#right_raw}
  # $COLUMNS is not always right on iterm so use modern tput
  local cols=$(tput cols)

  local left=''
  # colorize
  for (( i = 1; i <= ${#__dko_prompt_left_parts}; i++ )) do
    left="${left}${(%)__dko_prompt_left_colors[i]}${(%)__dko_prompt_left_parts[i]}"
  done
  left="${left} "

  # Right side if has room
  local spaces=$(( $cols - $left_len - $right_len ))
  if [[ $spaces -gt 1 ]]; then
    local right=' '
    # colorize
    for (( i = 1; i <= ${#__dko_prompt_right_parts}; i++ )) do
      right="${right}${(%)__dko_prompt_right_colors[i]}${(e)__dko_prompt_right_parts[i]}"
    done
  fi

  # <C-c> to just output a prompt without the statusline above it
  if [[ "$DKO_PROMPT_IS_TRAPPED" -eq "1" ]]; then
    export DKO_PROMPT_IS_TRAPPED=0
  else
    print -P "${left}%F{black}${(l:spaces-1::═:)}%F{blue}${(e)right}%F{blue}"
  fi
}
add-zsh-hook precmd __dko::prompt::precmd::state

# ============================================================================
# prompt main
# ============================================================================

# Actual prompt (single line prompt)
__dko::prompt() {
  PS1=''

  # Time
  #PS1+='%f'

  # VI mode
  PS1+='${DKO_PROMPT_VIMODE}'
  # Restore colors from VIMODE - the black in necessary for menu select mode
  # fix.
  PS1+='%K{black}%{$reset_color%} '

  # VCS
  PS1+='${vcs_info_msg_0_}'

  # Continuation mode
  PS2="$PS1"
  PS2+='%F{green}.%f '

  # Symbol on PS1 only - NOT on PS2 though
  PS1+='%F{yellow}%#%f %{$reset_color%}'

  # Exit code if non-zero
  RPROMPT='%F{red}%(?..[%?])'
}

__dko::prompt
