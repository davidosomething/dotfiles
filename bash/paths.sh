####
# ~/.dotfiles/bash/paths

export NODE_PATH="/usr/local/lib/node_modules"

# bottom to top precedence
PATH="/usr/local/bin:/usr/local/sbin:$PATH"
PATH="/usr/local/share/npm/bin:$PATH"
PATH="$(brew --prefix josegonzalez/php/php54)/bin:$PATH"
PATH="$HOME/bin:$HOME/.dotfiles/bin:$PATH"
export PATH
