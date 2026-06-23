# ============================================================================
# Keybindings
#
# Find defaults in
# https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Zle-Widgets
# \e is the same as ^[ is the escape code for <Esc>
# Prefer ^[ since it mixes better with the letter form [A
#
# `cat -e` - test what the terminal emulator is reporting for a keypress
#
# `bindkey '^w'` - shows what is bound to ^w. If it reports something
# different than is here, it may be coming from .inputrc
#
# Tested on macbook iterm2 and magic keyboard+arch, xterm-256color
# - Need both normal mode and vicmd mode
# ============================================================================

# VI mode, and make -M main === -M viins
bindkey -v

# ----------------------------------------------------------------------------
# Keybindings - Completion with tab
# Cancel and reset prompt with ctrl-c
# ----------------------------------------------------------------------------

# shift-tab to select previous result
bindkey -M menuselect '^[[Z' reverse-menu-complete

# fix prompt (and side-effect of exiting menuselect) on ^C
bindkey -M menuselect '^C' reset-prompt

# ----------------------------------------------------------------------------
# Keybindings - Movement keys
# The 1;3 variants are for wezterm and kitty
# ----------------------------------------------------------------------------

# C-Left
bindkey -M viins '^[[1;5D' vi-backward-word
bindkey -M vicmd '^[[1;5D' vi-backward-word
bindkey -M viins '^b' vi-backward-word
bindkey -M vicmd '^b' vi-backward-word

# C-Right
bindkey -M viins '^[[1;5C' vi-forward-word
bindkey -M vicmd '^[[1;5C' vi-forward-word
# normally it is vi-backward-backward-kill-word
bindkey -M viins '^w' vi-forward-word
bindkey -M vicmd '^w' vi-forward-word

bindkey -M viins '^e' vi-forward-word-end
bindkey -M vicmd '^e' vi-forward-word-end

# Home/Fn-Left
bindkey -M viins '^[[H' vi-beginning-of-line
bindkey -M vicmd '^[[H' vi-beginning-of-line

# End/Fn-Right
bindkey -M viins '^[[F' vi-end-of-line
bindkey -M vicmd '^[[F' vi-end-of-line

# ----------------------------------------------------------------------------
# Keybindings: Editing keys
# ----------------------------------------------------------------------------

# Opt-Left kill left
bindkey -M viins '^[^[[D' vi-backward-kill-word
bindkey -M vicmd '^[^[[D' vi-backward-kill-word
bindkey -M viins '^[[1;3D' vi-backward-kill-word
# Opt-Right kill right
bindkey -M viins '^[^[[C' kill-word
bindkey -M vicmd '^[^[[C' kill-word
bindkey -M viins '^[[1;3C' kill-word

# fix delete - Fn-delete
# Don't bind in vicmd mode
bindkey '^[[3~' delete-char

# Allow using backspace from :normal [A]ppend
bindkey -M viins '^?' backward-delete-char

# ----------------------------------------------------------------------------
# Keybindings: History navigation
# Don't bind in vicmd mode, so I can edit multiline commands properly.
# ----------------------------------------------------------------------------

# Up/Down search history filtered using already entered contents
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# PgUp/Dn navigate through history like regular up/down
bindkey '^[[5~' up-history
bindkey '^[[6~' down-history
