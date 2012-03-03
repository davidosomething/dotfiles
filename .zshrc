####
# Zsh options
# only run on interactive/TTY

fpath=( $HOME/src/zsh-completions $fpath )

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
export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000

# editing settings
export EDITOR=vim

##
# aliases
alias vi='vim'
alias ls='ls -AFG'
alias ll='ls -l'
alias zshrc="$EDITOR ~/.zsh/.zshrc"
alias reloadzshrc='source ~/.zshrc'
alias hosts="sudo $EDITOR /etc/hosts"
alias phpini="sudo $EDITOR /opt/local/etc/php5/php.ini"
alias apacheconf="sudo $EDITOR /opt/local/apache2/conf/httpd.conf"
alias apache2ctl='sudo /opt/local/apache2/bin/apachectl'
alias vhosts="sudo $EDITOR /opt/local/apache2/conf/extra/httpd-vhosts.conf"
alias apacheerrors='tail /opt/local/apache2/logs/error_log'
alias wget='wget --no-check-certificate'

##
# prompt
autoload -U colors && colors
autoload -Uz vcs_info
setopt prompt_subst # allow variables in prompt
# version control info in prompt
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'		# display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '+'			# display this when there are staged changes
zstyle ':vcs_info:*' formats '(%b%c%u)'
zstyle ':vcs_info:*' actionformats '(%b%c%u)[%a]'
precmd() { vcs_info }
# show if in vi mode
VIMODE='I';
function zle-line-init zle-keymap-select {
  VIMODE="${${KEYMAP/vicmd/N}/(main|viins)/I}"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
# prompt itself
PROMPT='%F{green}%n%F{blue}@%F{green}%m%F{blue}:%F{yellow}%~
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
# local
source ~/.zshrc.local >/dev/null 2>&1 # may or may not exist
