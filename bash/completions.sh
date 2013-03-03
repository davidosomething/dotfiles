################################################################################
# bash completion
if [ -r /etc/bash_completion ]; then
  source /etc/bash_completion
fi

if [ -r /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
fi

# if brew command exists, source bash completion from homebrew folder
source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/bash_completion.d/hub.bash_completion.sh
source /usr/local/etc/bash_completion.d/tmux
source /usr/local/etc/bash_completion.d/vagrant
source /usr/local/etc/bash_completion.d/wp
