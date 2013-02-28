##
# .dotfiles/bash/aliases-linux.sh

alias ls="ls --color=auto"
alias ll="ls -Al"

# don't use mvim on ssh connections and tty
if [ "$SSH_CONNECTION" != "" ] || [ "$DISPLAY" == "" ]; then
  alias e="vim"
  alias mvim="vim"
  alias gvim="vim"
else
  alias e="gvim"
  alias mvim="gvim"
fi

alias open='xdg-open'
