####
# ~/.dotfiles/bash/vars

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
export EDITOR="vim -fnX"

# -F exit if only one screen, -X noclearscreen
export LESS=-erF

# git
export GIT_PAGER="less -erFX"

# rbenv
export RBENV_ROOT="$HOME/.rbenv"

# node
export NODE_PATH="/usr/local/lib/node_modules"

################################################################################
# useful vars
if [[ $+commands[php] == 1 ]]; then
  export PHPVER=$( php -v | sed 1q | awk '{print $2}' )
  export PHPMINORVER=$( echo $PHPVER | awk -F="." '{split($0,a,"."); print a[1]"."a[2]}' )
  export PHPMINORVERNUM=$( echo $PHPVER | awk -F="." '{split($0,a,"."); print a[1]a[2]}' )
fi

################################################################################
# useful file paths
export APACHE_HTTPD_CONF="$APACHE_CONF/httpd.conf"
export APACHE_HTTPD_VHOSTS="$APACHE_CONF/extra/httpd-vhosts.conf"
