# shell/xdg.sh

[ -n "$DKO_SOURCED_XDG" ] && return
export DKO_SOURCED_XDG=1
DKO_SOURCE="${DKO_SOURCE} -> shell/xdg.sh {"

# ============================================================================
# Preferred locations
# ============================================================================

# pretty much the defaults, but explicitly provide for my own use
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"

# ============================================================================
# user-dirs
# ============================================================================

# user-dirs.dirs doesn't exist on macOS/OS X so check first.
# Exporting is fine since the file is generated via xdg-user-dirs-update
# and should have those vars. I am just using the defaults but want them
# explicitly defined.
# shellcheck source=/dev/null
[ -f "${XDG_CONFIG_HOME}/user-dirs.dirs" ] \
  && . "${XDG_CONFIG_HOME}/user-dirs.dirs" \
  && export                             \
    XDG_DESKTOP_DIR                     \
    XDG_DOWNLOAD_DIR                    \
    XDG_TEMPLATES_DIR                   \
    XDG_PUBLICSHARE_DIR                 \
    XDG_DOCUMENTS_DIR                   \
    XDG_MUSIC_DIR                       \
    XDG_PICTURES_DIR                    \
    XDG_VIDEOS_DIR                      \
  && DKO_SOURCE="${DKO_SOURCE} -> ${XDG_CONFIG_HOME}/user-dirs.dirs"

# ============================================================================
# Defaults if not set in user-dirs
# ============================================================================

export XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-${HOME}/Downloads}"

# ============================================================================

export DKO_SOURCE="${DKO_SOURCE} }"
