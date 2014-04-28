# After brew rbenv
rbenv install 2.1.1
rbenv global 2.1.1

# After homebrew PHP
ln -sfv /usr/local/opt/php55/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php55.plist

ln -sfv /usr/local/opt/memcached/*.plist ~/Library/LaunchAgents
