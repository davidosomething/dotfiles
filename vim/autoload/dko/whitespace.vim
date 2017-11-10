function! dko#whitespace#clean() abort
  " Replace tabs with spaces
  %retab
  let l:save = winsaveview()
  " Turn DOS returns ^M into real returns
  " vint: -ProhibitCommandRelyOnUser -ProhibitCommandWithUnintendedSideEffect
  %s/\r/\r/eg
  %s/\s\+$//e
  call winrestview(l:save)
endfunction
