# ~/.dotfiles/.bash_profile
# read on login shells only (alternative to .bash_login)

if [ -f /opt/local/etc/bash_completion ]; then
    . /opt/local/etc/bash_completion
fi

source ~/.bashrc
