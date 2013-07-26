################################################################################
# bash completion
source_if_exists /etc/bash_completion
source_if_exists /usr/share/bash-completion/bash_completion

# WP-CLI Bash completions
source_if_exists $HOME/.wp-cli/vendor/wp-cli/wp-cli/utils/wp-completion.bash

command -v brew >/dev/null 2>&1 && command -v awk >/dev/null 2>&1 && {
  source_if_exists $(brew --prefix)/etc/bash_completion.d/git-completion.bash
  source_if_exists $(brew --prefix)/etc/bash_completion.d/hub.bash_completion.sh
  source_if_exists $(brew --prefix)/etc/bash_completion.d/tmux
  source_if_exists $(brew --prefix)/etc/bash_completion.d/vagrant
  source_if_exists $(brew --prefix)/etc/bash_completion.d/wp
}
