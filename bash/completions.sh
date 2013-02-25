if [ -r /etc/bash_completion ]; then
  source /etc/bash_completion
elif [ -r /usr/share/bash-completion/bash_completion ]; then
  source /usr/share/bash-completion/bash_completion
fi
if [ -r /usr/share/git/git-prompt.sh ]; then
  source /usr/share/git/git-prompt.sh
fi
