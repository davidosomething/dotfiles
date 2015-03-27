# zsh plugins

_load_plugins() {
  local plugins_dir
  plugins_dir="$ZDOTDIR/plugins"

  source_if_exists "${plugins_dir}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  source_if_exists "${plugins_dir}/opp/opp.zsh"
  source "${plugins_dir}/opp/opp/*.zsh"
}

_load_plugins

# requires "zsh-history-substring-search/zsh-history-substring-search"
# bind UP and DOWN arrow keys
# [ -f "$ZDOTDIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ] && {
#   bindkey '^[[A' history-substring-search-up
#   bindkey '^[[B' history-substring-search-down
# }

# [ -f "$ZDOTDIR/zsh-autosuggestions/autosuggestions.zsh" ] && {
#   source "$ZDOTDIR/zsh-autosuggestions/autosuggestions.zsh"
#   # Enable autosuggestions automatically
#   zle-line-init() {
#       zle autosuggest-start
#   }
#   zle -N zle-line-init
#
#   # accept
#   bindkey '^f' vi-forward-word
#
#   # use ctrl+t to toggle autosuggestions(hopefully this wont be needed as
#   # zsh-autosuggestions is designed to be unobtrusive)
#   bindkey '^T' autosuggest-toggle
# }
