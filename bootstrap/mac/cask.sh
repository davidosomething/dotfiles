#!/usr/bin/env bash

# Tap and install caskroom apps

brew tap caskroom/cask
brew update

# ==============================================================================
# Alfred
# ==============================================================================

brew cask install alfred
brew cask alfred link
echo "License in email"
echo "Workflows in Dropbox"

# ==============================================================================
# bettertouchtool
# ==============================================================================

brew cask install bettertouchtool
echo "License in secrets"

# ==============================================================================

# monitor git repos in menubar
#brew cask install gitifier

brew cask install flux
brew cask install gpgtools
brew cask install hyperterm
brew cask install java
brew cask install jing
brew cask install joinme

# ==============================================================================
# Kaleidoscope
# ==============================================================================

brew cask install kaleidoscope
echo "License in secrets"

# ==============================================================================
# karabiner
# ==============================================================================

brew cask install karabiner
echo "Exports in mac/karabiner"

# ==============================================================================
# Marked
# ==============================================================================

brew cask install marked
echo "License in email"

# ==============================================================================

brew cask install skype
brew cask install slack
brew cask install spideroakone
brew cask install spotify spotifree
brew cask install steam
brew cask install transmission

# ==============================================================================
# Transmit
# ==============================================================================

brew cask install transmit
echo "License in email"
echo "Favorites in Dropbox"

brew cask install vagrant vagrant-manager
brew cask install virtualbox virtualbox-extension-pack
brew cask install vlc
brew cask install vnc-viewer
