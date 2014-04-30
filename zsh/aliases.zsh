# sourced by zshrc

# some of these paths are set in .zshenv.local!
alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias mkdir="nocorrect mkdir"

# editing zsh config files
alias ezaliases="e $ZDOTDIR/aliases.zsh"
alias ezshrc="e $ZDOTDIR/zshrc.zsh"
alias ezshenv="e $ZDOTDIR/zshenv.zsh"
alias elzshrc="e $ZDOTDIR/.zshrc.local"
alias elzshenv="e $ZDOTDIR/.zshenv.local"

alias fixzcompletion="rm -f ~/.zcompdump; compinit"
