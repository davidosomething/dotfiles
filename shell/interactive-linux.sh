# shellcheck shell=bash
# shell/interactive-linux.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/interactive-linux.sh"

# Route tools that respect $BROWSER (gh, git web--browse, npm, etc.) through
# dko-open so the spawned browser is detached from the shell's tty.
export BROWSER="dko-open"

# ============================================================================
# functions
# ============================================================================

# flush linux font cache
flushfonts() {
  fc-cache -f -v
}

# ============================================================================
# aliases
# ============================================================================

alias open="dko-open"

alias testnotification="notify-send \
  'Hello world!' \
  'This is an example notification.' \
  --icon=dialog-information"

# systemd
alias logboot='sudo journalctl -b0'
