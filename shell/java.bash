# shell/java.bash

dko::has 'javac' \
  && JAVA_HOME="$(dirname "$(readlink "$(which javac)")")/java_home"
export JAVA_HOME
