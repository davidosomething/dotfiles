# shell/path.bash
#
# Sourced in bash and ZSH by loader
# XDG is set up in init.bash, which should already have been sourced
# pyenv, chruby, chphp, nvm pathing is done in shell/after
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/path.bash"

# ==============================================================================
# Store default system path
# ==============================================================================

# Probably created via /etc/profile and /etc/profile.d/*
#
# On macOS/OS X/BSD path_helper is run in /etc/profile, which generates paths
# using /etc/paths and /etc/paths.d/* and defines the initial $PATH
# Something like "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
#
# On arch, via /etc/profile, default path is:
# /usr/local/sbin:/usr/local/bin:/usr/bin
if [ -n "$DKO_SYSTEM_PATH" ]; then
  export DKO_SYSTEM_PATH="${PATH}:${DKO_SYSTEM_PATH}"
else
  export DKO_SYSTEM_PATH="${PATH}"
fi

# ============================================================================
# Begin composition
# ============================================================================

# On BSD system, e.g. Darwin -- path_helper is called, reads /etc/paths
# Move local bin to front for homebrew compatibility
#if [ -x /usr/libexec/path_helper ]; then
PATH="$DKO_SYSTEM_PATH"

# enforce local bin and sbin order, they come before any system paths
PATH="/usr/local/bin:/usr/local/sbin:${DKO_SYSTEM_PATH}"

# ----------------------------------------------------------------------------
# Package managers
# ----------------------------------------------------------------------------

# composer; COMPOSER_HOME is in shell/vars.bash
PATH="${COMPOSER_HOME}/vendor/bin:${PATH}"

# luarocks per-user rock tree
PATH="${HOME}/.luarocks/bin:${PATH}"

# go -- prefer go binaries over composer; GOPATH is in shell/vars.bash
PATH="${GOPATH}/bin:${PATH}"

# ============================================================================
# DONE
# ============================================================================

export PATH

# ============================================================================
# MANPATH using manpath
# ============================================================================

if command -v manpath >/dev/null; then
  MANPATH="$(manpath)"
fi
MANPATH="${HOME}/.local/man:${MANPATH}"
export MANPATH
