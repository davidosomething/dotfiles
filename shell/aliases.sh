# shell/aliases
# Not run by loader
# Sourced by both .zshrc and .bashrc, so keep it bash compatible

export DKO_SOURCE="${DKO_SOURCE} -> shell/aliases.sh"

# paths and dirs
alias ..="cd .."
alias ....="cd ../.."
alias cd..="cd .."
alias cdd="cd \"\${DOTFILES}\""
alias cdv="cd \"\${VIM_DOTFILES}\""
alias dirs="dirs -v"                  # default to vert, use -l for list
alias tree="tree -C"

# cat
alias pyg="pygmentize -O style=rrt -f console256 -g"

# editors
alias a="atom"
alias e="\$EDITOR"
alias ehosts="se /etc/hosts"
alias etmux="e \"\${DOTFILES}/tmux/tmux.conf\""
alias evr="e \"\${VIM_DOTFILES}/vimrc\""
alias eze="e \"\${ZDOTDIR}/.zshenv\""
alias ezp="e \"\${ZDOTDIR}/zplug.zsh\""
alias ezr="e \"\${ZDOTDIR}/.zshrc\""

# git
alias g="git"
alias g-="git co -"
alias gb="git branch --verbose"
alias gi="git ink"
alias gg="git grep --line-number --break --heading"
alias gl="git l"
alias gp="git push"
alias gpo="git push origin"

# greppers
alias f="find"
alias grep="grep --color=auto"
alias ag="ag --hidden --smart-case --one-device --path-to-ignore \"\${DOTFILES}/ag/dot.ignore\""
alias rg="rg --hidden --smart-case"
# also see gg in git

# node
alias bfy="browserify"
alias n="npm"
alias npmo="n outdated --long"
alias nog="npmo --global"
alias ncu="npmo"
alias nude="nvm use default"

# php
alias cm="composer"

# python
alias pea="pyenv activate"
alias ped="pyenv deactivate"
alias pss="pyenv shell system"
alias py2="python2"
alias py3="python3"
alias py="python"

# ruby
alias be="bundle exec"
alias bun="bundle"
alias cap="bundle exec cap"

# rest of bins
alias archey="archey --offline"
alias cb="cdbk"
alias df="df -h"
alias ln="ln -v"
alias mdl="mdl --config \"\${DOTFILES}/mdl/.mdlrc\""
alias o="dko-open"
alias publicip="curl icanhazip.com"
alias rsync="rsync --human-readable --partial --progress" 
alias tmux="tmux -f \"\${DOTFILES}/tmux/tmux.conf\""
alias t="tree -a --noreport --dirsfirst -I '.git|node_modules|bower_components|.DS_Store'"
alias today="date +%Y-%m-%d"
alias tpr="tput reset"                # really clear the scrollback
alias u="dko::dotfiles"
alias vag="vagrant"
alias vb="VBoxManage"
alias vbm="VBoxManage"
alias weechat="weechat -d \"\${DOTFILES}/weechat\""
alias wget="wget --no-check-certificate --hsts-file=\"\${XDG_DATA_HOME}/wget/.wget-hsts\""
alias xit="exit" # dammit

# sudo ops
alias mine="sudo chown -R \"\$USER\""
alias root="sudo -s"
alias se="sudo -e"

# remote
alias mc="ssh rmc -t -- \".local/bin/ftb\""

# ============================================================================

__alias_ls() {
  local almost_all="-A" # switchted from --almost-all for old bash support
  local classify="-F" # switched from --classify for old bash support
  local colorized="--color=auto"
  local groupdirs="--group-directories-first"
  local literal=""
  local long="-l"
  local single_column="-1"
  local timestyle=""

  if ! ls $groupdirs >/dev/null 2>&1; then
    groupdirs=""
  fi

  if [ "$DOTFILES_OS" = "Darwin" ]; then
    almost_all="-A"
    classify="-F"
    colorized="-G"
  fi

  if [ "$DOTFILES_OS" = "Linux" ] && [ "$DOTFILES_DISTRO" != "busybox" ]; then
    literal="-N"
    timestyle="--time-style=\"+%Y%m%d\""
  fi

  # shellcheck disable=SC2139
  alias ls="ls $colorized $literal $classify $groupdirs $timestyle"
  # shellcheck disable=SC2139
  alias la="ls $almost_all"
  # shellcheck disable=SC2139
  alias l="ls $single_column $almost_all"
  # shellcheck disable=SC2139
  alias ll="l $long"
  # shit
  alias kk='ll'
}
__alias_ls

# ============================================================================

__alias_darwin() {
  alias b="TERM=xterm-256color brew"
  alias brew="TERM=xterm-256color brew"

  alias bi="b install"
  alias bq="b list"
  alias bs="b search"

  alias bsvc="b services"
  alias bsvr="b services restart"

  # sudo since we run nginx on port 80 so needs admin
  alias rnginx="sudo brew services restart nginx"

  # electron apps can't focus if started using Electron symlink
  alias elec="/Applications/Electron.app/Contents/MacOS/Electron"

  # clear xattrs
  alias xc="xattr -c *"

  # Audio control - http://xkcd.com/530/
  alias stfu="osascript -e 'set volume output muted true'"
}

# ============================================================================

__alias_linux() {
  alias open="o"                    # use open() function in shell/functions
  alias startx="startx > \"\${DOTFILES}/logs/startx.log\" 2>&1"

  alias testnotification="notify-send \
    'Hello world!' \
    'This is an example notification.' \
    --icon=dialog-information"
}

# ============================================================================

__alias_arch() {
  alias paclast="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -20"

  if command -v pacaur >/dev/null; then
    alias b="pacaur"
  elif command -v yaourt >/dev/null; then
    alias b="yaourt"
  fi
  alias bi="b -S"
  alias bq="b -Qs"
  alias bs="b -Ss"

  # Always create log file
  alias makepkg="makepkg --log"

  alias rphp="sudo systemctl restart php-fpm.service"
  alias rnginx="sudo systemctl restart nginx.service"
}

# ============================================================================

__alias_deb() {
  alias b="sudo apt "
}

# ============================================================================

# os specific
case "$OSTYPE" in
  darwin*)  __alias_darwin ;;
  linux*)   __alias_linux
    case "$DOTFILES_DISTRO" in
      busybox)                  ;;
      archlinux)  __alias_arch   ;;
      debian)     __alias_deb    ;;
    esac
    ;;
esac

# vim: ft=sh :
