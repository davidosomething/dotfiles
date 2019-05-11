# shell/ruby.sh

DKO_SOURCE="${DKO_SOURCE} -> shell/ruby.sh {"

export GEMRC="${DOTFILES}/ruby/gemrc"

# Ruby use brew openssl if available
openssl_dir="${DKO_BREW_PREFIX}/opt/openssl"
[ -d "$openssl_dir" ] &&
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${openssl_dir}"

# auto bundle exec to use gems in current ruby
# see https://github.com/rvm/rubygems-bundler#note-for-rubygems--220
# disabled -- screws up global gem use (e.g. `brew` when you're in a dir with
# a Gemfile)
#export RUBYGEMS_GEMDEPS="-"

# ==============================================================================
# chruby
# ==============================================================================

export CHRUBY_PREFIX="${DKO_BREW_PREFIX:-/usr}"
__dko_source "${CHRUBY_PREFIX}/share/chruby/chruby.sh" &&
  DKO_SOURCE="${DKO_SOURCE} -> chruby"

# ==============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
