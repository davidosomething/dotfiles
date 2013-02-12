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

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

source "$HOME/.dotfiles/bash/vars"
source "$BASH_DOTFILES/paths"
source "$BASH_DOTFILES/aliases"
source "$BASH_DOTFILES/functions"
source "$BASH_DOTFILES/prompt"

##
# os specific
case "$OSTYPE" in
  darwin*)  source "$BASH_DOTFILES/bashrc-osx"
            ;;
  linux*)   source "$BASH_DOTFILES/bashrc-linux"
            ;;
esac
