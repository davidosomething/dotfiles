# shell/interactive-darwin.zsh

# Counting on Darwin default shell to be zsh now, bashisms are okay!

export DKO_SOURCE="${DKO_SOURCE} -> shell/interactive-darwin.zsh"

# ============================================================================
# homebrew
# ============================================================================

# just assume brew is in normal location, don't even check for it
export DKO_BREW_PREFIX="/usr/local"

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

# GOROOT binaries
[ -d "${DKO_BREW_PREFIX}/opt/go/libexec/bin" ] &&
PATH="${DKO_BREW_PREFIX}/opt/go/libexec/bin:${PATH}"
PATH="${DKO_BREW_PREFIX}/opt/git/share/git-core/contrib/git-jump:${PATH}"

# prefer homebrewed lua@5.1
[ -x ${DKO_BREW_PREFIX}/bin/luarocks ] &&
  [ -d "${DKO_BREW_PREFIX}/opt/lua@5.1" ] &&
  {
    export DKO_LUA_DIR="${DKO_BREW_PREFIX}/opt/lua@5.1"
    eval "$(luarocks --lua-dir="$DKO_LUA_DIR" path --bin)"
    alias luarocks='luarocks --lua-dir="$DKO_LUA_DIR"'
  }

# @TODO recheck this for Big Sur
# https://github.com/pyenv/pyenv/issues/1746
# Allow pyenv to use custom openssl from brew
[ -d "${DKO_BREW_PREFIX}/opt/openssl/lib" ] &&
  export LDFLAGS="-L${DKO_BREW_PREFIX}/opt/openssl/lib"
[ -d "${DKO_BREW_PREFIX}/opt/openssl/include" ] &&
  export CPPFLAGS="-I${DKO_BREW_PREFIX}/opt/openssl/include"

[ -d "${DKO_BREW_PREFIX}/share/android-sdk" ] &&
  export ANDROID_SDK_ROOT="${DKO_BREW_PREFIX}/share/android-sdk"

# ============================================================================
# Functions
# ============================================================================

# list installed brew and deps
# https://zanshin.net/2014/02/03/how-to-list-brew-dependencies/
bwhytree() {
  brew list -1 --formula | while read c; do
    echo -n "\e[1;34m${c} -> \e[0m"
    brew deps "$c" | awk '{printf(" %s ", $0)}'
    echo ""
  done
}

# fix old casks that error during uninstall from undent
# https://github.com/Homebrew/homebrew-cask/issues/49716
bfixcasks() {
  find "$(brew --prefix)/Caskroom/"*'/.metadata' -type f -name '*.rb' |\
    xargs grep 'EOS.undent' --files-with-matches |\
    xargs sed -i '' 's/EOS.undent/EOS/'
}

# Restart Docker.app and wait for daemon
dockerrestart() {
  printf "Restarting Docker.app "
  osascript -e 'quit app "Docker"' &
  pid=$!
  wait $pid
  sleep 1

  open -a Docker && {
    while ! docker info >/dev/null 2>&1 ; do
      printf "."
      sleep 1
    done
    echo
  }
}

flushdns() {
  dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

# short version of what's provided by oh-my-zsh/xcode
ios() {
  open "$(xcode-select -p)/Applications/Simulator.app"
}

addjavas() {
  __dko_has "jenv" || return 1
  for path_to_jdk in $(ls -d /Library/Java/JavaVirtualMachines/*/Contents/Home); do
    jenv add $path_to_jdk
  done
}

# list members for a group
# http://www.commandlinefu.com/commands/view/10771/osx-function-to-list-all-members-for-a-given-group
members() {
  dscl . -list /Users | while read -r user; do
    printf "%s " "$user"
    dsmemberutil checkmembership -U "$user" -G "$*"
  done | grep "is a member" | cut -d " " -f 1
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

alias bwhy='b uses --installed --recursive'

alias cask='brc'
alias ci='brc install'
alias caskrm="brew uninstall --cask --force"

# ----------------------------------------------------------------------------
# Apps
# ----------------------------------------------------------------------------

alias canary='open -a "Google Chrome Canary.app"'
alias chrome='open -a "Google Chrome.app"'
alias slack='open -a Slack.app'

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
alias xcimg='xcrun simctl addmedia booted'
