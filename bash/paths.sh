####
# .dotfiles/bash/paths.sh

# bottom to top precedence
PATH="/usr/local/bin:$PATH"
PATH="/usr/local/sbin:$PATH"

################################################################################
# Program specific paths

##
# bin
# php55 through homebrew if brew command available
command -v brew >/dev/null 2>&1 && {
  PATH="$(brew --prefix josegonzalez/php/php55)/bin:${PATH}"
}
# rbenv
PATH="${RBENV_ROOT}/bin:${PATH}"

##
# package managers
# composer
PATH="$HOME/.composer/bin:$PATH"
# npm
PATH="/usr/local/share/npm/bin:$PATH"


################################################################################
# local
PATH="$HOME/.dotfiles/bin:$PATH"
PATH="$HOME/bin:$PATH"
export PATH
