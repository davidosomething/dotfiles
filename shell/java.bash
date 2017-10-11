# shell/java.bash

export DKO_SOURCE="${DKO_SOURCE} -> shell/java.bash"

export GRADLE_USER_HOME="${XDG_CONFIG_HOME}/gradle"

__java_version="1.8"
if [[ -z "$JAVA_HOME" ]] && [[ -x '/usr/libexec/java_home' ]]; then
  JAVA_HOME="$(/usr/libexec/java_home -v"$__java_version" 2>/dev/null)"
fi

[[ -n "$JAVA_HOME" ]] \
  && export JAVA_HOME \
  && export PATH="${JAVA_HOME}/bin:${PATH}"

# java settings - mostly for minecraft launcher
alias jgui="_JAVA_OPTIONS=\"-Dawt.useSystemAAFontSettings=on \\ \
  -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel \\ \
  -Dswing.systemlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel\" \\ \
  JAVA_FONTS=\"/usr/share/fonts/TTF\" java"
