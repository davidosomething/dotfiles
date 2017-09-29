# zsh/prompt.zsh
#
# prompt-*.zsh should be loaded first
# Use add-zsh-hook for precmd or else the other ZSH prompt plugins may break
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

# ----------------------------------------------------------------------------
# Add env to right parts
# ----------------------------------------------------------------------------

# result:
# |
__dko::prompt::env::separator() {
  [[ "${#__dko_prompt_right_parts}" -ne 0 ]] && {
    __dko_prompt_right_colors+=('%F{blue}')
    __dko_prompt_right_parts+=('|')
  }
}

# result:
# js:
__dko::prompt::env::symbol() {
  __dko_prompt_right_colors+=('%F{blue}')
  __dko_prompt_right_parts+=("${1}:")
}

# result:
# 1.2.3
#
# $1 manager program
# $2 optional version compute string -- default to *env style (pyenv style)
# $3 optionsl color compute string -- default to blue
__dko::prompt::env::version() {
  local manager="$1"

  if (( $# > 1 )); then
    local number="$2"
  else
    local open='${$('
    local close="${manager} version-name 2>/dev/null):-sys}"
    local number="${open}${close}"
  fi

  local color="${3:-"%F{blue}"}"
  __dko_prompt_right_colors+=("${color}")
  __dko_prompt_right_parts+=("${number}")
}

# $1 symbol
# $2 manager program
# $3 optional version compute string
# $4 optional color compute string
__dko::prompt::env() {
  dko::has "$2" || return
  __dko::prompt::env::separator
  __dko::prompt::env::symbol "$1"
  (( $# == 2 )) && __dko::prompt::env::version "$2"
  (( $# == 3 )) && __dko::prompt::env::version "$2" "$3"
  (( $# == 4 )) && __dko::prompt::env::version "$2" "$3" "$4"
}

# Get node version provided by NVM using the env vars instead of calling slow
# NVM functions
__dko::prompt::env::get_current_node() {
  echo "${${NVM_BIN/$NVM_DIR\/versions\/node\/v}%\/b*}"
}

__dko::prompt::env "js" "nvm" '$(__dko::prompt::env::get_current_node)' \
  '$( [[ "$(__dko::prompt::env::get_current_node)" = "$DKO_DEFAULT_NODE_VERSION" ]] && echo "%F{blue}" || echo "%F{red}")'
__dko::prompt::env "go" "goenv"
__dko::prompt::env "py" "pyenv"
__dko::prompt::env "rb" "chruby" '${RUBY_VERSION:-sys}'

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
  if (( ${DKO_PROMPT_IS_TRAPPED:-0} == 1 )); then
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

__dko::prompt
