# zsh/keybindings.zsh
#
# These keys should also be set in shell/.inputrc
#
# `cat -e` to test out keys
#
# \e is the same as ^[ is the escape code for <Esc>
# Prefer ^[ since it mixes better with the letter form [A
#

export DKO_SOURCE="${DKO_SOURCE} -> keybindings.zsh"

# disable ^S and ^Q terminal freezing
unsetopt flowcontrol

# VI mode
bindkey -v

# search through history starting with current buffer contents
# bindkey "\e\eA"  history-beginning-search-backward
# bindkey "\e\eB"  history-beginning-search-forward

# fix backspace
# bindkey '^?'    backward-delete-char

# home/end
# Home/Fn-Left
bindkey '^[[H'  beginning-of-line
# bindkey '^[[1~' beginning-of-line
# bindkey '^[OH'  beginning-of-line

# End/Fn-Right
bindkey '^[[F'  end-of-line
# bindkey '^[[4~' end-of-line
# bindkey '^[OF'  end-of-line

# ============================================================================
# macbook, iterm2, xterm-256color-italic, zsh
# ============================================================================

# Home/Fn-Left
bindkey           '^[[H'  beginning-of-line
bindkey -M vicmd  '^[[H'  beginning-of-line

# End/Fn-Right
bindkey           '^[[F'  end-of-line
bindkey -M vicmd  '^[[F'  end-of-line

# fix delete - Fn-delete
bindkey '^[[3~' delete-char

# Left and right should jump through words
# Opt-Left
bindkey '^[^[[D' backward-word
# Opt-Right
bindkey '^[^[[C' forward-word
# C-L
bindkey '^[[1;5D' backward-word
#bindkey '\e[1;5D' backward-word
# C-R
bindkey '^[[1;5C' forward-word
#bindkey '\e[1;5C' forward-word

# Up and down search history filtered using already entered contents
# Up
bindkey '^[[A'  history-search-backward
# Down
bindkey '^[[B'  history-search-forward

# PgUp/Dn navigate through history like regular up/down
bindkey -M viins "^[[5~" up-history
bindkey -M vicmd "^[[5~" up-history
bindkey -M viins "^[[6~" down-history
bindkey -M vicmd "^[[6~" down-history
