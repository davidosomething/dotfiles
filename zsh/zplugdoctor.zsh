# source this file

__zplugdoctor::log() { echo -e "\033[0;34m==>\033[0;32m $*\033[0;m"; }
__zplugdoctor::err() { echo -e "\033[0;31m==> ERR: \033[0;m$*\033[0;m" >&2; }

zplugdoctor() {
  __zplugdoctor::log 'uname -a'
  uname -a

  __zplugdoctor::log 'zsh version'
  zsh --version

  if [ -z "$ZPLUG_ROOT" ]; then
    __zplugdoctor::err "ZPLUG_ROOT not defined"
    return 1
  fi

  if [ ! -f "${ZPLUG_ROOT}/init.zsh" ]; then
    __zplugdoctor::err "ZPLUG_ROOT/init.zsh not found"
    return 1
  fi

  command -v zplug >/dev/null || {
    __zplugdoctor::err "zplug command does not exist (not installed properly?)"
    return 1
  }

  __zplugdoctor::log "zplug rev"
  git --git-dir="${ZPLUG_ROOT}/.git" rev-parse HEAD

  __zplugdoctor::log "zplug env"
  zplug env
}

#vim: ft=zsh
