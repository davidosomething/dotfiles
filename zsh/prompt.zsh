# zsh/prompt.zsh

export DKO_SOURCE="${DKO_SOURCE} -> prompt.zsh"

# ------------------------------------------------------------------------------
# version control info
# ------------------------------------------------------------------------------

zstyle ':vcs_info:*'            enable            bzr git hg svn

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

# ------------------------------------------------------------------------------
# vi mode
# ------------------------------------------------------------------------------

# http://paulgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
# use vi mode even if EDITOR is emacs
vimode='I'

# show if in vi mode
function zle-line-init zle-keymap-select {
  vimode="${${KEYMAP/vicmd/N}/(main|viins)/I}"
  zle reset-prompt
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
TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
}

# ----------------------------------------------------------------------------
# components
# ----------------------------------------------------------------------------

# nvm, pyenv, chruby versions
dko::prompt::_env() {
  local output
  output=''

  output+='%F{blue}'

  # NVM node version
  dko::has "nvm" && output+='[node:$(nvm_ls current 2>/dev/null)]'

  # pyenv python version
  dko::has "pyenv" && output+='[py:$(pyenv version-name 2>/dev/null)]'

  # chruby Ruby version
  dko::has "chruby" && output+='[rb:${RUBY_VERSION:-system}]'

  print -Pn "${output}"
}

# exit status
dko::prompt::_exit() {
  print -Pn '%(?.%F{green}ok.%F{red}%?)'
}

# user@hostname:~path
dko::prompt::_location() {
  local prompt_user
  local prompt_host

  local output
  output=''

  # logname»username (e.g. david»root)
  prompt_user='%F{green}%n'
  prompt_host='%F{green}%m'
  [ "$USER" = 'root' ] && prompt_user='%F{white}%n'
  [ "$SSH_CONNECTION" != '' ] && prompt_host='%F{white}%m'

  output+='${prompt_user}%F{blue}@${prompt_host}%F{blue}:'
  output+='%F{yellow}%~'
  print -Pn "${output}"
}

# ------------------------------------------------------------------------------
# precmd - set field values before promptline
# ------------------------------------------------------------------------------

precmd() {
  # Line above prompt
  local left
  local right
  local space
  local zero='%([BSUbfksu]|([FBK]|){*})'
  left=$(dko::prompt::_location)
  left_length=${(S%%)left//$~zero/}}
  right=$(dko::prompt::_env)
  space=(($COLUMNS-${#right}))

  # OUTPUT INFO LINE ABOVE PROMPT
  print -P "${left}${(l:$space:: :)right}"

  # Load up git status
  vcs_info
}

# ------------------------------------------------------------------------------
# prompt main
# ------------------------------------------------------------------------------

# Actual prompt (single line prompt)
dko::prompt() {
  PS1='%f%*'
  PS1+='%F{blue}${vimode}'
  PS1+='${vcs_info_msg_0_}'
  PS1+='%F{yellow}%#%f '

  # ----------------------------------------------------------------------------
  # Left side - continuation mode
  # ----------------------------------------------------------------------------

  PS2='%F{green}%_…%f '
}

dko::prompt

