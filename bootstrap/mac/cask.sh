#!/usr/bin/env bash
#
# Tap and install caskroom apps
#

set -eu

brew tap caskroom/cask
brew tap caskroom/versions

brew update

# ==============================================================================
# Alfred
# ==============================================================================

brew cask install alfred
echo "License in SpiderOak Hive"
echo "Workflows in SpiderOak Hive"

# ==============================================================================
# bettertouchtool
# ==============================================================================

brew cask install bettertouchtool
echo "License in SpiderOak Hive"

# ==============================================================================

brew cask install bitbar
echo "Sync in SpiderOak Hive"

# ==============================================================================

# monitor git repos in menubar
#brew cask install gitifier

brew cask install flux
brew cask install java
brew cask install jing
brew cask install joinme

# ==============================================================================
# Kaleidoscope
# ==============================================================================

brew cask install kaleidoscope
echo "License in SpiderOak Hive"

# ==============================================================================
# Marked
# ==============================================================================

brew cask install marked
echo "License in SpiderOak Hive"

# ==============================================================================

brew cask install ngrok
brew cask install skype
brew cask install slack
brew cask install spideroakone
brew cask install spotify spotifree
brew cask install steam
brew cask install transmission

# ==============================================================================
# Transmit
# ==============================================================================

# Install from mac app store instead
#brew cask install transmit
# echo "License in email"
# echo "Favorites in SpiderOak Hive"

# ============================================================================
# Virtualization
# ============================================================================

brew cask install vagrant vagrant-manager
brew cask install virtualbox virtualbox-extension-pack

# ============================================================================

brew cask install vlc
brew cask install vnc-viewer

