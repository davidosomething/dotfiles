####
# .dotfiles/bash/aliases-osx.sh
# Sourced by zsh as well

# osx aliases since -G is an osx (and FreeBSD) flag
alias ls="ls -AFG"
alias ll="ls -l"
alias flushdns="dscacheutil -flushcache"

# don't use mvim on ssh connections
if [ ! -z "$SSH_CONNECTION" ]; then
  alias e="vim"
  alias mvim="vim"
  alias gvim="vim"
else
  alias e="mvim"
  alias gvim="mvim"
fi

alias a2r="sudo apachectl -k restart"
