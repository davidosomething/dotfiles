####
# zsh options
# only run on interactive/TTY

setopt AUTO_CD
setopt AUTO_PUSHD                     # pushd instead of cd
setopt PUSHD_TO_HOME                  # go home if no d specified
setopt PUSHD_SILENT                   # don't show stack after cd
setopt CDABLE_VARS
setopt NO_HUP                         # don't kill bg processes
setopt AUTO_LIST                      # list completions
setopt CORRECT

##
# command history
# these exports only needed when there's a TTY
setopt appendhistory
export HISTSIZE=500
export SAVEHIST=500

# editing settings
export EDITOR=vim

##
# aliases
# some of these paths are set in .zshenv.local!
alias vi="vim"
alias dirs="dirs -v"                  # default to vert, use -l for list
alias zshrc="$EDITOR ~/.zshrc"
alias reloadzshrc="source ~/.zshrc"
alias hosts="sudo $EDITOR /etc/hosts"
alias phpini="sudo $EDITOR $PHP_INI"
alias apacheconf="sudo $EDITOR $APACHE_HOME/conf/httpd.conf"
alias vhosts="sudo $EDITOR $APACHE_HOME/conf/extra/httpd-vhosts.conf"
alias apache2ctl="sudo $APACHE_HOME/bin/apachectl"
alias apacheerrors="tail $APACHE_HOME/logs/error_log"
alias wget="wget --no-check-certificate"

##
# prompt
setopt prompt_subst                   # allow variables in prompt
autoload -U colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
# version control info in prompt
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'  # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '+'    # display this when there are staged changes
zstyle ':vcs_info:*' formats '(%b%m%c%u)'
zstyle ':vcs_info:*' actionformats '(%b%m%c%u)[%a]'
# show if in vi mode
VIMODE='I';
function zle-line-init zle-keymap-select {
  VIMODE="${${KEYMAP/vicmd/N}/(main|viins)/I}"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
bindkey -v                            # use vi mode even if EDITOR is emacs
# prompt itself
PROMPT_HOST='%F{green}%m'
if [[ $SSH_CONNECTION != '' ]]; then PROMPT_HOST='%F{white}%m'; fi
PROMPT='%F{green}%n%F{blue}@${PROMPT_HOST}%F{blue}:%F{yellow}%~
%f%*%F{blue}${VIMODE}%F{magenta}${vcs_info_msg_0_}%# %f'

##
# key bindings
autoload -U compinit && compinit

##
# zstyles
# case-insensitive tab completion for filenames (useful on Mac OS X)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' expand 'yes'

##
# zsh-syntax-highlighting plugin
source ~/.dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh >/dev/null 2>&1 # may or may not exist

##
# local
source ~/.zshrc.local >/dev/null 2>&1 # may or may not exist
