####
# ~/.dotfiles/.zshenv
# zshenv is always sourced, even for bg jobs
# this file applies to all OS's

export ZDOTDIR="$HOME/.dotfiles/zsh"
# environment vars available to scripts
export EDITOR="vim"

##
# paths, locals
path=( /usr/local/bin $path )         # default required paths

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
source ~/.zshenv.local >/dev/null 2>&1 # may or may not exist

##
# back to paths
path=( $HOME/bin $path )

# Add RVM to PATH for scripting
path=( $HOME/.rvm/bin $path )

# remove duplicate paths
typeset -U path cdpath fpath manpath
