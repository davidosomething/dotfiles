#!/usr/bin/env bash
set -eu

# Initially create XDG dirs
# Run after shell/vars sourced
#

mkdir -p "$BZR_PLUGIN_PATH"
mkdir -p "$BZR_HOME"
mkdir -p "$COMPOSER_CACHE_DIR"
