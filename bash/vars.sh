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
export AUTOJUMP_IGNORE_CASE=1

export EDITOR=vim

# git
export GIT_PAGER="less -erFX"

# -F exit if only one screen, -X noclearscreen
export LESS=-erF

# node
export NODE_PATH="/usr/local/lib/node_modules"

# rbenv
export RBENV_ROOT="$HOME/.rbenv"

################################################################################
# useful file paths
export APACHE_HTTPD_CONF="$APACHE_CONF/httpd.conf"
export APACHE_HTTPD_VHOSTS="$APACHE_CONF/extra/httpd-vhosts.conf"
export PHP_INI="$(php -r "echo php_ini_loaded_file();")"

##
# os specific
case "$OSTYPE" in
  darwin*)  [ -f "$BASH_DOTFILES/vars-osx.sh" ] && source "$BASH_DOTFILES/vars-osx.sh"
            ;;
  linux*)   [ -f "$BASH_DOTFILES/vars-linux.sh" ] && source "$BASH_DOTFILES/vars-linux.sh"
            ;;
esac
