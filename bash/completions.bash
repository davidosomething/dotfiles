################################################################################
# bash completion
source_if_exists /etc/bash_completion
source_if_exists /usr/share/bash-completion/bash_completion

# WP-CLI Bash completions
source_if_exists $HOME/.wp-cli/vendor/wp-cli/wp-cli/utils/wp-completion.bash

# grunt
has_program grunt && eval "$(grunt --completion=bash)"

# homebrew's bash-completion package sources the rest of bash_completion.d
$HAS_BREW && source_if_exists "$(brew --prefix)/etc/bash_completion"
