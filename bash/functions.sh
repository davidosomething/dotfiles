# https://github.com/jmcantrell/dotfiles-zsh/blob/master/zsh/conf.d/40-functions

##
# Make a new directory and CD into it
mcd() {
  mkdir -p "$@" && cd "$@"
}

##
# Change directory to the nearest repo root
cdr()
{
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
# type localip to get ethernet or wireless ip
localip() {
  local localip=$(ipconfig getifaddr en0)
  if [ -z "$localip" ]; then
    localip=$(ipconfig getifaddr en1)
  fi
  echo $localip
}

##
# http://www.commandlinefu.com/commands/view/10771/osx-function-to-list-all-members-for-a-given-group
members() {
  dscl . -list /Users | while read user; do printf "$user "; dsmemberutil checkmembership -U "$user" -G "$*"; done | grep "is a member" | cut -d " " -f 1;
}

##
# Export repo files to specified dir
gitexport() {
  local to_dir = "${2:-./gitexport}"
  rsync -a ${1:-./} $to_dir --exclude $to_dir --exclude .git
}

##
# Edit apache conf, needs to be a function to interpolate that variable
apacheconf() {
  e $APACHE_HTTPD_CONF
}

##
# Edit apache virtual hosts, needs to be a function to interpolate that variable
vhosts() {
  e $APACHE_HTTPD_VHOSTS
}

##
# update php version in apache config
update_httpd_conf_phpver() {
  sed "s/\/usr\/local\/Cellar\/php\([0-9]*\)\/\([\.0-9]*\)\//\/usr\/local\/Cellar\/php$PHPMINORVERNUM\/$PHPVER\//g" $APACHE_HTTPD_CONF >  $APACHE_HTTPD_CONF
}

##
# Get someone's SSH pubkeys from github
get_github_ssh_key() {
  if [ -z "$1" ]; then
    echo "Missing username"
    echo
    echo "USAGE: get_github_ssh_key GITHUB_USERNAME"
  else
    curl https://github.com/$1.keys
    echo
  fi
}

##
# os specific
case "$OSTYPE" in
  darwin*)  [ -f "$BASH_DOTFILES/functions-osx.sh" ] && source "$BASH_DOTFILES/functions-osx.sh"
            ;;
  linux*)   [ -f "$BASH_DOTFILES/functions-linux.sh" ] && source "$BASH_DOTFILES/functions-linux.sh"
            ;;
esac
