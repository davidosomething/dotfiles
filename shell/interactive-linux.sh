# shellcheck shell=bash
# shell/interactive-linux.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/interactive-linux.sh"

# Route tools that respect $BROWSER (gh, git web--browse, npm, etc.) through
# dko-open so the spawned browser is detached from the shell's tty.
export BROWSER="dko-open"

# ============================================================================
# homebrew (linuxbrew)
# ============================================================================

# /etc/profile.d/brew.sh appends brew's bin after /usr/bin so system binaries
# win; brew doctor wants it the other way around. shellenv is idempotent --
# it prints nothing once brew's bin and sbin lead PATH -- so this is also a
# no-op in non-login shells (tmux) that inherited a fixed PATH.
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] &&
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

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
