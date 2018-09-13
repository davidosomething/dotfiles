# shell/os-darwin.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/os-darwin.sh"

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
[ -d "${DKO_BREW_PREFIX}/opt/openssl/lib" ] \
  && export LDFLAGS="-L${DKO_BREW_PREFIX}/opt/openssl/lib"
[ -d "${DKO_BREW_PREFIX}/opt/openssl/include" ] \
  && export CPPFLAGS="-I${DKO_BREW_PREFIX}/opt/openssl/include"

[ -d "${DKO_BREW_PREFIX}/share/android-sdk" ] \
  && export ANDROID_SDK_ROOT="${DKO_BREW_PREFIX}/share/android-sdk"

# ============================================================================
# Functions
# ============================================================================

flushdns() {
  dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

# list members for a group
# http://www.commandlinefu.com/commands/view/10771/osx-function-to-list-all-members-for-a-given-group
members() {
  dscl . -list /Users | while read -r user; do
    printf "%s " "$user"
    dsmemberutil checkmembership -U "$user" -G "$*"
  done | grep "is a member" | cut -d " " -f 1
}

# short version of what's provided by oh-my-zsh/xcode
ios() {
  open "$(xcode-select -p)/Applications/Simulator.app"
}

vol() {
  __dko_has "osascript" && osascript -e "set volume ${1}"
}

# ============================================================================
# Aliases
# ============================================================================

# ----------------------------------------------------------------------------
# Homebrew
# ----------------------------------------------------------------------------

alias b='TERM=xterm-256color \brew'
alias brew='b'

alias bi='b install'
alias bs='b search'
alias blfn='b ls --full-name'

alias brc='b cask'

alias bsvc='b services'
alias bsvr='b services restart'

alias cask='brc'
alias ci='brc install'

# ----------------------------------------------------------------------------
# Chrome
# ----------------------------------------------------------------------------

alias chrome='open -a /Applications/Google\ Chrome.app'
alias chrome-canary='open -a /Applications/Google\ Chrome\ Canary.app'
alias chromium='open -a /Applications/Chromium.app'

# ----------------------------------------------------------------------------
# Redshift
# ----------------------------------------------------------------------------

alias redstart='bsvc start redshift'
alias redstop='bsvc stop redshift'

# ----------------------------------------------------------------------------
# Misc
# ----------------------------------------------------------------------------

# sudo since we run nginx on port 80 so needs admin
alias rnginx='sudo brew services restart nginx'

# electron apps can't focus if started using Electron symlink
alias elec='/Applications/Electron.app/Contents/MacOS/Electron'

# Audio control - http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"

# ----------------------------------------------------------------------------
# xcode
# ----------------------------------------------------------------------------

alias cuios='XCODE_XCCONFIG_FILE="${PWD}/xcconfigs/swift31.xcconfig" carthage update --platform iOS'
alias deletederived='rm -rf ~/Library/Developer/Xcode/DerivedData/*'
alias xcimg="xcrun simctl addmedia booted"
