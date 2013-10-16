#!/usr/bin/env bash
set -e

################################################################################
# initialize script and dependencies
# get this bootstrap folder
cd "`dirname $0`"/..
dotfiles_path="`pwd`"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh

################################################################################
# require root
if [ "$(whoami)" != "root" ]; then
  dkodie "Please run as root, these files go into /etc/**/";
fi

################################################################################
# begin
#dkostatus "Installing dnsmasq"
#cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
#dkostatus "Launching dnsmasq"
#launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

dkosymlinking "dnsmasq.conf" "/usr/local/etc/dnsmasq.conf"
ln -sf $dotfiles_path/dnsmasq/dnsmasq.conf /usr/local/etc/dnsmasq.conf

dkostatus "Symlinking resolver files"
mkdir -p /etc/resolver
for file in $dotfiles_path/dnsmasq/resolver/*
do
  ln -sf $file /etc/resolver/$(basename $file)
done
