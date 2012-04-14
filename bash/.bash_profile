# ~/.dotfiles/.bash_profile
# read on login shells only (alternative to .bash_login)

export DOTFILES=$HOME/.dotfiles
PATH=$PATH:$HOME/.rvm/bin             # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

source $DOTFILES/bash/.bashrc
