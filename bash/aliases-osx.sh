####
# .dotfiles/bash/aliases-osx.sh
# Sourced by zsh as well

# osx aliases since -G is an osx (and FreeBSD) flag
alias ls="ls -AFG"
alias ll="ls -l"
alias flushdns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# don't use mvim on ssh connections
if [ ! -z "$SSH_CONNECTION" ]; then
  alias e="vim"
  alias mvim="vim"
  alias gvim="vim"
else
  alias e="mvim"
  alias gvim="mvim"
fi

alias a2r="apachectl -t && sudo apachectl -e info -k restart"

# http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 7'"

alias sysup="sudo softwareupdate -i -a"
