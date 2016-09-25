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
brew install homebrew/completions/brew-cask-completion

# ============================================================================
# Install tapped formulae
# ============================================================================

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
# @TODO this will probably be in homebrew-formulas soon
brew install https://raw.githubusercontent.com/BurntSushi/ripgrep/master/pkg/brew/ripgrep.rb
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
brew install git
brew install hyperterm
brew install lua
brew install mono
brew install tidy-html5

# ============================================================================
# shells
# ============================================================================

brew install bash install bash-completion
brew install bats shellcheck
brew install tmux

# ============================================================================
# web
# ============================================================================

brew install curl wget
brew install openssl

# ============================================================================
# Finish up
# ============================================================================

brew linkapps

