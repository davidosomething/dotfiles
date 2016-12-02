#!/usr/bin/env bash

set -eu

# ============================================================================
# taps
# ============================================================================

brew tap homebrew/emacs

# brew services launchctl manager -- no formulae
brew tap homebrew/services

# ============================================================================
# Meta
# ============================================================================

brew update

# brew cask completion
brew install homebrew/completions/brew-cask-completion

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
brew install neofetch # prefer over archey

# ============================================================================
# filesystem
# ============================================================================

brew install ack
brew install fzf
brew install the_silver_searcher
brew install ripgrep
brew install tree

# ============================================================================
# operations
# ============================================================================

# OpenSSL for some programs, but prefer libressl where possible
brew install openssl

# Too annoying to re-setup ssh-agent since the ssh-add does not have keychain
# access -- disabled:
# ----------------------------------------------------------------------------
# Install a newer version of OpenSSH
# that isn't susceptible to http://www.openssh.com/txt/release-7.1p2
#brew install homebrew/dupes/ssh --with-libressl

# Since we're not using system ssh, the launchd's attempt to ssh-add our key
# fails (due to wrong flags). We could change the launchagent, but instead
# prefer to use keychain to interface with ssh-agent and osxkeychain.
# It is run in shell/os.bash.
#brew install keychain
# ----------------------------------------------------------------------------

brew install nmap
brew install ssh-copy-id
brew install multitail

# Use the `gpgtools` cask instead (it also provides cli `gpg` and
# `gpg-agent`). It provides a nicer gui prefpane and automatic integration
# without having to configure all this stuff.
#brew install gnupg2
#brew install gpg-agent pinentry-mac

brew install wget

# better curl
brew install curl --with-libressl
brew link --force curl

# ============================================================================
# pretty print and processor
# ============================================================================

brew install icdiff
brew install jq
brew install jsonpp

# ============================================================================
# programming
# ============================================================================

brew install homebrew/homebrew-php/composer

brew install --HEAD universal-ctags/universal-ctags/universal-ctags

brew install cloc
brew install diff-so-fancy
brew install git --without-completions
brew install git-extras
brew install hub tig
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
# OS
# ============================================================================

brew install mas

# ============================================================================
# Finish up
# ============================================================================

brew linkapps

