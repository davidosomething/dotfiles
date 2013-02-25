# system bash completion
if [ -r /etc/bash_completion ]; then
  source /etc/bash_completion
elif [ -r /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
fi

# git prompt for linux
if [ -r /usr/share/git/git-prompt.sh ]; then
  source /usr/share/git/git-prompt.sh
fi
