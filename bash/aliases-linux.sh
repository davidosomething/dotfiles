####
# .dotfiles/bash/aliases-linux.sh

# ls
alias ls="ls --color=auto"
alias ll="ls -Al"

# vim
# don't use mvim on ssh connections and tty
if [ -z "$SSH_CONNECTION" ] && [ "$DISPLAY" == "" ]; then
  alias e="gvim"
  alias mvim="gvim"
fi
