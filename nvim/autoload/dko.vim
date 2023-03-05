" autoload/dko.vim
"
" vimrc and debugging helper funtions
"

" ============================================================================
" Guards
" ============================================================================

if exists('g:loaded_dko') | finish | endif
let g:loaded_dko = 1

" ============================================================================
" General VimL utility functions
" ============================================================================

" Declare and define var as new dict if the variable has not been used before
"
" @param  {String} var
" @return {String} the declared var name
function! dko#InitDict(var) abort
  let {a:var} = exists(a:var) ? {a:var} : {}
  return {a:var}
endfunction

" ============================================================================
" Whitespace settings
" ============================================================================

function! dko#TwoSpace() abort
  setlocal expandtab shiftwidth=2 softtabstop=2
endfunction

function! dko#FourSpace() abort
  setlocal expandtab shiftwidth=4 softtabstop=4
endfunction

function! dko#TwoTabs() abort
  setlocal noexpandtab shiftwidth=2 softtabstop=2
endfunction

function! dko#FourTabs() abort
  setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
endfunction

function! dko#PrettierSpace() abort
  let l:rc_candidate = dko#project#GetPrettierrc()
  if empty(l:rc_candidate)
    return v:false
  endif

  let l:rc_file = dko#project#GetFile(l:rc_candidate)
  try
    let l:contents = json_decode(readfile(l:rc_file))
    if l:contents['tabWidth'] == 4
      call dko#FourSpace()
      return v:true
    elseif l:contents['tabWidth'] == 2
      call dko#TwoSpace()
      return v:true
    endif
  catch
  endtry

  return v:false
endfunction
