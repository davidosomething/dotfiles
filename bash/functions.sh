################################################################################
# dev
art() {
  php artisan $@
}
cunt() {
  COMPOSER_CACHE_DIR=/dev/null composer update
}

##
# PHP version numbers
# @TODO use cut instead of splitting awk?
phpver() {
  php -r 'echo phpversion();'
}
phpminorver() {
  php -r "echo PHP_MAJOR_VERSION . '.' . PHP_MINOR_VERSION;"
}
eapache() {
  e $APACHE_HTTPD_CONF $@
}
ephpini() {
  e $PHP_INI $@
}
evhosts() {
  e $APACHE_HTTPD_VHOSTS $@
}

################################################################################
# file traversal
##
# Change directory to the nearest repo root
cdr() {
  local dir=${1:-$PWD}
  if [[ -d $dir/.svn ]]; then
    while [[ -d $dir/.. && -d $dir/../.svn ]]; do
      dir+=/..
    done
  else
    while [[ -d $dir && ! ( -d $dir/.git || -d $dir/.hg || -d $dir/.bzr ) ]]; do
      dir+=/..
    done
  fi
  [[ -d $dir ]] && cd "$dir"
}

##
# up 2 to cd ../..
up() {
  local x='';for i in $(seq ${1:-1});do x="$x../"; done;cd $x;
}

################################################################################
# Archiving
##
# Export repo files to specified dir
gitexport() {
  local to_dir = "${2:-./gitexport}"
  rsync -a ${1:-./} $to_dir --exclude $to_dir --exclude .git
}

##
# extract most known archive types
# http://alias.sh/extract-most-know-archives-one-command
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.7z)        7z x $1        ;;
      *.Z)         uncompress $1  ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
  esac
else
  echo "'$1' is not a valid file"
fi
}

################################################################################
# Network tools

##
# type localip to get ethernet or wireless ip
localip() {
  local localip=$(ipconfig getifaddr en0)
  if [ -z "$localip" ]; then
    localip=$(ipconfig getifaddr en1)
  fi
  echo $localip
}

##
# source a file if it exists
source_if_exists() {
  [ -f $1 ] && source $1 # && echo "Sourced $1"
}


##
# os specific
case "$OSTYPE" in
  darwin*)  source_if_exists "$BASH_DOTFILES/functions-osx.sh"
    ;;
  linux*)   source_if_exists "$BASH_DOTFILES/functions-linux.sh"
    ;;
esac
