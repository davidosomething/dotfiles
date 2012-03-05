##
# zshenv is always sourced, even for bg jobs

zdotdir=$HOME/.zsh

export COLORS=$(tput colors 2>/dev/null)

export MACPORTS_HOME=/opt/local
#export JAVA_HOME=
export ANT_HOME=/opt/local/share/java/apache-ant

# $path must be last to give new things precedence!
path=( $MACPORTS_HOME/bin $MACPORTS_HOME/sbin $path )
path=( $ANT_HOME/bin $path )
path=( $HOME/bin $path )

##
# local
source ~/.zshenv.local >/dev/null 2>&1 # may or may not exist
