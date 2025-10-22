# shellcheck shell=bash
# shell/path.sh
#
# Sourced in dot.profile on login shells
#
# Rebuild path starting from system path
# Regarding tmux:
# Since my tmux shells are not login shells the path needs to be rebuilt.
#
# shell/vars.sh on the other hand just get inherited.
# XDG is set up in init.sh, which should already have been sourced
# envs, chphp pathing is done in zshrc, zinit, or shell/after

export DKO_SOURCE="${DKO_SOURCE} -> shell/path.sh"

# ==============================================================================
# Store default system path
# ==============================================================================

# Probably created via /etc/profile and /etc/profile.d/*
# On macOS/OS X/BSD path_helper is run in /etc/profile, which generates paths
# using /etc/paths and /etc/paths.d/* and defines the initial $PATH
# On arch, via /etc/profile, default path is:
# /usr/local/sbin:/usr/local/bin:/usr/bin
export DKO_SYSTEM_PATH="${DKO_SYSTEM_PATH:-$PATH}"

# ============================================================================
# Begin composition
# ============================================================================

# On BSD system, e.g. Darwin -- path_helper is called, reads /etc/paths
# Move local bin to front for homebrew compatibility
#if [ -x /usr/libexec/path_helper ]; then
PATH="$DKO_SYSTEM_PATH"

# ----------------------------------------------------------------------------
# Package managers
# ----------------------------------------------------------------------------

# composer; COMPOSER_HOME is in shell/vars.sh
PATH="${COMPOSER_HOME}/vendor/bin:${PATH}"

# dotnet .NET Core SDK tools (e.g. for csharp_ls)
PATH="${HOME}/.dotnet/tools:${PATH}"

# luarocks per-user rock tree (may be overridden by os-*.sh config)
PATH="${HOME}/.luarocks/bin:${PATH}"

# go -- prefer go binaries over composer; GOPATH is in shell/vars.sh
PATH="${GOPATH}/bin:${PATH}"

# asdf shims, but usually we use mise shims
PATH="${ASDF_DATA_DIR}/shims:${PATH}"

# ============================================================================
# Local path -- everything after the path setting this may use "command" to
# check for presence
# ============================================================================

# pipx uses this one by default
PATH="${HOME}/.local/bin:${PATH}"
PATH="${DOTFILES}/bin:${LDOTDIR}/bin:${PATH}"
