# shell/ruby.bash

export DKO_SOURCE="${DKO_SOURCE} -> shell/ruby.bash {"

export GEMRC="${DOTFILES}/ruby/gemrc"

# ============================================================================
# ruby-install
# ============================================================================

export DKO_RUBIES="${XDG_DATA_HOME}/rubies"

if [ "$DOTFILES_OS" = 'Darwin' ]; then
  # Ruby use brew openssl if available
  openssl_dir="${DKO_BREW_PREFIX}/opt/openssl"
  [ -d "$openssl_dir" ] &&
    export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${openssl_dir}"
fi

# auto bundle exec to use gems in current ruby
# see https://github.com/rvm/rubygems-bundler#note-for-rubygems--220
# disabled -- screws up global gem use (e.g. `brew` when you're in a dir with
# a Gemfile)
#export RUBYGEMS_GEMDEPS="-"

# ==============================================================================
# chruby
# ==============================================================================

# Check for rubies first, don't load chruby if missing a stable version
if [ -d "${DKO_RUBIES}/ruby-2.7.1" ] || [ -d "${DKO_RUBIES}/ruby-2.6.1" ]; then
  export CHRUBY_PREFIX="${DKO_BREW_PREFIX:-/usr}"
  __dko_source "${CHRUBY_PREFIX}/share/chruby/chruby.sh" &&
    DKO_SOURCE="${DKO_SOURCE} -> chruby" &&
    RUBIES+=("${DKO_RUBIES}"/*) &&
    export RUBIES
fi

# ============================================================================
# Solargraph
# ==============================================================================

export SOLARGRAPH_CACHE="${XDG_CACHE_HOME}/solargraph"

# ==============================================================================

DKO_SOURCE="${DKO_SOURCE} }"
