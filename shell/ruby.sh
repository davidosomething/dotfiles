# shell/ruby.sh
#
# Uses vars from shell/vars and shell/os
#

export DKO_SOURCE="${DKO_SOURCE} -> shell/ruby.sh {"

export GEMRC="${DOTFILES}/ruby/gemrc"

# Ruby use brew openssl if available
[[ -f "${BREW_PREFIX}/opt/openssl" ]] && \
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${BREW_PREFIX}/opt/openssl"

# auto bundle exec to use gems in current ruby
# see https://github.com/rvm/rubygems-bundler#note-for-rubygems--220
# disabled -- screws up global gem use (e.g. `brew` when you're in a dir with
# a Gemfile)
#export RUBYGEMS_GEMDEPS="-"

# ==============================================================================
# chruby
# ==============================================================================

export CHRUBY_PREFIX="${BREW_PREFIX:-/usr}"

# chruby and auto-switcher for .ruby-version
dko::source "${CHRUBY_PREFIX}/share/chruby/chruby.sh" && \
  export DKO_SOURCE="${DKO_SOURCE} -> chruby"
dko::source "${CHRUBY_PREFIX}/share/chruby/auto.sh"

export DKO_SOURCE="${DKO_SOURCE} }"
# vim: ft=sh :
