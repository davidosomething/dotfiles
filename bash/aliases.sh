# dotfiles/bash/aliases.sh
# sourced by both .zshrc and .bashrc, so keep it bash compatible

alias dotfiles="$DOTFILES/bootstrap.sh"
alias reload="exec $SHELL"
alias _="sudo"

# paths and dirs
alias ..='cd ..'
alias ....='cd ../..'
alias cd..='cd ..'
alias dirs="dirs -v"                  # default to vert, use -l for list
alias l="ls -l"

# function-type aliases
alias publicip="curl icanhazip.com"

# default flags for programs
alias df="df -h"
alias ln="ln -v"
alias rsync="rsync --human-readable --partial --progress --exclude-from=$HOME/.cvsignore"
alias wget="wget --no-check-certificate"

# tmux
alias remux="if tmux has 2>/dev/null; then tmux attach; else tmux new $SHELL; fi"
alias demux="tmux detach"

# quick edits
alias evars="e $BASH_DOTFILES/vars.sh"
alias epaths="e $BASH_DOTFILES/paths.sh"
alias ealiases="e $BASH_DOTFILES/aliases.sh"
alias efunctions="e $BASH_DOTFILES/functions.sh"
alias evimrc="e $HOME/.vimrc"
alias egvimrc="e $HOME/.gvimrc"
alias ebashrc="e $HOME/.bashrc"
alias elbashrc="e $HOME/.bashrc.local"

alias ehosts="sudo vim /etc/hosts"

# php
alias ephpini="e $PHP_INI"
alias art="php artisan"
alias cunt="COMPOSER_CACHE_DIR=/dev/null composer update"

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
