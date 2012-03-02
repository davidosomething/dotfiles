zdotdir=$HOME/.zsh

export EDITOR=vim
export VISUAL='subl -w'
export SVN_EDITOR=$EDITOR

export COLORS=$(tput colors 2> /dev/null)

#export JAVA_HOME=
export ANT_HOME=/opt/local/share/java/apache-ant
export MACPORTS_HOME=/opt/local

path=($path $HOME/bin)
path=($path $ANT_HOME/bin)
path=($path $MACPORTS_HOME/bin)
