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

# Max length of any single path segment in %~ before it's truncated with a
# horizontal ellipsis (…). The ellipsis counts toward this total, so overlong
# segments become (maxlen - 1) chars + '…'.
DKO_PROMPT_PATH_MAXLEN=40

# Truncate each over-length segment of a path, leaving short segments, the
# leading '/' (an empty first segment), and '~' substitutions intact.
# $1 path string (already %~-expanded, e.g. ~/foo/longsegment/bar)
__dko_prompt::truncate_path() {
  local maxlen="${DKO_PROMPT_PATH_MAXLEN:-40}"
  local -a segs
  # Split on '/'; (j:/:) below rejoins, so empties (leading '/') round-trip.
  segs=("${(@s:/:)1}")
  local i seg
  for (( i = 1; i <= ${#segs}; i++ )); do
    seg="${segs[i]}"
    # zsh slices are 1-indexed/inclusive, so [1,N-1] keeps the first N-1 chars.
    (( ${#seg} > maxlen )) && segs[i]="${seg[1,maxlen-1]}…"
  done
  print -r -- "${(j:/:)segs}"
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
if [[ -n "$SSH_CONNECTION" ]] || [[ -n "$IN_DOCKER" ]] || [[ "$WEZTERM_EXECUTABLE" == *"mux-server" ]]
then __dko_prompt_left_colors+=('%F{red}')
else __dko_prompt_left_colors+=('%F{green}')
fi
__dko_prompt_left_parts+=('%m')
__dko_prompt_left_colors+=('%F{blue}')
__dko_prompt_left_parts+=(':')
__dko_prompt_left_colors+=('%F{yellow}')
__dko_prompt_left_parts+=('%~')
# Remember the path slot so precmd can swap in a per-segment truncated version.
__dko_prompt_pwd_index=${#__dko_prompt_left_parts}

__dko_prompt_right_colors=()
__dko_prompt_right_parts=()

# ============================================================================
# precmd - set field values before promptline
# ============================================================================

__dko_prompt::precmd::state() {
  # Recompute the path slot from the live %~ each precmd, truncating long
  # segments. We re-expand %~ fresh here (not the stored element) so the input
  # is always the real cwd. Re-escape literal '%' as '%%' so the (%) prompt
  # expansion in the colorize loop (and left_raw below) leaves it intact.
  local pwd_trunc="$(__dko_prompt::truncate_path "${(%):-%~}")"
  __dko_prompt_left_parts[$__dko_prompt_pwd_index]="${pwd_trunc//\%/%%}"

  local left_raw="${(%j::)__dko_prompt_left_parts} "
  local left_len=${#left_raw}
  local right_raw=" ${(ej::)__dko_prompt_right_parts}"
  local right_len=${#right_raw}

  local left=''
  # colorize
  for (( i = 1; i <= ${#__dko_prompt_left_parts}; i++ )) do
    left="${left}${(%)__dko_prompt_left_colors[i]}${(%)__dko_prompt_left_parts[i]}"
  done
  left="${left} "
  local result="${left}"

  # Right side if has room
  local cols=${COLUMNS:-80}
  local spaces=$(( $cols - $left_len - $right_len ))
  if (( spaces > 4 )); then
    local right=' '
    # colorize
    for (( i = 1; i <= ${#__dko_prompt_right_parts}; i++ )) do
      right="${right}${(%)__dko_prompt_right_colors[i]}${(e)__dko_prompt_right_parts[i]}"
    done
    result="${result}%F{black}${(l:spaces-1::═:)}%F{blue}${(e)right}%f"
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
  # Send OSC 133 start of prompt so we get special features like Neovim [[ ]]
  # bindings to jump to prev/prompt in scrollback
  # See https://github.com/neovim/neovim/pull/32771/files
  # See https://sw.kovidgoyal.net/kitty/shell-integration/#how-it-works
  # See https://gitlab.freedesktop.org/Per_Bothner/specifications/-/blob/master/proposals/prompts-data/shell-integration.zsh
  # See https://gitlab.freedesktop.org/Per_Bothner/specifications/blob/master/proposals/semantic-prompts.md
  # \e is same as \033, \007 same as BEL, so ESC A BEL
  PS1=$'%{\e]133;A;k=i\a%}'

  PS1+='${DKO_PROMPT_VIMODE}%{$reset_color%} '
  PS1+='${vcs_info_msg_0_}'
  # Symbol on PS1 only - NOT on PS2 though
  PS1+='%F{yellow}%#%f %{$reset_color%}'

  # Send OSC 133 end of prompt
  PS1+=$'%{\e]133;B;\a%}'

  # Continuation mode
  PS2=$'%{\e]133;A;k=s\a%}'
  PS2+='${DKO_PROMPT_VIMODE}%{$reset_color%} '
  PS2+='%F{green}.%f '
  PS2+=$'%{\e]133;B;\a%}'

  # Exit code if non-zero
  RPROMPT='%F{red}%(?..[%?])'
}

__dko_prompt

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
