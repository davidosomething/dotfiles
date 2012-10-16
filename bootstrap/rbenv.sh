status "Installing rbenv if needed"
if [ "`which ruby 2>/dev/null`" != "$HOME/.rbenv/shims/ruby" ]; then
  curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
fi

LASTEST_RUBY_MAJOR="1.9.3"
LASTEST_RUBY_PATCH="-p194"
status "SetInstalling rbenv if needed"
if [ ! "`ruby --version | grep $LATEST_RUBY_MAJOR 2>/dev/null`" ]; then
  rbenv install $LASTEST_RUBY_MAJOR$LASTEST_RUBY_PATCH
  rbenv global $LASTEST_RUBY_MAJOR$LASTEST_RUBY_PATCH
fi
