# shell/aliases.sh
# Not run by loader
# Sourced by both .zshrc and .bashrc, so keep it POSIX compatible

export DKO_SOURCE="${DKO_SOURCE} -> shell/aliases.sh"

# ----------------------------------------------------------------------------
# safeguarding
# @see {@link https://github.com/sindresorhus/guides/blob/master/how-not-to-rm-yourself.md#safeguard-rm}
# ----------------------------------------------------------------------------

alias rm='rm -i'

# ----------------------------------------------------------------------------
# paths and dirs
# ----------------------------------------------------------------------------

alias ..='cd -- ..'
alias ....='cd -- ../..'
alias cd-='cd -- -'
alias cd..='cd -- ..'
alias cdd='cd -- "${DOTFILES}"'
alias cdv='cd -- "${VDOTDIR}"'
alias dirs='dirs -v' # default to vert, use -l for list
alias down='cd -- "${XDG_DOWNLOAD_DIR}"'
alias downs='down'
alias tree='tree -CF'

# ----------------------------------------------------------------------------
# cat (prefer bin/dog)
# ----------------------------------------------------------------------------

alias pyg='pygmentize -O style=rrt -f console256 -g'
alias d='icdiff -line-numbers --tabsize=4 --numlines=8'

# ----------------------------------------------------------------------------
# editors
# ----------------------------------------------------------------------------

alias a='atom-beta'
alias e='vim'
alias ehosts='se /etc/hosts'
alias etmux='e "${DOTFILES}/tmux/tmux.conf"'
alias esd='e "${DOTFILES}/bin/dot"'
alias evr='e "${VDOTDIR}/vimrc"'
alias evp='e "${VDOTDIR}/autoload/dkoplug/plugins.vim"'
alias eze='e "${ZDOTDIR}/dot.zshenv"'
alias ezl='e "${DOTFILES}/local/zshrc"'
alias ezp='e "${ZDOTDIR}/zplugin.zsh"'
alias ezr='e "${ZDOTDIR}/.zshrc"'

# ----------------------------------------------------------------------------
# gem
# ----------------------------------------------------------------------------

alias gemrm='gem uninstall --all'

# ----------------------------------------------------------------------------
# geth
# ----------------------------------------------------------------------------

alias gethsync='geth --syncmode "fast" --cache 1024 console'

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
# gradle
# ----------------------------------------------------------------------------

alias gw='./gradlew -DUseMemcached=true'
alias gwc='gw compileJava'
alias gwr='gw run'

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
# java
# ----------------------------------------------------------------------------

alias pmddir='pmd pmd -dir ./ -format textcolor -rulesets '

# ----------------------------------------------------------------------------
# node
# ----------------------------------------------------------------------------

alias n='npm'
alias ni='n install'
alias no='n outdated --long'
alias nolocks='n config set package-lock false'
alias nomod='rm -rf ./node_modules'
alias likereallynomod='find . -type d -iname node_modules -exec rm \-rf {} \;'
alias nr='n run'
alias nrm="n rm"
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
# shfmt
# ----------------------------------------------------------------------------

alias shfmt='shfmt -i 2 -bn -ci'

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
alias bashate='bashate -i E003,E006'
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
alias tpr='tput reset' # really clear the scrollback
alias u='dot'
alias vag='vagrant'
alias vb='VBoxManage'
alias vbm='vb'
alias weechat='weechat -d "${DOTFILES}/weechat"'
alias wget='wget --no-check-certificate --hsts-file="${XDG_DATA_HOME}/wget/.wget-hsts"'
alias xit='exit' # dammit

# ============================================================================

__alias_ls() {
  __almost_all='-A' # switched from --almost-all for old bash support
  __classify='-F'   # switched from --classify for old bash support
  __colorized='--color=auto'
  __groupdirs='--group-directories-first'
  __literal=''
  __long='-l'
  __single_column='-1'
  __timestyle=''

  if ! ls $__groupdirs >/dev/null 2>&1; then
    __groupdirs=''
  fi

  if [ "$DOTFILES_OS" = 'Darwin' ]; then
    __almost_all='-A'
    __classify='-F'
    __colorized='-G'
  elif [ "$DOTFILES_OS" = 'Linux' ] \
    && [ "$DOTFILES_DISTRO" != 'busybox' ]; then
    __literal='-N'
    __timestyle='--time-style="+%Y%m%d"'
  fi

  # shellcheck disable=SC2139
  alias ls="ls $__colorized $__literal $__classify $__groupdirs $__timestyle"
  # shellcheck disable=SC2139
  alias la="ls $__almost_all"
  # shellcheck disable=SC2139
  alias l="ls $__single_column $__almost_all"
  # shellcheck disable=SC2139
  alias ll="l $__long"
  # shit
  alias kk='ll'
}
__alias_ls
