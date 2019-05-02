# shell/aliases-linux.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/aliases-linux.sh"

alias open='o' # use open() function in shell/functions
alias startx='startx > "${DOTFILES}/logs/startx.log" 2>&1'

alias testnotification="notify-send \
  'Hello world!' \
  'This is an example notification.' \
  --icon=dialog-information"
