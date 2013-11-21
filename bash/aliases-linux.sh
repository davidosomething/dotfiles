##
# .dotfiles/bash/aliases-linux.sh

# ls
alias ls="ls --color=auto"
alias ll="ls -Al"

# vim
# don't use mvim on ssh connections and tty
if [ "$SSH_CONNECTION" != "" ] || [ "$DISPLAY" == "" ]; then
  alias e="vim"
  alias mvim="vim"
  alias gvim="vim"
else
  alias e="gvim"
  alias mvim="gvim"
fi

# gui
alias open='xdg-open'

################################################################################
# dev
alias composer="php $HOME/.composer/bin/composer.phar"
# web
alias a2r="sudo service apache2 restart"

