# prompt_git
#
# from paul irish
# https://github.com/paulirish/dotfiles/blob/master/.bash_prompt
#
prompt_git() {
  # this is >5x faster than mathias's. has to be for working in Chromium & Blink.

  # check if we're in a git repo. (fast)
  git rev-parse --is-inside-work-tree &>/dev/null || return

  # check for what branch we're on. (fast)
  # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
  # Otherwise, just give up.
  branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
      git rev-parse --short HEAD 2> /dev/null || \
      echo '(unknown)')";

  # check if it's dirty (slow)
  #   technique via github.com/git/git/blob/355d4e173/contrib/completion/git-prompt.sh#L472-L475
  dirty=$(git diff --no-ext-diff --quiet --ignore-submodules --exit-code || echo -e "*")


  [ -n "${s}" ] && s=" [${s}]";
  echo -e "${1}${branchName}${2}$dirty";

  return
}

# prompt
_bash_prompt() {
  local Z="\[\033[0m\]"
  #local K="\[\033[0;30m\]"
  #local R="\[\033[0;31m\]"
  local G="\[\033[0;32m\]"
  local Y="\[\033[0;33m\]"
  local B="\[\033[0;34m\]"
  local P="\[\033[0;35m\]"
  local C="\[\033[0;36m\]"
  local W="\[\033[0;37m\]"

  # USERNAME: white if root, green normal
  local USER="$G\u"
  [ "$USER" = "root" ] && USER="$W\u"

  # HOST: white if remote, green if local
  local HOST="$W\h"
  [ -z "$SSH_CONNECTION" ] && HOST="$G\h"

  local DIR="$Y\w"
  local CURTIME="$Z\t"

  PS1="${USER}$B@${HOST}$C:${DIR}\n"
  PS1+="${CURTIME}"
  PS1+="${P}(\$(prompt_git))"   # git repository details
  PS1+="${Z} "
  export PS1
}

_bash_prompt

