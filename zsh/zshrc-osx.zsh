# .dotfiles/zsh/zshrc-osx.zsh
# sourced by .zshrc

################################################################################
# Git completion
autoload bashcompinit && bashcompinit
# if brew command exists, source bash completion from homebrew folder
if [[ $+commands[brew] == 1 ]]; then
  source $(brew --prefix)/etc/bash_completion.d
fi
