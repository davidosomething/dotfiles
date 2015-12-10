#!/usr/bin/env bash

brew update

# compilers, tools, and libs ---------------------------------------------------
brew install automake cmake
brew install coreutils findutils moreutils
brew install libtool
brew install pkg-config

# filesystem -------------------------------------------------------------------
brew install ack
brew install the_silver_searcher
brew install tree

# git --------------------------------------------------------------------------
brew install git git-extras hub

# operations -------------------------------------------------------------------
brew install nmap
brew install ssh-copy-id
brew install multitail

# pretty print and processor ---------------------------------------------------
brew install icdiff
brew install jq jsonpp

# shell ------------------------------------------------------------------------
brew install shellcheck bash-completion zsh

# web --------------------------------------------------------------------------
brew install curl wget
brew dnsmasq openssl

# links to /Applications -------------------------------------------------------
brew linkapps

