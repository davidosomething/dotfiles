####
# .dotfiles/zsh/zshrc.zsh
# zsh options
# only run on interactive/TTY

##
# command history
# these exports only needed when there's a TTY
export HISTFILE="$ZDOTDIR/.zhistory"
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt APPEND_HISTORY                 # append instead of overwrite file
setopt SHARE_HISTORY                  # append after each new command instead
                                      # of after shell closes, share between
                                      # shells
setopt HIST_VERIFY                    # verify when using history cmds/params

##
# shell options
setopt AUTO_LIST                      # list completions
setopt AUTO_PUSHD                     # pushd instead of cd
setopt CDABLE_VARS
setopt CORRECT
setopt EXTENDED_GLOB                  # like ** for recursive dirs
setopt NO_BEEP
setopt NO_HUP                         # don't kill bg processes
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT                   # don't show stack after cd
setopt PUSHD_TO_HOME                  # go home if no d specified

source $BASH_DOTFILES/aliases.sh      # sources os specific ones too
source $BASH_DOTFILES/functions.sh    # sources os specific ones too
source $ZSH_DOTFILES/aliases.zsh
source $ZSH_DOTFILES/functions.zsh

[[ $+commands[rbenv] == 1 ]] && eval "$(rbenv init -)"

source $ZSH_DOTFILES/keybindings.zsh
source $ZSH_DOTFILES/prompt.zsh

##
# zstyles
# case-insensitive tab completion for filenames (useful on Mac OS X)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' expand 'yes'
# don't autocomplete usernames/homedirs
zstyle ':completion::complete:cd::' tag-order '! users' -

##
# load basic autocompletion
autoload -U compinit && compinit

##
# add zsh completions from git subrepo
fpath=( $ZSH_DOTFILES/zsh-completions $fpath )

##
# zsh-syntax-highlighting plugin
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
[ -f "$ZDOTDIR/.zshrc.local" ] && source $ZDOTDIR/.zshrc.local
