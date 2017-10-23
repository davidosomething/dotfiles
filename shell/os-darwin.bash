# shell/os-darwin.bash

export DKO_SOURCE="${DKO_SOURCE} -> shell/os-darwin.bash"

# @see https://github.com/nojhan/liquidprompt/blob/master/liquidprompt
# uname is slower
export DOTFILES_OS="Darwin"
export DOTFILES_DISTRO="mac"
# just assume brew is in normal location, don't even check for it
export DKO_BREW_PREFIX="/usr/local"

# homebrew
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS='--require-sha'

# Allow pyenv to use custom openssl from brew
[[ -d "${DKO_BREW_PREFIX}/opt/openssl/lib" ]] \
  && export LDFLAGS="-L${DKO_BREW_PREFIX}/opt/openssl/lib"
[[ -d "${DKO_BREW_PREFIX}/opt/openssl/include" ]] \
  && export CPPFLAGS="-I${DKO_BREW_PREFIX}/opt/openssl/include"

[[ -d "${DKO_BREW_PREFIX}/share/android-sdk" ]] \
  && export ANDROID_SDK_ROOT="${DKO_BREW_PREFIX}/share/android-sdk"
