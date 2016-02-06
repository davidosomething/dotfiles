function! dko#rtp() abort
  put! =split(&runtimepath, ',', 0)
endfunction

function! dko#init_object(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
endfunction

function! dko#pasteflag() abort
  if &paste
    return 'p'
  endif
  return ''
endfunction

function! dko#statusline() abort
  let l:contents = ' '

  " mode
  let l:contents .= '[%{mode()}%{dko#pasteflag()}] '

  " --------------------------------------------------------------------------
  " File info
  " --------------------------------------------------------------------------

  if exists("g:plugs['vim-fugitive']")
    let l:contents .= '[%{fugitive#head()}] '
  endif

  " [help][Quickfix/Location List][Preview][&ft]
  let l:contents .= '%h%q%w%y '

  " truncated filename
  let l:contents .= '%<%f '

  " --------------------------------------------------------------------------
  " Right side
  " --------------------------------------------------------------------------

  let l:contents .= '%='

  if exists("g:plugs['vim-anzu']")
    let l:contents .= '%{anzu#search_status()}'
  endif

  " Syntastic
  if exists("g:plugs['syntastic']")
    let l:contents .= '%#warningmsg#%{SyntasticStatuslineFlag()}%*'
  endif

  " ruler (10 char long, so can accommodate 9999x99999)
  let l:contents .= '%10.(%l:%c%) '

  return l:contents
endfunction
