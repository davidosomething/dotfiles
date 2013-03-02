####
# .dotfiles/bash/paths.sh

# bottom to top precedence
PATH="/usr/local/bin:$PATH"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/local/share/npm/bin:$PATH"

################################################################################
# Program specific paths

# homebrew
if [[ $+commands[brew] == 1 ]]; then
  PATH="$(brew --prefix josegonzalez/php/php54)/bin:$PATH"
fi

# rbenv
if [ -d "${RBENV_ROOT}" ]; then
  PATH="${RBENV_ROOT}/bin:${PATH}"
fi

################################################################################
PATH="$HOME/.dotfiles/bin:$PATH"
PATH="$HOME/bin:$PATH"
export PATH
