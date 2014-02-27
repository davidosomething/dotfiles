##
# .dotfiles/zsh/prompt.zsh

##
# prompt
setopt PROMPT_SUBST                   # allow variables in prompt
autoload -U colors && colors

##
# version control in prompt
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'  # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '+'    # display this when there are staged changes
zstyle ':vcs_info:*' formats '(%b%m%c%u)'
zstyle ':vcs_info:*' actionformats '(%b%m%c%u)[%a]'

##
# vi mode
# http://paulgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
# use vi mode even if EDITOR is emacs
bindkey -v

# show if in vi mode
function zle-line-init zle-keymap-select {
  vimode="${${KEYMAP/vicmd/N}/(main|viins)/I}"
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# on end of cmd, back to ins mode
function zle-line-finish {
  vim_mode='I'
  zle reset-prompt
  zle -R
}
zle -N zle-line-finish

# default is ins mode
vimode='I'

# fix ctrl-c mode display
function TRAPINT() {
  vimode='I'
  return $(( 128 + $1 ))
}

##
# prompt itself
PROMPT_USER='%F{green}%n'
PROMPT_HOST='%F{green}%m'
[ "$USER" = 'root' ] && PROMPT_USER='%F{white}%n'
[ "$SSH_CONNECTION" != '' ] && PROMPT_HOST='%F{white}%m'
PROMPT='${PROMPT_USER}%F{blue}@${PROMPT_HOST}%F{blue}:%F{yellow}%~
%f%*%F{blue}${vimode}%F{magenta}${vcs_info_msg_0_}%# %f'


##
# Title
case "${TERM}" in
screen*|ansi*)
  preexec_term_title() {
    print -n "\ek$1\e\\"
  }
  preexec_functions+=preexec_term_title
  precmd_term_title() {
    print -n "\ek$(whoami)@$(hostname -s):$(basename "${PWD}")\e\\"
  }
  precmd_functions+=precmd_term_title
  ;;
xterm*)
  preexec_term_title() {
    print -n "\e]0;$1\a"
  }
  preexec_functions+=preexec_term_title
  precmd_term_title() {
    print -n "\e]0;$(basename "${PWD}")\a"
  }
  precmd_functions+=precmd_term_title
  ;;
esac
