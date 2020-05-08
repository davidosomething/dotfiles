# zsh/prompt.zsh
#
# prompt-*.zsh should be loaded first
# Use add-zsh-hook for precmd or else the other ZSH prompt plugins may break
#

export DKO_SOURCE="${DKO_SOURCE} -> prompt.zsh"

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
__dko_prompt::env::separator() {
  [[ "${#__dko_prompt_right_parts}" -ne 0 ]] && {
    __dko_prompt_right_colors+=('%F{blue}')
    __dko_prompt_right_parts+=('|')
  }
}

# result:
# js:
__dko_prompt::env::symbol() {
  __dko_prompt_right_colors+=('%F{blue}')
  __dko_prompt_right_parts+=("${1}:")
}

# result:
# 1.2.3
#
# $1 manager program
# $2 optional version compute string -- default to *env style (pyenv style)
# $3 optionsl color compute string -- default to blue
__dko_prompt::env::version() {
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
__dko_prompt::env() {
  __dko_has "$2" || return 1
  __dko_prompt::env::separator
  __dko_prompt::env::symbol "$1"
  (( $# == 2 )) && __dko_prompt::env::version "$2"
  (( $# == 3 )) && __dko_prompt::env::version "$2" "$3"
  (( $# == 4 )) && __dko_prompt::env::version "$2" "$3" "$4"
}

__dko_prompt::env::js::get_version() {
  __nodir="${NVM_BIN/$NVM_DIR\/versions\/node\/v}"
  echo "${__nodir%\/bin}"
}

# Get node version provided by NVM using the env vars instead of calling slow
# NVM functions
__dko_prompt::env "js" "nvm" '$(__dko_prompt::env::js::get_version)' \
  '$( [[ "$(__dko_prompt::env::js::get_version)" = "$DKO_DEFAULT_NODE_VERSION" ]] && echo "%F{blue}" || echo "%F{red}")'

__dko_prompt::env "go" "goenv"

__dko_prompt::env "j" "jenv"

__dko_prompt::env::py::get_version() {
  python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))'
}

__dko_prompt::env::py::system() {
  [ -z "$system_py" ] && system_py="$(__dko_prompt::env::py::get_version)"
  echo "sys(${system_py})"
}

# virtualenv name if in one
# sys(1.2.3) if using system python
# 1.2.3 if using pyenv version
__dko_prompt::env::py() {
  [ -n "$VIRTUAL_ENV" ] && echo "${VIRTUAL_ENV##*/}" && return

  local pyenv_version_file="${PYENV_ROOT}/version"
  # Not using pyenv version-name because it opens a slow bash subprocess
  # https://github.com/pyenv/pyenv/blob/c3b17c4bbbeb0069a9528f326d5ebd9262435afb/libexec/pyenv-version-name#L18
  [ ! -f "$pyenv_version_file" ] && {
    __dko_prompt::env::py::system
    return
  }

  declare -a lines
  lines=( "${(@f)"$(<$pyenv_version_file)"}" )
  declare -a grepped
  grepped=( ${(M)lines:#*system*} )
  [ -n "$grepped" ] && {
    __dko_prompt::env::py::system
    return
  }

  __dko_prompt::env::py::get_version
}
__dko_prompt::env "py" "python" '$(__dko_prompt::env::py)'

__dko_prompt::env "rb" "chruby" '${RUBY_VERSION:-sys}'

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
