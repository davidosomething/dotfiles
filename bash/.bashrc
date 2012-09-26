####
# ~/.dotfiles/bash/.bashrc
# read on all shells and subshells

##
# bash options
set -o notify
shopt -s checkwinsize                 # useful for tmux
shopt -s histappend
shopt -s nocaseglob
shopt -s extglob
shopt -s cdspell
shopt -s cdable_vars

source "~/.dotfiles/bash/vars"
source "$BASH_DOTFILES/paths"
source "$BASH_DOTFILES/aliases"
source "$BASH_DOTFILES/prompt"

##
# os specific
case "$OSTYPE" in
  darwin*)  source "$BASH_DOTFILES/bashrc-osx"
            ;;
  linux*)   source "$BASH_DOTFILES/bashrc-linux"
            ;;
esac

# Load RVM into a shell session *as a function*
[[ -s "~/.rvm/scripts/rvm" ]] && source "~/.rvm/scripts/rvm"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
