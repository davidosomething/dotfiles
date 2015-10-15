#!/usr/bin/env bash

# Tap and install caskroom apps

brew tap phinze/homebrew-cask
brew tap caskroom/versions
brew update

brew install brew-cask

brew cask install adium
brew cask install android-file-transfer
brew cask install bettertouchtool

# menubar app to prevent display sleeping
brew cask install caffeine

brew cask install charles
brew cask install firefox

# monitor git repos in menubar
brew cask install gitifier

brew cask install google-chrome

brew cask install iterm2-beta
brew cask install jing
brew cask install joinme
brew cask install kaleidoscope

# formerly keyremap4macbook
brew cask install karabiner

# prefpane to manage homebrew plists like mysql
brew cask install launchrocket

brew cask install marked

# don't use reverse scrolling on a mouse
brew cask install scroll-reverser
brew cask install skype
brew cask install transmission
brew cask install transmit

brew cask install vagrant-manager
brew cask install vlc

brew cask install xquartz
