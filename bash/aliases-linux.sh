##
# .dotfiles/bash/aliases-linux.sh

alias ls="ls -A --color=auto"
alias ll="ls -l"

# don't use mvim on ssh connections and tty
if [ "$SSH_CONNECTION" != "" ] || [ "$DISPLAY" == "" ]; then
  alias e="vim"
  alias mvim="vim"
  alias gvim="vim"
else
  alias e="gvim"
  alias mvim="gvim"
fi
