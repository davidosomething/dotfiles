####
# ~/.dotfiles/.zshenv
# zshenv is always sourced, even for bg jobs
# this file applies to all OS's

source ~/.dotfiles/bash/vars
source $BASH_DOTFILES/paths

##
# OS specific
case "$OSTYPE" in
  darwin*)  source $ZDOTDIR/zshenv-osx
            ;;
  linux*)   source $ZDOTDIR/zshenv-linux
            ;;
esac

##
# local
[ -e ~/.zshenv.local ] && source ~/.zshenv.local

# remove duplicate paths
typeset -U path cdpath fpath manpath
