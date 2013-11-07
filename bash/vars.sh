################################################################################
# dotfile paths
export DOTFILES="$HOME/.dotfiles"
export BASH_DOTFILES="$DOTFILES/bash"
export ZSH_DOTFILES="$DOTFILES/zsh"

################################################################################
# Shell settings
export HISTSIZE=500
export SAVEHIST=500

################################################################################
# program settings
export EDITOR=vim

# -F exit if only one screen, -X noclearscreen
export LESS=-erF

# git
export GIT_PAGER="less -erFX"

# rbenv
export RBENV_ROOT="$HOME/.rbenv"

# node
export NODE_PATH="/usr/local/lib/node_modules"

################################################################################
# useful file paths
export APACHE_HTTPD_CONF="$APACHE_CONF/httpd.conf"
export APACHE_HTTPD_VHOSTS="$APACHE_CONF/extra/httpd-vhosts.conf"

##
# os specific
case "$OSTYPE" in
  darwin*)  [ -f "$BASH_DOTFILES/vars-osx.sh" ] && source "$BASH_DOTFILES/vars-osx.sh"
            ;;
  linux*)   [ -f "$BASH_DOTFILES/vars-linux.sh" ] && source "$BASH_DOTFILES/vars-linux.sh"
            ;;
esac
