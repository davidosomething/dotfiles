set -o notify
shopt -s checkwinsize     # useful for tmux, update $LINES and $COLUMNS
shopt -s cmdhist          # save multi-line commands in one
shopt -s histappend
shopt -s dotglob          # expand filenames starting with dots too
shopt -s nocaseglob
shopt -s extglob
shopt -s cdspell          # autocorrect dir names
shopt -s cdable_vars
shopt -s no_empty_cmd_completion    # don't try to complete empty lines

