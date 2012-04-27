# https://github.com/jmcantrell/dotfiles-zsh/blob/master/zsh/conf.d/40-functions
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

# type localip to get ethernet or wireless ip
localip() {
  local localip="`ipconfig getifaddr en0`"
  if [[ "$localip" = "" ]]; then
    localip="`ipconfig getifaddr en1`"
  fi
  echo $localip
}

# recursively chowns folders ug+rws, files ug+rw from current folder
groupperms() {
  echo "You're sure ${PWD} is the right place? Last chance to Ctrl-C."
  read;
  sudo chmod -R ug+rw .*              # the dotfiles
  sudo chmod -R ug+rw *               # the files and folders
  sudo find . -type d -exec chmod ug+rws {} \;
}

