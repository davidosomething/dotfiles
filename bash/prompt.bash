# git prompt for linux
source_if_exists "/usr/share/git/git-prompt.sh"

# prompt
_bash_prompt() {
  local Z="\[\033[0m\]"
  local K="\[\033[0;30m\]"
  local R="\[\033[0;31m\]"
  local G="\[\033[0;32m\]"
  local Y="\[\033[0;33m\]"
  local B="\[\033[0;34m\]"
  local P="\[\033[0;35m\]"
  local C="\[\033[0;36m\]"
  local W="\[\033[0;37m\]"
  local USER="$G\u"
  local HOST="$W\h"

  # USERNAME: white if root, green normal
  [ "$USER" = "root" ] && USER="$W\u"

  # HOST: white if remote, green if local
  [ -z "$SSH_CONNECTION" ] && HOST="$G\h"

  if type __git_ps1 >/dev/null 2>&1; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    PS1="${USER}$B@${HOST}$C:$Y\w\n$Z\t${P}\$(__git_ps1)\$${Z} "
  else
    PS1="${USER}$B@${HOST}$C:$Y\w\n$Z\t${P}\$${Z} "
  fi

  export PS1
}

_bash_prompt

