# shell/java.bash

dko::has 'javac' \
  && JAVA_HOME="$(dirname "$(readlink "$(which javac)")")/java_home"

[ -z "$JAVA_HOME" ] \
  && export JAVA_HOME \
  && export PATH="${JAVA_HOME}/bin:${PATH}"
