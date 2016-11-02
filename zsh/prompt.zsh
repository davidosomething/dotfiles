# zsh/prompt.zsh

export DKO_SOURCE="${DKO_SOURCE} -> prompt.zsh"

# ============================================================================
# components
# ============================================================================

# nvm, pyenv, chruby versions
dko::prompt::_env() {
  local envs=()

  dko::has "nvm" && envs+=('js:$(nvm_ls current 2>/dev/null)')
  dko::has "pyenv" && envs+=('py:$(pyenv version-name 2>/dev/null)')
  dko::has "chruby" && envs+=('rb:${RUBY_VERSION:-system}')

  # escape the symbols to get proper size calculation
  [ -n ${#envs} ] && print -Pn "\[${(j.\|.)envs}\]"
}

# ============================================================================
# precmd - set field values before promptline
# ============================================================================

dko::prompt::precmd::state() {
  local left_parts=()
  left_parts+=('%n')  # User
  left_parts+=('@')
  left_parts+=('%m')  # Host
  left_parts+=(':')
  left_parts+=('%~ ')  # Path and space
  local left_raw="$(print -Pn "${(j::)left_parts}")"

  local left=''
  if [ -z "$SSH_CONNECTION" ]; then
    local left_colors=()
    if [ "$USER" = 'root' ]
    then left_colors+=('%F{red}')
    else left_colors+=('%F{green}')
    fi
    left_colors+=('%F{blue}')
    if [ -n "$SSH_CONNECTION" ]
    then left_colors+=('%F{red}')
    else left_colors+=('%F{green}')
    fi
    left_colors+=('%F{blue}')
    left_colors+=('%F{yellow}')

    # join parts and colors
    for (( i = 1; i <= ${#left_parts}; i++ )) do
      left="${left}${left_colors[i]}${left_parts[i]}"
    done
  else
    left="$left_raw"
  fi

  # --------------------------------------------------------------------------
  # Output
  # --------------------------------------------------------------------------

  local right="$(dko::prompt::_env)"
  # $COLUMNS is not always right on iterm so use modern tput
  local space=$(($(tput cols) - ${#left_raw} - ${#right}))
  # Right side if has room
  if [[ $space -gt 1 ]]
  then print -P "${left}$(printf "%*s" $space " ")%F{blue}${right}"
  else print -P "${left}"
  fi
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
