# shell/vars.bash
#
# Some things from env are here since macOS/OS X doesn't start new env for each
# term and we may need to reset the values
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/vars.bash {"

# ============================================================================
# Locale
# ============================================================================

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# https://blog.packagecloud.io/eng/2017/02/21/set-environment-variable-save-thousands-of-system-calls/
[ -h /etc/localtime ] && export TZ=:/etc/localtime

# ============================================================================
# Dotfile paths
# ============================================================================

export DOTFILES="${HOME}/.dotfiles"
export BDOTDIR="${DOTFILES}/bash"
export LDOTDIR="${DOTFILES}/local"
export VDOTDIR="${DOTFILES}/vim"
export ZDOTDIR="${DOTFILES}/zsh"

# ============================================================================
# History -- except HISTFILE location is set by shell rc file
# ============================================================================

export SAVEHIST=1000
export HISTSIZE=1000
export HISTFILESIZE="$HISTSIZE"
export HISTCONTROL=ignoredups
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# ============================================================================
# program settings
# ============================================================================

# ----------------------------------------------------------------------------
# for rsync and cvs
# ----------------------------------------------------------------------------

export CVSIGNORE="${DOTFILES}/git/.gitignore"

# ----------------------------------------------------------------------------
# editor
# ----------------------------------------------------------------------------

export EDITOR="vim"
export VISUAL="gvim"
if [ -n "$SSH_CONNECTION" ] || [ -n "$TMUX" ]; then export VISUAL="vim"; fi

# ----------------------------------------------------------------------------
# pager
# ----------------------------------------------------------------------------

export PAGER="less"
export GIT_PAGER="$PAGER"

# ----------------------------------------------------------------------------
# others
# see after.bash for configurations that require access to these vars or
# functions like dko::has
# ----------------------------------------------------------------------------

# ack
export ACKRC="${DOTFILES}/ack/dot.ackrc"

# apache
# shellcheck source=/dev/null
[ -f "/etc/apache2/envvars" ] && . "/etc/apache2/envvars"

# atom editor
export ATOM_HOME="${XDG_CONFIG_HOME}/atom"

# aws
export AWS_CONFIG_FILE="${DOTFILES}/aws/config"
# credentials are per system

# bazaar
export BZRPATH="${XDG_CONFIG_HOME}/bazaar"
export BZR_PLUGIN_PATH="${XDG_DATA_HOME}/bazaar"
export BZR_HOME="${XDG_CACHE_HOME}/bazaar"

# composer
export COMPOSER_HOME="${XDG_CONFIG_HOME}/composer"
export COMPOSER_CACHE_DIR="${XDG_CACHE_HOME}/composer"

# docker
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"

# go
# used in shell/paths
export GOPATH="${HOME}/.local/go"

# homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# java in java.bash

# less
# -F quit if one screen (default)
# -N line numbers
# -R raw control chars (default)
# -X don't clear screen on quit
# -e LESS option to quit at EOF
export LESS="-eFRX"
# disable less history
export LESSHISTFILE=-

# man
export MANWIDTH=88
export MANPAGER="$PAGER"

# mysql
export MYSQL_HISTFILE="${XDG_CACHE_HOME}/mysql_histfile"

# node moved to shell/node loaded in shell/before

# neovim
#export NVIM_PYTHON_LOG_FILE="${DOTFILES}/logs/nvim_python.log"

# php moved to shell/php loaded in shell/before

# python moved to shell/python loaded in shell/before

# R
export R_ENVIRON_USER="${DOTFILES}/r/dot.Renviron"
export R_LIBS_USER="${HOME}/.local/lib/R/library/"

# readline
export INPUTRC="${DOTFILES}/shell/dot.inputrc"

# ruby moved to shell/ruby loaded in shell/before

# for shellcheck
export SHELLCHECK_OPTS="--exclude=SC1090,SC2148"

# travis cli
export TRAVIS_CONFIG_PATH="${XDG_CONFIG_HOME}/travis"

# vagrant
export VAGRANT_HOME="${XDG_CONFIG_HOME}/vagrant"

# weechat
export WEECHAT_HOME="${DOTFILES}/weechat"

# wp cli
export WP_CLI_CONFIG_PATH="${XDG_CONFIG_HOME}/wp-cli"

# X11 - for starting via xinit or startx
export XINITRC="${DOTFILES}/linux/.xinitrc"
export XAPPLRESDIR="${DOTFILES}/linux"

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
