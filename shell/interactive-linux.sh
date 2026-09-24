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
# it prints nothing once brew's bin and sbin lead PATH -- so this is a no-op
# in non-login shells (tmux) that inherited a fixed PATH.
#
# brew is usually on PATH here (profile.d in login shells, inheritance in
# non-login), but nested login shells have PATH reset by /etc/profile while
# profile.d skips itself (HOMEBREW_PREFIX already set), so fall back to it.
if __dko_has 'brew'; then
  eval "$(command brew shellenv)"
elif [ -x "${HOMEBREW_PREFIX:-}/bin/brew" ]; then
  eval "$("${HOMEBREW_PREFIX}/bin/brew" shellenv)"
fi

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
