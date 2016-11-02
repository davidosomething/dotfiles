# zsh/prompt.zsh

export DKO_SOURCE="${DKO_SOURCE} -> prompt.zsh"

# ============================================================================
# version control info
# ============================================================================

# Not using anything else, don't bother
#zstyle ':vcs_info:*'            enable            bzr git hg svn
zstyle ':vcs_info:*'            enable            git

# bzr/svn prompt
zstyle ':vcs_info:(svn|bzr):*'  branchformat      'r%r'
zstyle ':vcs_info:(svn|bzr):*'  formats           '(%b)'

# git prompt (and git-svn)
zstyle ':vcs_info:git*' get-revision      true
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' unstagedstr       '*'
zstyle ':vcs_info:git*' stagedstr         '+'
zstyle ':vcs_info:git*' formats           '%F{magenta}(%b%c%u)'
zstyle ':vcs_info:git*' actionformats     '%F{magenta}(%m %F{red}→%F{magenta} %b%c%u)'

# use custom hook to parse merge message in actionformat
zstyle ':vcs_info:git*+set-message:*' hooks gitmergemessage

function +vi-gitmergemessage() {
  if [ "${hook_com[action_orig]}" = "merge" ]; then
    # misc_orig is in the format:
    # bd69f0644eb9aa460da5de9ebf72e2e3c04b30f2 Merge branch 'x' (1 applied)

    # get merge_from branch name
    from=$(echo ${hook_com[misc]} | awk '{print $4}' | tr -d "'")

    # modify %m
    hook_com[misc]="${from}"
  fi
}

# ============================================================================
# vi mode
# ============================================================================

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

precmd() {
  # Line above prompt
  local zero='%([BSUbfksu]|([FBK]|){*})'

  local left_parts=()
  local left_colors=()

  left_parts+=('%n')  # User
  left_parts+=('@')
  left_parts+=('%m')  # Host
  left_parts+=(':')
  left_parts+=('%~ ')  # Path and space

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

  local left_raw="$(print -Pn "${left_parts[@]}")"
  local left=''
  for (( i = 1; i <= $#left_parts; i++ )) do
    left="${left}${left_colors[i]}${left_parts[i]}"
  done

  # --------------------------------------------------------------------------
  # Output
  # --------------------------------------------------------------------------

  # Right side if has room
  local right="$(dko::prompt::_env)"
  # $COLUMNS is not always right on iterm so use modern tput
  local space=$(($(tput cols) - ${#left_raw} - ${#right}))
  [[ $space -gt 1 ]] \
    && print -P "${left}$(printf "%*s" $space " ")%F{blue}${right}" \
    || print -P "${left}"

  # Load up git status for prompt
  [ -z "$SSH_CONNECTION" ] && command -v "vcs_info" >/dev/null && vcs_info
}

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
  [ -n "$SSH_CONNECTION" ] && PS1+='${vcs_info_msg_0_}'

  # Symbol
  PS1+='%F{yellow}%#%f '

  RPROMPT='%(?..%F{red}%?)'

  # Continuation mode
  PS2='%F{green}%_…%f '
}

dko::prompt
