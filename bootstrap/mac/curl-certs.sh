#!/usr/bin/env bash

mkdir /tmp/curl-ca-bundle
cd /tmp/curl-ca-bundle
wget http://curl.haxx.se/download/curl-7.22.0.tar.bz2
tar xzf curl-7.22.0.tar.bz2
cd curl-7.22.0/lib/
./mk-ca-bundle.pl
if [ ! -d /usr/share/curl/ ]; then
  sudo mkdir -p /usr/share/curl/
else
  sudo mv /usr/share/curl/ca-bundle.crt /usr/share/curl/ca-bundle.crt.original
fi
sudo mv ca-bundle.crt /usr/share/curl/ca-bundle.crt
echo
echo "Done!"
