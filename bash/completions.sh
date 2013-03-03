################################################################################
# bash completion
[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

# if brew command exists, source bash completion from homebrew folder
[ -f /usr/local/etc/bash_completion.d/git-completion.bash ] && source /usr/local/etc/bash_completion.d/git-completion.bash
[ -f /usr/local/etc/bash_completion.d/hub.bash_completion.sh ] && source /usr/local/etc/bash_completion.d/hub.bash_completion.sh
[ -f /usr/local/etc/bash_completion.d/tmux ] && source /usr/local/etc/bash_completion.d/tmux
[ -f /usr/local/etc/bash_completion.d/vagrant ] && source /usr/local/etc/bash_completion.d/vagrant
[ -f /usr/local/etc/bash_completion.d/wp ] && source /usr/local/etc/bash_completion.d/wp
