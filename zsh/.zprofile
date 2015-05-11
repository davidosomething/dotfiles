# Sourced in login shells only
# Remember on OSX every shell is a login shell
# Sourced before .zshrc

export DKO_SOURCE="$DKO_SOURCE -> zprofile"

# create and use "/tmp/$XDG_RUNTIME_DIR"
if [ -z "${XDG_RUNTIME_DIR}" ]; then
  export XDG_RUNTIME_DIR="/tmp/${UID}-runtime-dir"
  if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
    mkdir "${XDG_RUNTIME_DIR}"
    chmod 0700 "${XDG_RUNTIME_DIR}"
  fi
fi

