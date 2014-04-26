source $HOME/.dotfiles/shell/vars
source $DOTFILES/shell/paths
source $DOTFILES/shell/aliases
source $DOTFILES/shell/functions

[ -z "$PS1" ] && return

# bash options
set -o notify
shopt -s checkwinsize # useful for tmux
shopt -s histappend
shopt -s nocaseglob
shopt -s extglob
shopt -s cdspell
shopt -s cdable_vars

source $BASH_DOTFILES/completions.sh
source $BASH_DOTFILES/prompt.sh

# programs
has_program rbenv && eval "$(rbenv init -)"
has_program hub   && eval "$(hub alias -s)"
has_program brew  && source_if_exists "$(brew --prefix)/etc/profile.d/z.sh"

# local
source_if_exists $HOME/.bashrc.local
