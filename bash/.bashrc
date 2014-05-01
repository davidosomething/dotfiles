for script in "functions" "vars" "aliases" "paths"; do
  source $HOME/.dotfiles/shell/${script}
done

[ -z "$PS1" ] && return

# bash options
set -o notify
shopt -s checkwinsize # useful for tmux
shopt -s histappend
shopt -s nocaseglob
shopt -s extglob
shopt -s cdspell
shopt -s cdable_vars

for script in "completions" "prompt"; do
  source $BASH_DOTFILES/${script}.bash
done

# program aliases
has_program hub   && eval "$(hub alias -s)"
has_program rbenv && eval "$(rbenv init -)"
$HAS_BREW && source_if_exists "$BREW_PREFIX/etc/profile.d/z.sh"

# local
source_if_exists $HOME/.bashrc.local
