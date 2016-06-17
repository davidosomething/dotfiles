#!/usr/bin/env bash

# Tap and install caskroom apps

brew tap caskroom/cask
brew update

brew cask install alfred
brew cask alfred link

brew cask install android-file-transfer
brew cask install bettertouchtool

brew cask install charles
brew cask install firefox

# monitor git repos in menubar
#brew cask install gitifier

brew cask install jing
brew cask install joinme

brew cask install marked

# don't use reverse scrolling on a mouse
brew cask install skype
brew cask install transmit

brew cask install vagrant-manager
brew cask install virtualbox virtualbox-extension-pack
brew cask install vlc
