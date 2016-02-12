scriptencoding utf-8

" ============================================================================
" Tab line
" ============================================================================

" Called by autocmd in vimrc on cursormoved and other win events
function! dkotabline#Refresh() abort
  call setwinvar(winnr(), '&tabline', '%!dkotabline#Output()')
endfunction

" Called by autocmd in vimrc
function! dkotabline#Output() abort
  let l:contents = '%#StatusLine# '

  let l:contents .= dkotabline#FunctionSignature()

  let l:contents .= '%#StatusLine# %T'
  return l:contents
endfunction

" Show function signature using various plugins
function! dkotabline#FunctionSignature() abort
  if !exists('g:plugs["current-func-info.vim"]')
    return ''
  endif

  let l:function = cfi#format('%s', '')
  return !empty(l:function)
        \ ? l:function
        \ : ''
endfunction
