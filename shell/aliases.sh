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
alias tree='tree -CF'
alias t="tree -a --noreport --dirsfirst -I '.git|node_modules|bower_components|.DS_Store'"

# ----------------------------------------------------------------------------
# ansible
# ----------------------------------------------------------------------------

alias ap='ansible-playbook -vvv'

# ----------------------------------------------------------------------------
# cat (prefer bat)
# ----------------------------------------------------------------------------

alias c='bat --paging never'
alias crm='bat --plain README.md'
alias cpj='bat --plain package.json'
alias pyg='pygmentize -O style=rrt -f console256 -g'

# ----------------------------------------------------------------------------
# docker
# ----------------------------------------------------------------------------

alias docc='docker-compose'
alias sdocc='sudo docker-compose'

# ----------------------------------------------------------------------------
# editors
# ----------------------------------------------------------------------------

alias ehosts='se /etc/hosts'
alias etmux='e "${DOTFILES}/tmux/tmux.conf"'
alias essh='e "${HOME}/.ssh/config"'
alias ega='e "${DOTFILES}/git/aliases.gitconfig"'
alias evr='e "${VDOTDIR}/vimrc"'
alias evp='e "${VDOTDIR}/autoload/dkoplug/plugins.vim"'
alias eze='e "${ZDOTDIR}/dot.zshenv"'
alias ezp='e "${ZDOTDIR}/zplug.zsh"'
alias ezl='e "${LDOTDIR}/zshrc"'
alias ezr='e "${ZDOTDIR}/.zshrc"'

# ----------------------------------------------------------------------------
# gem
# ----------------------------------------------------------------------------

alias gemrm='gem uninstall --all'

# ----------------------------------------------------------------------------
# git
# ----------------------------------------------------------------------------

alias g-='git checkout -'
alias gb='git b'
alias gl='git l --max-count 20'
alias gm='git checkout "$(git symbolic-ref refs/remotes/origin/HEAD | cut -f4 -d/)"'

# ----------------------------------------------------------------------------
# gradle
# ----------------------------------------------------------------------------

alias gw='./gradlew -DUseMemcached=true'
alias gwc='gw compileJava'
alias gwr='gw run'

# ----------------------------------------------------------------------------
# greppers
# ----------------------------------------------------------------------------

alias grep='grep --color=auto'

# also see gg in git

# ----------------------------------------------------------------------------
# java
# ----------------------------------------------------------------------------

alias pmddir='pmd pmd -dir ./ -format textcolor -rulesets '

# ----------------------------------------------------------------------------
# kubernetes
# ----------------------------------------------------------------------------

alias kctl='kubectl'
alias kctx='kubectx'
alias kns='kubens'

# ----------------------------------------------------------------------------
# node / JS
# ----------------------------------------------------------------------------

alias gulp='npx gulp'
alias grunt='npx grunt'
alias n='npm'
alias ni='n install'
alias nomod='rm -rf ./node_modules'
alias likereallynomod='find . -type d -iname node_modules -exec rm \-rf {} \;'
alias nr='n run'
alias ns='n start'
alias y='yarn'
alias yi='yarn install'
alias yr='yarn run'
alias yt='yarn test'

# ----------------------------------------------------------------------------
# python
# ----------------------------------------------------------------------------

alias pea='pyenv activate'
alias ped='pyenv deactivate'
alias pss='pyenv shell system'

alias py2='python2'
alias py3='python3'
alias py='python'

# https://snarky.ca/why-you-should-use-python-m-pip/
alias pip='python -m pip'
alias pir='pip install --requirement=requirements.txt'

alias getsubs='pipx run subliminal download -p opensubtitles -p shooter -p subscenter -p thesubdb -p tvsubtitles --language en '

# ----------------------------------------------------------------------------
# ruby
# ----------------------------------------------------------------------------

alias bun='bundle'
alias be='bun exec'
alias ruby-install='ruby-install --rubies-dir "$DKO_RUBIES"'

# ----------------------------------------------------------------------------
# shfmt
# ----------------------------------------------------------------------------

alias shfmt='shfmt -i 2 -bn -ci -kp'

# ----------------------------------------------------------------------------
# ssh
# ----------------------------------------------------------------------------

# @see {@link https://blog.g3rt.nl/upgrade-your-ssh-keys.html}
# Keep this up to date with latest security best practices
alias sshkeygen='ssh-keygen -o -a 100 -t ed25519'

# ----------------------------------------------------------------------------
# sudo ops
# ----------------------------------------------------------------------------

alias root='sudo -s'
alias se='sudo -e'

# ----------------------------------------------------------------------------
# tmux
# ----------------------------------------------------------------------------

alias tmux='tmux -f "${DOTFILES}/tmux/tmux.conf"'
alias ta='tmux attach'

# ----------------------------------------------------------------------------
# rest of bins
# ----------------------------------------------------------------------------

alias brokensymlinks='find . -type l ! -exec test -e {} \; -print'
alias curl='curl --config "${DOTFILES}/curl/dot.curlrc"'
alias df='df -h'
alias gpgreload='gpg-connect-agent reloadagent /bye'
alias ln='ln -v'
alias o='dko-open'
alias rsync='rsync --human-readable --partial --progress'
alias today='date +%Y-%m-%d'
alias tpr='tput reset' # really clear the scrollback
alias u='dot'
alias vag='vagrant'
alias vb='VBoxManage'
alias vbm='vb'
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

  if [ "$DOTFILES_OS" = 'Darwin' ]; then
    #__almost_all='-A'
    #__classify='-F'
    __colorized='-G'
    __groupdirs=''
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

  unset __almost_all __classify __colorized __groupdirs \
    __literal __long __single_column __timestyle
}
__alias_ls
