# shell/ruby.sh

DKO_SOURCE="${DKO_SOURCE} -> shell/ruby.sh {"

export GEMRC="${DOTFILES}/ruby/gemrc"

# Ruby use brew openssl if available
[ -f "${DKO_BREW_PREFIX}/opt/openssl" ] && \
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${DKO_BREW_PREFIX}/opt/openssl"

# auto bundle exec to use gems in current ruby
# see https://github.com/rvm/rubygems-bundler#note-for-rubygems--220
# disabled -- screws up global gem use (e.g. `brew` when you're in a dir with
# a Gemfile)
#export RUBYGEMS_GEMDEPS="-"

# ==============================================================================
# chruby
# ==============================================================================

export CHRUBY_PREFIX="${DKO_BREW_PREFIX:-/usr}"

# chruby and auto-switcher for .ruby-version
__dko_source "${CHRUBY_PREFIX}/share/chruby/chruby.sh" && \
  DKO_SOURCE="${DKO_SOURCE} -> chruby"
__dko_source "${CHRUBY_PREFIX}/share/chruby/auto.sh"

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
