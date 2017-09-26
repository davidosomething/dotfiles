# shell/aliases-darwin.bash

alias b='TERM=xterm-256color \brew'
alias brew='b'

alias bi='b install'
alias bq='b list'
alias bs='b search'
alias blfn='b ls --full-name'

alias brc='b cask'

alias bsvc='b services'
alias bsvr='b services restart'

alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
alias chromium="/Applications/Chromium.app/Contents/MacOS/Chromium"

alias redstart='bsvc start redshift'
alias redstop='bsvc stop redshift'

# sudo since we run nginx on port 80 so needs admin
alias rnginx='sudo brew services restart nginx'

# electron apps can't focus if started using Electron symlink
alias elec='/Applications/Electron.app/Contents/MacOS/Electron'

# clear xattrs
alias xc='xattr -c *'

# Audio control - http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
