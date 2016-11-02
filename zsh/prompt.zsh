# zsh/prompt.zsh
#
# prompt-*.zsh should be loaded first
# Use add-zsh-hook for precmd or else the other zsh prompt plugins may break
#

export DKO_SOURCE="${DKO_SOURCE} -> prompt.zsh"

# ============================================================================
# components
# ============================================================================

dko_prompt_left_colors=()
dko_prompt_left_parts=()
if [ "$USER" = 'root' ]
then dko_prompt_left_colors+=('%F{red}')
else dko_prompt_left_colors+=('%F{green}')
fi
dko_prompt_left_parts+=('%n')  # User
dko_prompt_left_colors+=('%F{blue}')
dko_prompt_left_parts+=('@')
if [ -n "$SSH_CONNECTION" ]
then dko_prompt_left_colors+=('%F{red}')
else dko_prompt_left_colors+=('%F{green}')
fi
dko_prompt_left_parts+=('%m')
dko_prompt_left_colors+=('%F{blue}')
dko_prompt_left_parts+=(':')
dko_prompt_left_colors+=('%F{yellow}')
dko_prompt_left_parts+=('%~ ')

dko_prompt_right_colors=()
dko_prompt_right_parts=()
dko::has "nvm" && {
  dko_prompt_right_colors+=('%F{blue}')
  dko_prompt_right_parts+=('js:')
  dko_prompt_right_colors+=('$( [ "${(e)$(nvm_ls current 2>/dev/null)}" = "$DKO_DEFAULT_NODE_VERSION" ] && echo "%F{blue}" || echo "%F{red}")')
  dko_prompt_right_parts+=('${$(nvm_ls current 2>/dev/null):-?}')
}
dko::has "pyenv" && {
  [ -n ${#dko_prompt_right_parts} ] && {
    dko_prompt_right_colors+=('%F{blue}')
    dko_prompt_right_parts+=('|')
  }
  dko_prompt_right_colors+=('%F{blue}')
  dko_prompt_right_parts+=('py:')
  dko_prompt_right_colors+=('%F{blue}')
  dko_prompt_right_parts+=(${$(pyenv version-name 2>/dev/null):-sys})
}
dko::has "chruby" && {
  [ -n ${#dko_prompt_right_parts} ] && {
    dko_prompt_right_colors+=('%F{blue}')
    dko_prompt_right_parts+=('|')
  }
  dko_prompt_right_colors+=('%F{blue}')
  dko_prompt_right_parts+=('rb:')
  dko_prompt_right_colors+=('%F{blue}')
  dko_prompt_right_parts+=('${RUBY_VERSION:-sys}')
}

# ============================================================================
# precmd - set field values before promptline
# ============================================================================

dko::prompt::precmd::state() {
  local left_raw="${(%j::)dko_prompt_left_parts}"
  local right_raw="[${(ej::)dko_prompt_right_parts}]"
  # $COLUMNS is not always right on iterm so use modern tput
  local spaces=$(($(tput cols) - ${#left_raw} - ${#right_raw}))

  local left=''
  for (( i = 1; i <= ${#dko_prompt_left_parts}; i++ )) do
    left="${left}${(%)dko_prompt_left_colors[i]}${(%)dko_prompt_left_parts[i]}"
  done

  # Right side if has room
  if [[ $spaces -gt 1 ]]; then
    local right=''
    for (( i = 1; i <= ${#dko_prompt_right_parts}; i++ )) do
      right="${right}${(%)dko_prompt_right_colors[i]}${(e)dko_prompt_right_parts[i]}"
    done
  fi
  print -P "${left}${(l:spaces-1:: :)}%F{blue}[${(e)right}%F{blue}]"
}
add-zsh-hook precmd dko::prompt::precmd::state

# ============================================================================
# prompt main
# ============================================================================

# Actual prompt (single line prompt)
dko::prompt() {
  # Time
  PS1='%f%*'

  # VI mode
  [ -n "$vimode" ] && PS1+='%F{blue}${vimode}'

  # VCS
  PS1+='${vcs_info_msg_0_}'

  # Symbol
  PS1+='%F{yellow}%#%f '

  RPROMPT='%(?..%F{red}%?)'

  # Continuation mode
  PS2='%F{green}%_…%f '
}

dko::prompt
