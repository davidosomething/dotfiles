##
# zshenv is always sourced, even for bg jobs
# this file applies to all OS's

# specify new dotfiles folder
zdotdir=$HOME/.dotfiles

# provide COLORS to environment, used by vimrc
export COLORS=$(tput colors 2>/dev/null)

# default required paths
path=( /usr/local/bin $path )

##
# local
# source .zshenv.local.OS from here if you want defaults
source ~/.zshenv.local >/dev/null 2>&1 # may or may not exist

path=( $HOME/bin $path )

# assume rbenv installed, needs precedence over other paths such as macports
# since macvim +ruby adds macports ruby to path
path=( $HOME/.rbenv/bin $path )
# enable rbenv shims and autocomplete
eval "$(rbenv init -)"

# remove duplicate paths
typeset -U path cdpath fpath manpath
