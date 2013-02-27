#!/usr/env/bin bash
set -e

#status "Installing dnsmasq"
#sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
#sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

status "Symlinking dnsmasq conf"
ln -s ~/.dotfiles/dnsmasq/dnsmasq.conf /usr/local/etc/dnsmasq.conf

status "Symlinking resolver"
mkdir -p /etc/resolver
ln -s ~/.dotfiles/dnsmasq/dev /etc/resolver/dev
