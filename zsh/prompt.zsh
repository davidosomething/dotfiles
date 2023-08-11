# zsh/prompt.zsh
#
# prompt-*.zsh should be loaded first
# Use add-zsh-hook for precmd or else the other ZSH prompt plugins may break
#

export DKO_SOURCE="${DKO_SOURCE} -> prompt.zsh {"

. "${ZDOTDIR}/prompt-linedrawing.zsh"
. "${ZDOTDIR}/prompt-vcs.zsh"
. "${ZDOTDIR}/prompt-vimode.zsh"

# ============================================================================
# Generic traps
# @see <http://www.dribin.org/dave/blog/archives/2004/01/25/zsh_win_resize/>
# ============================================================================

# @TODO redraw PS1 properly
# TRAPWINCH() {
#   zle && zle -R
# }

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
if [[ -n "$SSH_CONNECTION" ]] || [[ "$WEZTERM_EXECUTABLE" == *"mux-server" ]]
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

# ============================================================================
# precmd - set field values before promptline
# ============================================================================

__dko_prompt::precmd::state() {
  local left_raw="${(%j::)__dko_prompt_left_parts} "
  local left_len=${#left_raw}
  local right_raw=" ${(ej::)__dko_prompt_right_parts}"
  local right_len=${#right_raw}

  local cols
  cols=${COLUMNS:-$(tput cols 2>/dev/null)}
  cols=${cols:-80}

  local left=''
  # colorize
  for (( i = 1; i <= ${#__dko_prompt_left_parts}; i++ )) do
    left="${left}${(%)__dko_prompt_left_colors[i]}${(%)__dko_prompt_left_parts[i]}"
  done
  left="${left} "
  local result="${left}"

  # Right side if has room
  local spaces=$(( $cols - $left_len - $right_len ))
  if (( spaces > 4 )); then
    local right=' '
    # colorize
    for (( i = 1; i <= ${#__dko_prompt_right_parts}; i++ )) do
      right="${right}${(%)__dko_prompt_right_colors[i]}${(e)__dko_prompt_right_parts[i]}"
    done
    result="${result}%F{black}${(l:spaces-1::═:)}%F{blue}${(e)right}%F{blue}"
  fi

  # <C-c> to just output a prompt without the statusline above it
  if (( ${DKO_PROMPT_IS_TRAPPED:-0} == 1 )); then
    export DKO_PROMPT_IS_TRAPPED=0
  else
    print -P "$result"
  fi
}
add-zsh-hook precmd __dko_prompt::precmd::state

# ============================================================================
# prompt main
# ============================================================================

# Actual prompt (single line prompt)
__dko_prompt() {
  PS1=''

  # Time
  #PS1+='%f'

  # VI mode
  PS1+='${DKO_PROMPT_VIMODE}'

  PS1+='%{$reset_color%} '

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

__dko_prompt

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
