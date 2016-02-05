function! dko#rtp() abort
  put! =split(&runtimepath, ',', 0)
endfunction

function! dko#init_object(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
endfunction

function! dko#statusline() abort
  let l:contents = ' '

  " mode
  let l:contents .= '[%{mode()}] '

  " [help][Quickfix/Location List][Preview][&ft]
  let l:contents .= '%h%q%w%y '

  " truncated filename
  let l:contents .= '%<%f '

  " RIGHT ALIGN
  let l:contents .= '%='

  " Syntastic
  if exists("g:plugs['syntastic']")
    let l:contents .= '%#warningmsg#%{SyntasticStatuslineFlag()}%*'
  endif

  " ruler (10 char long, so can accommodate 9999x99999)
  let l:contents .= '%10.(%l:%c%) '

  return l:contents
endfunction
