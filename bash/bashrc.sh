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

command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

source $BASH_DOTFILES/completions.sh

# git prompt for linux
if [ -r /usr/share/git/git-prompt.sh ]; then
  source /usr/share/git/git-prompt.sh
fi
source $BASH_DOTFILES/prompt.sh

##
# os specific
case "$OSTYPE" in
  darwin*)  [ -f "$BASH_DOTFILES/bashrc-osx.sh" ] && source "$BASH_DOTFILES/bashrc-osx.sh"
            ;;
  linux*)   [ -f "$BASH_DOTFILES/bashrc-linux.sh" ] && source "$BASH_DOTFILES/bashrc-linux.sh"
            ;;
esac
