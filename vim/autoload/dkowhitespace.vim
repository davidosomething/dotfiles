function! dkowhitespace#clean() abort
  %retab      " Replace tabs with spaces
  %s/\r/\r/eg " Turn DOS returns ^M into real returns
  %s= *$==e   " Delete end of line blanks
endfunction
