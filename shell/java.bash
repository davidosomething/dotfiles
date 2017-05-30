# shell/java.bash

export DKO_SOURCE="${DKO_SOURCE} -> shell/java.bash"

if dko::has '/usr/libexec/java_home'; then
  JAVA_HOME="$(/usr/libexec/java_home -v1.8)"
elif dko::has 'javac'; then
  JAVA_HOME="$(dirname "$(readlink "$(which javac)")")/java_home"
fi

[ -n "$JAVA_HOME" ] \
  && export JAVA_HOME \
  && export PATH="${JAVA_HOME}/bin:${PATH}"

# java settings - mostly for minecraft launcher
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.systemlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
export JAVA_FONTS="/usr/share/fonts/TTF"

