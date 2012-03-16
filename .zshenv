####
# zshenv is always sourced, even for bg jobs
# this file applies to all OS's

# environment vars available to scripts
export COLORS=$(tput colors 2>/dev/null) # provide COLORS to environment, used by vimrc
export EDITOR=vim

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

# assume rbenv installed, needs precedence over other paths such as macports
# since macvim +ruby adds macports ruby to path
path=( $HOME/.rbenv/bin $path )
# enable rbenv shims and autocomplete, modifies path so keep in .zshenv
if which rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi


# remove duplicate paths
typeset -U path cdpath fpath manpath
