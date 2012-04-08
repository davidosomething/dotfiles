# ~/.dotfiles/bash/.bashrc
# read on all shells and subshells

##
# bash options
set -o notify
shopt -s checkwinsize                 # useful for tmux
shopt -s histappend
shopt -s nocaseglob
shopt -s extglob
shopt -s cdspell

source ~/.dotfiles/bash/.bash_aliases
##
# os specific
case "$OSTYPE" in
  darwin*)  source ~/.dotfiles/bash/.bash_aliases.osx
            ;;
  linux*)   source ~/.dotfiles/bash/.bash_aliases.linux
            ;;
esac


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

  GIT_PS1_SHOWDIRTYSTATE=1
  #GIT_PS1_SHOWUNTRACKEDFILES=1

  # white if remote, green if local
  if [ -z ${SSH_CONNECTION} ]; then
    local HOST="$G\h"
  else
    local HOST="$W\h"
  fi

  export PS1="$G\u$B@$HOST$C:$Y\w\n$Z\t$P"'$(__git_ps1 "(%s)")'"\$$Z "
}
bash_prompt
