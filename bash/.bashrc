# ~/.dotfiles/bash/.bashrc
# read on all shells and subshells
export DOTFILES=~/.dotfiles
export BASH_DOTFILES="$DOTFILES/bash"

##
# bash options
set -o notify
shopt -s checkwinsize                 # useful for tmux
shopt -s histappend
shopt -s nocaseglob
shopt -s extglob
shopt -s cdspell

source "$BASH_DOTFILES/.bash_aliases"
##
# os specific
case "$OSTYPE" in
  darwin*)  source "$BASH_DOTFILES/.bash_aliases.osx"
            source "$BASH_DOTFILES/.bashrc.osx"
            ;;
  linux*)   source "$BASH_DOTFILES/.bash_aliases.linux"
            source "$BASH_DOTFILES/.bashrc.linux"
            ;;
esac

source "$BASH_DOTFILES/.bash_prompt"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
