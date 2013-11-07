#!/usr/bin/env bash
#
# Symlink dnsmasq settings and resolvers for testing TLDs
set -e

################################################################################
# initialize script and dependencies
# get this bootstrap folder
cd "$(dirname $0)"/..
dotfiles_path="$(pwd)"
bootstrap_path="$dotfiles_path/bootstrap"
source $bootstrap_path/helpers.sh

dkorequireroot

################################################################################
dkorequire "dnsmasq"
#dkostatus "Installing dnsmasq"
#cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
#dkostatus "Launching dnsmasq"
#launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist

dkosymlinking "dnsmasq.conf" "/usr/local/etc/dnsmasq.conf"
ln -sf $dotfiles_path/dnsmasq/dnsmasq.conf /usr/local/etc/dnsmasq.conf

mkdir -p /etc/resolver
for file in $dotfiles_path/dnsmasq/resolver/*
do
  b="$(basename $file)"
  dkosymlinking $b /etc/resolver/$b
  ln -sf $file /etc/resolver/$b
done
