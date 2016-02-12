scriptencoding utf-8

" ============================================================================
" Tab line
" ============================================================================

" Called by autocmd in vimrc on cursormoved and other win events
function! dkotabline#Toggle() abort
  execute 'set showtabline=' . (&showtabline ? 0 : 2)
endfunction

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
  if exists('g:loaded_cfi')
    let l:function = cfi#format('%s', '')
    if !empty(l:function)
      return l:function
    endif
  endif

  return ''
endfunction
