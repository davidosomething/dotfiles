####
# .dotfiles/zshenv.zsh
# zshenv is always sourced, even for bg jobs
# this file applies to all OS's

# this is where ZSH looks for .zsh* files
export ZDOTDIR="$HOME/.zsh"

##
# paths must be set first so the vars can use correct executables if they need
# e.g. for $PHPVERSION we need to use PHP in brew path, not default path
source $HOME/.dotfiles/bash/paths.sh
source $HOME/.dotfiles/bash/vars.sh

##
# these are to override BASH variables
export ZSH_DOTFILES="$DOTFILES/zsh"
source $ZSH_DOTFILES/vars.zsh

##
# OS specific
case "$OSTYPE" in
  darwin*)  source $ZSH_DOTFILES/zshenv-osx.zsh
            ;;
  linux*)   source $ZSH_DOTFILES/zshenv-linux.zsh
            ;;
esac

##
# add zsh completions from git subrepo
fpath=( $ZSH_DOTFILES/zsh-completions $fpath )

##
# local
[ -f "$ZDOTDIR/.zshenv.local" ] && source $ZDOTDIR/.zshenv.local

##
# remove duplicate paths
typeset -U path cdpath fpath manpath
