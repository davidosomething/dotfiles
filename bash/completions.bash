set completion-ignore-case on

source_if_exists /etc/bash_completion
source_if_exists /usr/share/bash-completion/bash_completion

# WP-CLI Bash completions
source_if_exists "${HOME}/.wp-cli/vendor/wp-cli/wp-cli/utils/wp-completion.bash"

# travis
source_if_exists "${TRAVIS_CONFIG_PATH}/.travis/travis.sh"

# homebrew's bash-completion package sources the rest of bash_completion.d
source_if_exists "${BREW_PREFIX}/etc/bash_completion"

source_if_exists "${NVM_DIR}/bash_completion"

# following are from
# https://github.com/mathiasbynens/dotfiles/blob/master/.bash_profile

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
  complete -o default -o nospace -F _git g;
fi
