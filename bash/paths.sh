####
# ~/.dotfiles/bash/paths

export NODE_PATH="/usr/local/lib/node_modules"

# bottom to top precedence
PATH="/usr/local/bin:$PATH"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/local/share/npm/bin:$PATH"

if [[ $+commands[brew] == 1 ]]; then
  PATH="$(brew --prefix josegonzalez/php/php54)/bin:$PATH"
fi

PATH="$HOME/.dotfiles/bin:$PATH"
PATH="$HOME/bin:$PATH"
export PATH
