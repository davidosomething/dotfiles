#!/usr/bin/env bash
#
# Basic symlinks, safe to run on any system
#

set -e

# ============================================================================
# initialize script and dependencies
# ============================================================================

cd "$(dirname "$0")/.." || exit 1
readonly dotfiles_path="$(pwd)"
source "${dotfiles_path}/shell/helpers.sh"

# ============================================================================
# Main
# ============================================================================

__symlink() {
  dko::status "Symlinking dotfiles"

  # ctags
  dko::symlink ctags/dot.ctags                      .ctags

  # XDG-compatible
  dko::symlink git/dot.gitconfig                    .config/git/config
  dko::symlink git/dot.gitignore                    .config/git/ignore
  dko::symlink shell/dot.inputrc                    .config/readline/inputrc

  # (n)vim
  dko::symlink vim                                  .vim
  dko::symlink vim                                  .config/nvim

  # hyperterm
  dko::symlink hyperterm/dot.hyperterm.js           .hyperterm.js

  # default tern-project
  dko::symlink ternjs/dot.tern-project              .tern-project


  case "$OSTYPE" in
    darwin*)
      dko::symlink subversion/config                .subversion/config
      dko::symlink mac/dot.hushlogin                .hushlogin
      ;;
    linux*)
      dko::symlink linux/subversion/config          .subversion/config
      ;;
  esac


  # symlink shells ---------------------------------------------------------------
  dko::symlink bash/.bashrc                         .bashrc
  dko::symlink bash/.bash_profile                   .bash_profile
  dko::symlink zsh/.zshenv                          .zshenv

  dko::status "Done! [symlink.sh]"
}

__symlink
