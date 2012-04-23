####
# ~/.dotfiles/.zshenv
# zshenv is always sourced, even for bg jobs
# this file applies to all OS's

export ZDOTDIR="$HOME/.dotfiles/zsh"
export EDITOR="vim"
export PATH="$HOME/bin:$HOME/.rvm/bin:/usr/local/bin:$PATH"

##
# OS specific
case "$OSTYPE" in
  darwin*)  source $ZDOTDIR/.zshenv.local.osx
            ;;
  linux*)   source $ZDOTDIR/.zshenv.local.linux
            ;;
esac

##
# local
[ -e "~/.zshenv.local" ] && source ~/.zshenv.local

# remove duplicate paths
typeset -U path cdpath fpath manpath

