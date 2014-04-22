# dotfiles/bash/aliases.sh
# sourced by both .zshrc and .bashrc, so keep it bash compatible

alias reload="exec $SHELL"
alias _="sudo"

# paths and dirs
alias ..='cd ..'
alias ....='cd ../..'
alias cd..='cd ..'
alias dirs="dirs -v"                  # default to vert, use -l for list
alias l="ls -l"

# bin
alias b="brew"
alias g="git"
alias u="update"

# function-type aliases
alias publicip="curl icanhazip.com"

# default flags for programs
alias ag="ag -i"
alias df="df -h"
alias ln="ln -v"
alias rsync="rsync --human-readable --partial --progress --exclude-from=$HOME/.cvsignore"
alias wget="wget --no-check-certificate"

# quick edits
alias e="vim"
alias mvim="vim"
alias gvim="vim"
alias evars="e $BASH_DOTFILES/vars.sh"
alias epaths="e $BASH_DOTFILES/paths.sh"
alias ealiases="e $BASH_DOTFILES/aliases.sh"
alias efunctions="e $BASH_DOTFILES/functions.sh"
alias evimrc="e $DOTFILES/vim/vimrc"
alias egvimrc="e $DOTFILES/vim/gvimrc"
alias ebashrc="e $BASH_DOTFILES/bashrc.sh"
alias elbashrc="e $HOME/.bashrc.local"

alias ehosts="sudo vim /etc/hosts"

# server
alias pyserve="python -m SimpleHTTPServer"

##
# os specific
case "$OSTYPE" in
  darwin*)  source "$BASH_DOTFILES/aliases-osx.sh"
            ;;
  linux*)   source "$BASH_DOTFILES/aliases-linux.sh"
            ;;
esac
