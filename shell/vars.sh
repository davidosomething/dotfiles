# shell/vars.sh

# Some things from env are here since macOS/OS X doesn't start new env for each
# term and we may need to reset the values

export DKO_SOURCE="${DKO_SOURCE} -> shell/vars.sh {"

# dot.bash_profile did this early
# @TODO maybe dot.bash_profile needs to skip init
DOTFILES_OS="${DOTFILES_OS:-$(uname)}"
export DOTFILES_OS

case "$DOTFILES_OS" in
  Darwin*) ;;
  FreeBSD*) export DOTFILES_DISTRO="FreeBSD" ;;
  OpenBSD*) export DOTFILES_DISTRO="OpenBSD" ;;

  *)
    # for pacdiff
    export DIFFPROG="nvim -d"

    # X11 - for starting via xinit or startx
    export XAPPLRESDIR="${DOTFILES}/linux"

    if [ -f /etc/arch-release ]; then
      # manjaro too
      export DOTFILES_DISTRO="archlinux"
    elif [ -f /etc/debian_version ]; then
      export DOTFILES_DISTRO="debian"
    elif [ -f /etc/fedora-release ]; then
      export DOTFILES_DISTRO="fedora"
    elif [ -f /etc/synoinfo.conf ]; then
      export DOTFILES_DISTRO="synology"
    fi
  ;;
esac

# ============================================================================
# Locale
# ============================================================================

export LANG="en_US.UTF-8"
export LC_ALL="$LANG"

# ============================================================================
# Dotfile paths
# ============================================================================

export DOTFILES="${HOME}/.dotfiles"
export BDOTDIR="${DOTFILES}/bash"
export LDOTDIR="${DOTFILES}/local"
export VDOTDIR="${DOTFILES}/vim"
export ZDOTDIR="${DOTFILES}/zsh"

# ============================================================================
# XDG
# ============================================================================

export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# user-dirs.dirs doesn't exist on macOS/OS X so check first.
# Exporting is fine since the file is generated via xdg-user-dirs-update
# and should have those vars. I am just using the defaults but want them
# explicitly defined.
# shellcheck source=/dev/null
[ -f "${XDG_CONFIG_HOME}/user-dirs.dirs" ] &&
  . "${XDG_CONFIG_HOME}/user-dirs.dirs" &&
  export \
    XDG_DESKTOP_DIR \
    XDG_DOWNLOAD_DIR \
    XDG_TEMPLATES_DIR \
    XDG_PUBLICSHARE_DIR \
    XDG_DOCUMENTS_DIR \
    XDG_MUSIC_DIR \
    XDG_PICTURES_DIR \
    XDG_VIDEOS_DIR &&
  DKO_SOURCE="${DKO_SOURCE} -> ${XDG_CONFIG_HOME}/user-dirs.dirs"

[ -z "$XDG_DOWNLOAD_DIR" ] && [ -d "${HOME}/Downloads" ] &&
  export XDG_DOWNLOAD_DIR="${HOME}/Downloads"

# ============================================================================
# History -- except HISTFILE location is set by shell rc file
# ============================================================================

export HISTSIZE=50000
export HISTFILESIZE=$HISTSIZE
export SAVEHIST=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTIGNORE="ll:ls:cd:cd -:pwd:exit:date"

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

export EDITOR='vim'
export VISUAL="$EDITOR"

# this requires Defaults env_keep += "SYSTEMD_EDITOR" in your sudo settings to
# take effect. See https://unix.stackexchange.com/a/408419
export SYSTEMD_EDITOR="$EDITOR"

# ----------------------------------------------------------------------------
# pager
# ----------------------------------------------------------------------------

export PAGER='less'

# ----------------------------------------------------------------------------
# others
# see after.sh for configurations that require access to these vars or
# functions like __dko_has
# ----------------------------------------------------------------------------

# ack
export ACKRC="${DOTFILES}/ack/dot.ackrc"

# asdf
export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"

# aws
export AWS_CONFIG_FILE="${DOTFILES}/aws/config"
# credentials are per system

# babel
export BABEL_CACHE_PATH="${HOME}/.local/babel.json"

# bazaar
export BZRPATH="${XDG_CONFIG_HOME}/bazaar"
export BZR_PLUGIN_PATH="${XDG_DATA_HOME}/bazaar"
export BZR_HOME="${XDG_CACHE_HOME}/bazaar"

# composer
export COMPOSER_HOME="${XDG_CONFIG_HOME}/composer"
export COMPOSER_CACHE_DIR="${XDG_CACHE_HOME}/composer"

# docker
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"

# gpg
# on mac this should already set by dotfiles.plist using launchd
export GNUPGHOME="${XDG_CONFIG_HOME}/gnupg"

# go
# Used in shell/paths.sh so not in shell/go.sh
export GOPATH="${HOME}/.local/go"

# gradle and java in java.sh

# less
# -F quit if one screen (default)
# -N line numbers
# -R raw control chars (default)
# -X don't clear screen on quit
# -e LESS option to quit at EOF
export LESS="-eFRX"
# disable less history
export LESSHISTFILE=-

# custom LS_COLORS for deb, might not want on all machines
# @TODO
export LS_COLORS="no=00:fi=00:di=00;34:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:"

# man
export MANWIDTH=88
export MANPAGER="$PAGER"

# mysql
export MYSQL_HISTFILE="${XDG_CACHE_HOME}/mysql_histfile"

# node moved to shell/node loaded in shell/before

# neovim
export NVIM_PYTHON_LOG_FILE="${DOTFILES}/logs/nvim_python.log"

# php moved to shell/php loaded in shell/before

# python moved to shell/python loaded in shell/before

# R
export R_ENVIRON_USER="${DOTFILES}/r/dot.Renviron"
export R_LIBS_USER="${HOME}/.local/lib/R/library/"

# readline
export INPUTRC="${DOTFILES}/shell/dot.inputrc"

# -shellcheck
export SHELLCHECK_OPTS="--exclude=SC1090,SC2148"

# terminfo
# DO NOT DO THIS, shells are fine, but tmux will not know where to look!
#export TERMINFO="${XDG_DATA_HOME}/terminfo"

# vagrant
export VAGRANT_HOME="${XDG_DATA_HOME}/vagrant"
export VAGRANT_ALIAS_FILE="${XDG_DATA_HOME}/vagrant/aliases"

# wp cli
export WP_CLI_CONFIG_PATH="${XDG_CONFIG_HOME}/wp-cli"

export YAMLLINT_CONFIG_FILE="${DOTFILES}/yamllint/config"

# yarn cache
# https://github.com/yarnpkg/yarn/issues/3208
export YARN_CACHE_FOLDER="${XDG_CACHE_HOME}/yarn"

DKO_SOURCE="${DKO_SOURCE} }"
