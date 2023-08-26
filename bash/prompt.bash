# prompt.bash

# check for what branch we're on. (fast)
# If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
# Otherwise, just give up.
__branch_name() {
  git symbolic-ref --quiet --short HEAD 2>/dev/null ||
    git rev-parse --short HEAD 2>/dev/null ||
    echo '(unknown)'
}

__symbol_dirty() { git diff --no-ext-diff --quiet || echo '*'; }
__symbol_unstaged() { git diff --no-ext-diff --cached --quiet || echo '+'; }

# __prompt_git
#
# from paul irish
# @see https://github.com/paulirish/dotfiles/blob/master/.bash_prompt
#
__prompt_git() {
  # this is >5x faster than mathias's. has to be for working in Chromium & Blink.
  # check if we're in a git repo. (fast)
  git rev-parse --is-inside-work-tree &>/dev/null || return
  echo -e "${1}$(__branch_name)${2}$(__symbol_dirty)$(__symbol_unstaged)"
}

# __bash_prompt
#
__bash_prompt() {
  local Z='\[\033[0m\]'
  #local K='\[\033[0;30m\]'
  #local R='\[\033[0;31m\]'
  local G='\[\033[0;32m\]'
  local Y='\[\033[0;33m\]'
  local B='\[\033[0;34m\]'
  local P='\[\033[0;35m\]'
  local C='\[\033[0;36m\]'
  local W='\[\033[0;37m\]'

  # USERNAME: white if root, green normal
  local USER="${G}\\u"
  [[ "$USER" = "root" ]] && USER="${W}\\u"

  # HOST: white if remote, green if local
  local HOST="${W}\\h"
  [[ -z "$SSH_CONNECTION" ]] && HOST="${G}\\h"

  local DIR="${Y}\\w"

  PS1="${USER}${B}@${HOST}${C}:${DIR}"

  # add git repository details
  # why check for bash? because on synology if you sudo su, you get /bin/ash
  # /bin/ash loads /etc/profile -> /etc.defaults/.bashrc_profile -> ~/.bashrc
  # the PS1 is preserved but the functions are not available
  [[ "$SHELL" = *"/bash" ]] && PS1+="\\n${P}(\$(__prompt_git))"

  PS1+="${Z} "
  export PS1
}

__bash_prompt
