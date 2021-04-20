# zsh/prompt-linedrawing.zsh

# Escape stray linedrawing characters so the terminal doesn't break.
# E.g. print '\e(0\e)B' would completely break prompt and typing without this.
# https://wiki.archlinux.org/index.php/Zsh#Resetting_the_terminal_with_escape_sequences
__dko_prompt::precmd::reset_broken_terminal() {
  printf '%b' '\e[0m\e(B\e)0\017\e[?5l\e7\e[0;0r\e8'
}
add-zsh-hook precmd __dko_prompt::precmd::reset_broken_terminal
