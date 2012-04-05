####
# zshenv is always sourced, even for bg jobs
# this file applies to all OS's

export ZDOTDIR="$HOME/.dotfiles"
# environment vars available to scripts
# provide COLORS to environment, used by vimrc
export COLORS="$(tput colors 2>/dev/null)" 
export EDITOR="vim"

##
# paths, locals
path=( /usr/local/bin $path )         # default required paths

##
# local
# source .zshenv.local.OS from here if you want defaults
source ~/.zshenv.local >/dev/null 2>&1 # may or may not exist

##
# back to paths
path=( $HOME/bin $path )

# Add RVM to PATH for scripting
path=( $HOME/.rvm/bin $path )

# remove duplicate paths
typeset -U path cdpath fpath manpath
