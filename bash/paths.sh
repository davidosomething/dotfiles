####
# .dotfiles/bash/paths.sh

# bottom to top precedence
PATH="/usr/local/bin:$PATH"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/local/share/npm/bin:$PATH"

################################################################################
# Program specific paths

# homebrew
command -v brew >/dev/null 2>&1 && {
  PATH="$(brew --prefix josegonzalez/php/php54)/bin:${PATH}"
}

# rbenv
if [ -d "${RBENV_ROOT}" ]; then
  PATH="${RBENV_ROOT}/bin:${PATH}"
fi

################################################################################
PATH="$HOME/.dotfiles/bin:$PATH"
PATH="$HOME/bin:$PATH"
export PATH
