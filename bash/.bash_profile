# ~/.dotfiles/.bash_profile
# read on login shells only (alternative to .bash_login)

PATH="$PATH:~/.rvm/bin"             # Add RVM to PATH for scripting
[[ -s "~/.rvm/scripts/rvm" ]] && source "~/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

source ~/.bashrc
