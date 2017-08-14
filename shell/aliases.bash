# shell/aliases.bash
# Not run by loader
# Sourced by both .zshrc and .bashrc, so keep it bash compatible

export DKO_SOURCE="${DKO_SOURCE} -> shell/aliases.bash"

# ----------------------------------------------------------------------------
# safeguarding
# @see {@link https://github.com/sindresorhus/guides/blob/master/how-not-to-rm-yourself.md#safeguard-rm}
# ----------------------------------------------------------------------------

alias rm='rm -i'

# ----------------------------------------------------------------------------
# paths and dirs
# ----------------------------------------------------------------------------

alias ..='cd ..'
alias ....='cd ../..'
alias cd..='cd ..'
alias cdd='cd "${DOTFILES}"'
alias cdv='cd "${VDOTDIR}"'
alias dirs='dirs -v'                  # default to vert, use -l for list
alias tree='tree -CF'

# ----------------------------------------------------------------------------
# cat (prefer bin/dog)
# ----------------------------------------------------------------------------

alias pyg='pygmentize -O style=rrt -f console256 -g'

# ----------------------------------------------------------------------------
# editors
# ----------------------------------------------------------------------------

alias a='atom-beta'
alias e='vim'
alias ehosts='se /etc/hosts'
alias etmux='e "${DOTFILES}/tmux/tmux.conf"'
alias esd='e "${DOTFILES}/shell/dotfiles.bash"'
alias evr='e "${VDOTDIR}/vimrc"'
alias eze='e "${ZDOTDIR}/.zshenv"'
alias ezp='e "${ZDOTDIR}/zplug.zsh"'
alias ezr='e "${ZDOTDIR}/.zshrc"'

# ----------------------------------------------------------------------------
# git
# ----------------------------------------------------------------------------

if command -v hub >/dev/null; then alias g='hub'; else alias g='git'; fi
alias g-='g checkout -'
alias gb='g branch --verbose'
alias gi='g ink'
alias gg='g grep --line-number --break --heading'
alias gl='g l --max-count 25'
alias gm='g checkout master'
alias gp='g push'
alias gpo='g push origin'
alias gs='g status'
alias gt='g take'

# ----------------------------------------------------------------------------
# geth
# ----------------------------------------------------------------------------

alias gethsync='geth --syncmode "fast" --cache 1024 console'

# ----------------------------------------------------------------------------
# gradle
# ----------------------------------------------------------------------------

alias grwr='./gradlew run -DUseMemcached=true'

# ----------------------------------------------------------------------------
# greppers
# ----------------------------------------------------------------------------

alias f='find'
alias grep='grep --color=auto'

# always prefer ripgrep
if command -v rg >/dev/null; then
  alias ag='rg'
elif command -v ag >/dev/null; then
  # --numbers is a default and not supported on old ag
  # --one-device not supported on old ag
  alias ag='ag --hidden --smart-case'
fi
alias rg='rg --hidden --line-number --no-ignore-vcs --smart-case --ignore-file "${DOTFILES}/ag/dot.ignore"'
# also see gg in git

# ----------------------------------------------------------------------------
# node
# ----------------------------------------------------------------------------

alias n='npm'
alias ni='n install'
alias no='n outdated --long'
alias nr='n run --silent'
alias ns='n start'
alias nt='n test'
alias nu='n update'
alias nude='nvm use default'
alias sme='source-map-explorer'
alias y='yarn'
alias yi='yarn install'
alias yr='yarn run'
alias yt='yarn test'

# ----------------------------------------------------------------------------
# php
# ----------------------------------------------------------------------------

alias cm='composer'

# ----------------------------------------------------------------------------
# python
# ----------------------------------------------------------------------------

alias pea='pyenv activate'
alias ped='pyenv deactivate'
alias pss='pyenv shell system'
alias py2='python2'
alias py3='python3'
alias py='python'

alias getsubs="subliminal download -p opensubtitles -p shooter -p subscenter -p thesubdb -p tvsubtitles --language en "

# ----------------------------------------------------------------------------
# ruby
# ----------------------------------------------------------------------------

alias bun='bundle'
alias be='bun exec'
alias cap='be cap'

# ----------------------------------------------------------------------------
# ssh keys
# @see {@link https://blog.g3rt.nl/upgrade-your-ssh-keys.html}
# ----------------------------------------------------------------------------

# useful for finding things like INSECURE keys (acceptable: RSA 4096 or Ed25519)
alias sshlistkeys='for keyfile in ~/.ssh/id_*; do ssh-keygen -l -f "${keyfile}"; done | uniq'
# Keep this up to date with latest security best practices
alias sshkeygen='ssh-keygen -o -a 100 -t ed25519'

# ----------------------------------------------------------------------------
# sudo ops
# ----------------------------------------------------------------------------

alias mine='sudo chown -R "$USER"'
alias root='sudo -s'
alias se='sudo -e'

# ----------------------------------------------------------------------------
# tmux
# ----------------------------------------------------------------------------

alias tmux='tmux -f "${DOTFILES}/tmux/tmux.conf"'
alias ta='tmux attach'

# ----------------------------------------------------------------------------
# xcode
# ----------------------------------------------------------------------------

alias cuios='XCODE_XCCONFIG_FILE="${PWD}/xcconfigs/swift31.xcconfig" carthage update --platform iOS'

# ----------------------------------------------------------------------------
# rest of bins
# ----------------------------------------------------------------------------

alias archey='archey --offline'
alias brokensymlinks='find . -type l ! -exec test -e {} \; -print'
alias cb='cdbk'
alias curl='curl --config "${DOTFILES}/curl/dot.curlrc"'
alias df='df -h'
alias ln='ln -v'
alias mdl='mdl --config "${DOTFILES}/mdl/dot.mdlrc"'
alias neofetch='neofetch --image ~/Dropbox/_avatars/trafalgarlaw_W.png --size 240px --gap 20 --disable de wm'
alias o='dko-open'
alias publicip='\curl icanhazip.com'
alias rsync='rsync --human-readable --partial --progress'
alias t="tree -a --noreport --dirsfirst -I '.git|node_modules|bower_components|.DS_Store'"
alias today='date +%Y-%m-%d'
alias tpr='tput reset'                # really clear the scrollback
alias u='dko::dotfiles'
alias vag='vagrant'
alias vb='VBoxManage'
alias vbm='vb'
alias weechat='weechat -d "${DOTFILES}/weechat"'
alias wget='wget --no-check-certificate --hsts-file="${XDG_DATA_HOME}/wget/.wget-hsts"'
alias xit='exit' # dammit

# ============================================================================

__alias_ls() {
  local almost_all='-A' # switchted from --almost-all for old bash support
  local classify='-F' # switched from --classify for old bash support
  local colorized='--color=auto'
  local groupdirs='--group-directories-first'
  local literal=''
  local long='-l'
  local single_column='-1'
  local timestyle=''

  if ! ls $groupdirs >/dev/null 2>&1; then
    groupdirs=''
  fi

  if [ "$DOTFILES_OS" = 'Darwin' ]; then
    almost_all='-A'
    classify='-F'
    colorized='-G'
  fi

  if [ "$DOTFILES_OS" = 'Linux' ] && [ "$DOTFILES_DISTRO" != 'busybox' ]; then
    literal='-N'
    timestyle='--time-style="+%Y%m%d"'
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

__alias_exa() {
  if ! dko::has 'exa'; then
    return
  fi

  alias exa='exa --long --all --group-directories-first --group --git'
}
__alias_exa

# ============================================================================

__alias_darwin() {
  alias b='TERM=xterm-256color \brew'
  alias brew='b'

  alias bi='b install'
  alias bq='b list'
  alias bs='b search'

  alias bsvc='b services'
  alias bsvr='b services restart'

  alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
  alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
  alias chromium="/Applications/Chromium.app/Contents/MacOS/Chromium"

  alias redstart='bsvc start redshift'
  alias redstop='bsvc stop redshift'

  # sudo since we run nginx on port 80 so needs admin
  alias rnginx='sudo brew services restart nginx'

  # electron apps can't focus if started using Electron symlink
  alias elec='/Applications/Electron.app/Contents/MacOS/Electron'

  # clear xattrs
  alias xc='xattr -c *'

  # Audio control - http://xkcd.com/530/
  alias stfu="osascript -e 'set volume output muted true'"
}

# ============================================================================

__alias_linux() {
  alias open='o'                    # use open() function in shell/functions
  alias startx='startx > "${DOTFILES}/logs/startx.log" 2>&1'

  alias testnotification="notify-send \
    'Hello world!' \
    'This is an example notification.' \
    --icon=dialog-information"
}

# ============================================================================

__alias_arch() {
  alias paclast="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -20"

  if command -v pacaur >/dev/null; then
    alias b='pacaur'
  elif command -v yaourt >/dev/null; then
    alias b='yaourt'
  fi
  alias bi='b -S'
  alias bq='b -Qs'
  alias bs='b -Ss'

  # Always create log file
  alias makepkg='makepkg --log'

  alias rphp='sudo systemctl restart php-fpm.service'
  alias rnginx='sudo systemctl restart nginx.service'
}

# ============================================================================

__alias_deb() {
  alias b='sudo apt'
  alias bi='b install'
  alias bs='b search'
}

# ============================================================================

__alias_fedora() {
  alias b='sudo dnf'
}

# ============================================================================
# os specific
# ============================================================================

case "$OSTYPE" in
  darwin*)  __alias_darwin ;;
  linux*)   __alias_linux
    case "$DOTFILES_DISTRO" in
      busybox)                  ;;
      archlinux)  __alias_arch   ;;
      debian)     __alias_deb    ;;
      fedora)     __alias_fedora ;;
    esac
    ;;
esac
