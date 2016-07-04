#!/usr/bin/env bash

brew update

# compilers, tools, and libs ---------------------------------------------------
brew install automake cmake
brew install coreutils findutils moreutils
brew install libtool
brew install pkg-config

# general ----------------------------------------------------------------------
brew install aspell

# filesystem -------------------------------------------------------------------
brew install ack
brew install findutils
brew install fzf
brew install the_silver_searcher
brew install tree

# operations -------------------------------------------------------------------
brew install nmap
brew install ssh-copy-id
brew install multitail

# pretty print and processor ---------------------------------------------------
brew install icdiff
brew install jq jsonpp

# programming ------------------------------------------------------------------
brew install cloc
brew install lua
brew install mono
brew install tidy-html5

# shells -----------------------------------------------------------------------
brew install bash install bash-completion
brew install shellcheck
brew install tmux

# web --------------------------------------------------------------------------
brew install curl wget
brew install dnsmasq
brew install openssl

# links to /Applications -------------------------------------------------------
brew linkapps

