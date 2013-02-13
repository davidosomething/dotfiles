####
# ~/.dotfiles/.zshenv
# zshenv is always sourced, even for bg jobs
# this file applies to all OS's

# paths must be set first so the vars can use correct executables if they need
# e.g. for $PHPVERSION we need to use PHP in brew path, not default path
source $HOME/.dotfiles/bash/paths
source $HOME/.dotfiles/bash/vars

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
