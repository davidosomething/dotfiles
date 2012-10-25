status "Installing rbenv if needed"
if ! which rbenv >/dev/null 2>&1; then
  curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
fi
