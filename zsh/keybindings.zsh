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

# ============================================================================
# Tested on macbook, iterm2, xterm-256color-italic, zsh
# - Need both normal mode and vicmd mode
# ============================================================================

# VI mode
bindkey -v

# Home/Fn-Left
bindkey           '^[[H'    beginning-of-line
bindkey -M vicmd  '^[[H'    beginning-of-line

# End/Fn-Right
bindkey           '^[[F'    end-of-line
bindkey -M vicmd  '^[[F'    end-of-line

# fix delete - Fn-delete
bindkey           '^[[3~'   delete-char
bindkey -M vicmd  '^[[3~'   delete-char

# Left and right should jump through words
# Opt-Left
bindkey           '^[^[[D'  backward-word
bindkey -M vicmd  '^[^[[D'  backward-word
# Opt-Right
bindkey           '^[^[[C'  forward-word
bindkey -M vicmd  '^[^[[C'  forward-word
# C-L
bindkey           '^[[1;5D' backward-word
bindkey -M vicmd  '^[[1;5D' backward-word
# C-R
bindkey           '^[[1;5C' forward-word
bindkey M vicmd   '^[[1;5C' forward-word

# ----------------------------------------------------------------------------
# History navigation
# Don't bind in vicmd mode, so I can edit multiline commands properly.
# ----------------------------------------------------------------------------

# Up/Down search history filtered using already entered contents
bindkey '^[[A'  history-search-backward
bindkey '^[[B'  history-search-forward

# PgUp/Dn navigate through history like regular up/down
bindkey '^[[5~' up-history
bindkey '^[[6~' down-history
