#####
# .dotfiles/zsh/zshrc.zsh
# only run on interactive/TTY

source $ZSH_DOTFILES/options.zsh
source $BASH_DOTFILES/aliases.sh
source $BASH_DOTFILES/functions.sh
source $ZSH_DOTFILES/aliases.zsh
source $ZSH_DOTFILES/functions.zsh

# program aliases
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"
command -v hub >/dev/null 2>&1 && eval "$(hub alias -s)"

source $ZSH_DOTFILES/keybindings.zsh
source $ZSH_DOTFILES/prompt.zsh
source $ZSH_DOTFILES/completions.zsh
source $ZSH_DOTFILES/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##
# os specific
case "$OSTYPE" in
  darwin*)  source $ZSH_DOTFILES/zshrc-osx.zsh
            ;;
  linux*)   source $ZSH_DOTFILES/zshrc-linux.zsh
            ;;
esac

##
# local
source_if_exists $ZDOTDIR/.zshrc.local
