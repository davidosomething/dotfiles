#
# Install rbenv using script
# Only used for linux -- osx should use brew install rbenv
#
if [ ! which rbenv >/dev/null ]; then
  installing "rbenv"
  curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
fi
