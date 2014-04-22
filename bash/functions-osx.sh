a2() {
  apachectl $@
}

a2r() {
  apachectl -t && sudo apachectl -e info -k restart
}

brc() {
  brew cask $@
}

flushdns() {
  dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

################################################################################
# OSX filesystem
##
# http://www.commandlinefu.com/commands/view/10771/osx-function-to-list-all-members-for-a-given-group
members() {
  dscl . -list /Users | while read user; do printf "$user "; dsmemberutil checkmembership -U "$user" -G "$*"; done | grep "is a member" | cut -d " " -f 1;
}

