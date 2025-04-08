# shellcheck shell=bash
# shell/java.sh

export DKO_SOURCE="${DKO_SOURCE} -> shell/java.sh {"

export GRADLE_USER_HOME="${XDG_CONFIG_HOME}/gradle"

# java settings - mostly for minecraft launcher
alias jgui="_JAVA_OPTIONS=\"-Dawt.useSystemAAFontSettings=on \\ \
  -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel \\ \
  -Dswing.systemlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel\" \\ \
  JAVA_FONTS=\"/usr/share/fonts/TTF\" java"

DKO_SOURCE="${DKO_SOURCE} }"
