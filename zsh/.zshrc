####
# ~/.dotfiles/.zshrc
# zsh options
# only run on interactive/TTY

##
# command history
# these exports only needed when there's a TTY
export HISTSIZE=500
export SAVEHIST=500
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

##
# functions
source $ZDOTDIR/.zshfunctions
source $ZDOTDIR/.zshfunctions

##
# aliases
source $DOTFILES/bash/.bash_aliases      # sh independent aliases
case "$OSTYPE" in
  darwin*)  source $DOTFILES/bash/.bash_aliases.osx
            ;;
  linux*)   source $DOTFILES/bash/.bash_aliases.linux
            ;;
esac
source $ZDOTDIR/.zshaliases

##
# prompt and title
source $ZDOTDIR/.zshprompt

##
# key bindings
source $ZDOTDIR/.zshkeys

##
# zstyles
# case-insensitive tab completion for filenames (useful on Mac OS X)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' expand 'yes'
# don't autocomplete usernames/homedirs
zstyle ':completion::complete:cd::' tag-order '! users' -

##
# zsh-syntax-highlighting plugin
source $ZDOTDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh >/dev/null 2>&1 # may or may not exist

##
# os specific
case "$OSTYPE" in
  darwin*)  source $ZDOTDIR/.zshrc.local.osx
            ;;
  linux*)   source $ZDOTDIR/.zshrc.local.linux
            ;;
esac

##
# local
[ -e ~/.zshrc.local ] && source ~/.zshrc.local
