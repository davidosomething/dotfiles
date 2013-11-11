####
# dotfiles/bash/bashrc.sh
# read on all shells and subshells

[ -z "$PS1" ] && return

##
# bash options
set -o notify
shopt -s checkwinsize # useful for tmux
shopt -s histappend
shopt -s nocaseglob
shopt -s extglob
shopt -s cdspell
shopt -s cdable_vars

source $HOME/.dotfiles/bash/vars.sh
source $BASH_DOTFILES/paths.sh
source $BASH_DOTFILES/aliases.sh # sources os specifics too
source $BASH_DOTFILES/functions.sh # sources os specifics too
source $BASH_DOTFILES/completions.sh
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

# prompt
# git prompt for linux
source_if_exists "/usr/share/git/git-prompt.sh"
source $BASH_DOTFILES/prompt.sh

##
# os specific
case "$OSTYPE" in
  darwin*)  source "$BASH_DOTFILES/bashrc-osx.sh"
            ;;
  linux*)   source "$BASH_DOTFILES/bashrc-linux.sh"
            ;;
esac

##
# local
source_if_exists $HOME/.bashrc.local
