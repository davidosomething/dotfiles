#!/usr/bin/env bash

set -eu

# ============================================================================
# taps
# ============================================================================

brew tap homebrew/dupes
brew tap homebrew/emacs

# brew services launchctl manager -- no formulae
brew tap homebrew/services

# ============================================================================
# Meta
# ============================================================================

brew update

# ============================================================================
# Install tapped formulae
# ============================================================================

# brew cask completion
brew install homebrew/completions/brew-cask-completion

# universal-ctags
brew install --HEAD universal-ctags/universal-ctags/universal-ctags

# ============================================================================
# compilers, tools, and libs
# ============================================================================

brew install automake cmake
brew install coreutils findutils moreutils
brew install libtool
brew install pkg-config

# ============================================================================
# general
# ============================================================================

brew install aspell
brew install gnupg2

# ============================================================================
# filesystem
# ============================================================================

brew install ack
brew install findutils
brew install fzf
brew install the_silver_searcher
brew install ripgrep
brew install tree

# ============================================================================
# operations
# ============================================================================

brew install nmap
brew install ssh-copy-id
brew install multitail

# ============================================================================
# pretty print and processor
# ============================================================================

brew install icdiff
brew install jq
brew install jsonpp

# ============================================================================
# programming
# ============================================================================

brew install cloc
brew install diff-so-fancy
brew install git tig
brew install hyperterm
brew install lua
brew install mono
brew install tidy-html5

# ============================================================================
# shells
# ============================================================================

# bash 4 shell
brew install bash
# bash 4 completion
brew install homebrew/versions/bash-completion2
brew install bats shellcheck
brew install tmux

# ============================================================================
# web
# ============================================================================

brew install curl wget
brew install openssl

# ============================================================================
# OS
# ============================================================================

brew install mas

# ============================================================================
# Finish up
# ============================================================================

brew linkapps

