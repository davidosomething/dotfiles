# ~/.dotfiles/.bash_profile
# read on login shells only (alternative to .bash_login)

source ~/.dotfiles/.bashrc

PATH=$PATH:$HOME/.rvm/bin             # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
