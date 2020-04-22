# shell/dot.profile

# Used by /bin/sh shell
# Sourced on login shells only
# Sourced by bash/dot.bashrc if in a BASH login shell
# Sourced by zsh/.zshrc if in a ZSH login shell
#
# This file is sourced manually in the .*rc file so it loads when running
# a nested shell, e.g. zsh from within bash

export DKO_SOURCE="${DKO_SOURCE} -> dot.profile {"
[ -z "$DKO_INIT" ] && {
  export DKO_INIT=1
  . "${HOME}/.dotfiles/shell/vars.sh"
  . "${DOTFILES}/shell/path.sh" # depends on vars

  # ============================================================================
  # Local path -- everything after the path setting this may use "command" to
  # check for presence
  # ============================================================================

  PATH="${HOME}/.local/bin:${PATH}"
  PATH="${DOTFILES}/bin:${PATH}"

  # ==========================================================================
  # os config
  #
  # OS specific overrides, OSTYPE is not POSIX so these won't run except in
  # modern shells
  #
  # @TODO split out interactive parts in these files?
  # ==========================================================================

  case "$DOTFILES_OS" in
  Darwin) . "${DOTFILES}/shell/os-darwin.zsh" ;;
  Linux) . "${DOTFILES}/shell/os-linux.sh" ;;
  esac
}

tty -s && . "${DOTFILES}/shell/interactive.sh"

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh
