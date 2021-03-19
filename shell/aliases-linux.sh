# shell/aliases-linux.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/aliases-linux.sh"

alias open="dko-open"

alias startx='startx > "${DOTFILES}/logs/startx.log" 2>&1'

alias testnotification="notify-send \
  'Hello world!' \
  'This is an example notification.' \
  --icon=dialog-information"

# ============================================================================
# systemd
# ============================================================================

alias logboot='sudo journalctl -b0'
