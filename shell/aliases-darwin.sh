# shell/aliases-darwin.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/aliases-darwin.sh"

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
