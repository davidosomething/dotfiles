##
# ~/.dotfiles/bash/.bash_prompt
# sourced by .bashrc

# prompt
bash_prompt() {
  local Z="\[\033[0m\]"
  local K="\[\033[0;30m\]"
  local R="\[\033[0;31m\]"
  local G="\[\033[0;32m\]"
  local Y="\[\033[0;33m\]"
  local B="\[\033[0;34m\]"
  local P="\[\033[0;35m\]"
  local C="\[\033[0;36m\]"
  local W="\[\033[0;37m\]"
  local PROMPT=""

  # USERNAME: white if root, green normal
  if [ "$USER" = "root" ]; then
    local USER="$W\u"
  else
    local USER="$G\u"
  fi

  # HOST: white if remote, green if local
  if [ -z "$SSH_CONNECTION" ]; then
    local HOST="$G\h"
  else
    local HOST="$W\h"
  fi

  if type __git_ps1 >/dev/null 2>&1; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    export PS1="${USER}$B@${HOST}$C:$Y\w\n$Z\t${P}\$(__git_ps1)\$${Z} "
  else
    export PS1="${USER}$B@${HOST}$C:$Y\w\n$Z\t${P}\$${Z} "
  fi
}
bash_prompt
