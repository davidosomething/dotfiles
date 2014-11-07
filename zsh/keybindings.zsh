##
# .dotfiles/zsh/keybindings.zsh

# disable ^S and ^Q terminal freezing
unsetopt flowcontrol

# search through history starting with current buffer contents
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
# fix backspace
bindkey '^?' backward-delete-char
# fix delete
bindkey '^[[3~' delete-char
# fix up and down to end of line after history
bindkey '\e[A'  history-search-backward  # Up
bindkey '\e[B'  history-search-forward   # Down
# option+ left and right should jump through words
bindkey '\e\e[C' forward-word            # Right
bindkey '\e\e[D' backward-word           # Left
# ctrl-left/right word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
# home/end
bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[OF' end-of-line
# VI mode allow home and end
bindkey -M vicmd '^[[H' beginning-of-line
bindkey -M vicmd '^[[F' end-of-line

