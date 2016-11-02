# zsh/prompt-legacy.zsh

export DKO_SOURCE="${DKO_SOURCE} -> prompt-legacy.zsh"

# ------------------------------------------------------------------------------
# prompt main
# ------------------------------------------------------------------------------

# This function is available to the shell if need to reset
dko::prompt() {
  # ----------------------------------------------------------------------------
  # Left side
  # ----------------------------------------------------------------------------

  # logname»username (e.g. david»root)
  prompt_user='%F{green}%n'
  prompt_host='%F{green}%m'
  [ "$USER" = 'root' ] && prompt_user='%F{red}%n'
  [ "$SSH_CONNECTION" != '' ] && prompt_host='%F{red}%m'

  PS1='${prompt_user}%F{blue}@${prompt_host}%F{blue}:'
  PS1+='%F{yellow}%~'
  PS1+=$'\n'
  PS1+='%f%*'
  PS1+='%F{blue}${vimode}'
  PS1+='${vcs_info_msg_0_}'
  PS1+='%F{yellow}%#%f '

  # ----------------------------------------------------------------------------
  # Left side - continuation mode
  # ----------------------------------------------------------------------------

  PS2='%F{green}%_…%f '

  # ----------------------------------------------------------------------------
  # Right side
  # ----------------------------------------------------------------------------

  # see Cursor Control at http://www.termsys.demon.co.uk/vtansi.htm
  local go_up=$'\e[1A'
  local go_down=$'\e[1B'

  RPS1="%{${go_up}%}"

  # Exit status in green/red
  #RPS1='%(?.%F{green}ok.%F{red}%?)'

  # ----------------------------------------
  # Env
  # ----------------------------------------

  RPS1+='%F{blue}'

  # NVM node version
  dko::has "nvm" && RPS1+='[node:$(nvm_ls current 2>/dev/null)]'

  # pyenv python version
  dko::has "pyenv" && RPS1+='[py:$(pyenv version-name 2>/dev/null)]'

  # chruby Ruby version
  dko::has "chruby" && RPS1+='[rb:${RUBY_VERSION:-system}]'

  # Back to actual prompt position
  RPS1+="%{${go_down}%}"
}

dko::prompt

