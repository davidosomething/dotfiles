function! dkovim#rtp() abort
  put! =split(&runtimepath, ',', 0)
endfunction
