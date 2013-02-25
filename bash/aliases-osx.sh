####
# .dotfiles/bash/aliases-osx.sh
# Sourced by zsh as well

# osx aliases since -G is an osx (and FreeBSD) flag
alias ls="ls -AFG"
alias ll="ls -l"
alias flushdns="dscacheutil -flushcache"

# force reuse of existing mvim window
function mvim() {
  if [ -n "$1" ]; then
    $(brew --prefix)/bin/mvim --servername VIM --remote-tab-silent $@
  else
    open -a MacVim
  fi
}

# don't use mvim on ssh connections
if [ ! -z "$SSH_CONNECTION" ]; then
  alias e="vim"
  alias mvim="vim"
  alias gvim="vim"
else
  alias e="mvim"
  alias gvim="mvim"
fi
