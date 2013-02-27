# .dotfiles/zsh/zshrc-osx.zsh
# sourced by .zshrc

# rbenv completions (can also add to bash, but it's not there)
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi

################################################################################
# Git completion
autoload bashcompinit && bashcompinit
# if brew command exists, source bash completion from homebrew folder
if [[ $+commands[brew] == 1 ]]; then
  source `brew --prefix`/etc/bash_completion.d
fi
