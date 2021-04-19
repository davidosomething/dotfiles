# shell/dot.profile

# Used by /bin/sh shell
# - Sourced by login shells
# - Sourced by bash/dot.bashrc if in a BASH login shell
# - Sourced by zsh/.zshrc if in a ZSH login shell
#
# This file is sourced manually in the .*rc file so it loads when running
# a nested shell, e.g. zsh from within bash

# Skipped in repeat runs and if .zshenv provided it
if [ -z "$DKO_INIT" ]; then
  export DKO_SOURCE="${DKO_SOURCE} -> dot.profile:init {"
  export DKO_INIT=1
  . "${HOME}/.dotfiles/shell/vars.sh"
  . "${DOTFILES}/shell/path.sh" # depends on vars
else
  export DKO_SOURCE="${DKO_SOURCE} -> dot.profile:skip-init {"
fi

tty -s && . "${DOTFILES}/shell/interactive.sh"

# ============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh
