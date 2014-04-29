source $HOME/.dotfiles/shell/functions
source $HOME/.dotfiles/shell/vars
source $HOME/.dotfiles/shell/aliases
source $HOME/.dotfiles/shell/paths

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
$HAS_BREW && source_if_exists "$BREW_PREFIX/etc/profile.d/z.sh"

# local
source_if_exists $HOME/.bashrc.local
