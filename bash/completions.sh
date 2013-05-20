################################################################################
# bash completion
function source_if_exists() {
  [ -f $1 ] && source $1
}

source_if_exists /etc/bash_completion
source_if_exists /usr/share/bash-completion/bash_completion
source_if_exists $(brew --prefix)/etc/bash_completion.d/git-completion.bash
source_if_exists $(brew --prefix)/etc/bash_completion.d/hub.bash_completion.sh
source_if_exists $(brew --prefix)/etc/bash_completion.d/tmux
source_if_exists $(brew --prefix)/etc/bash_completion.d/vagrant
source_if_exists $(brew --prefix)/etc/bash_completion.d/wp
