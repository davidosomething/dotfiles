##
# Scripts and things that are run from login shells go here
# Only need this stuff if it's interactive AND a login shell

##
# functions

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# type localip to get ethernet or wireless ip
localip() {
  local localip="`ipconfig getifaddr en0`"
  if [[ "$localip" = "" ]]; then
    localip="`ipconfig getifaddr en1`"
  fi
  echo $localip
}

# colored path from https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh
path() {
  echo $PATH | tr ":" "\n" | \
    awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
           sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
           sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
           sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
           sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
           print }"
}

