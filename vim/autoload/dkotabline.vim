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
  let l:contents = '%#StatusLine#'

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= dkotabline#FunctionSignature()
  let l:contents .= '%#StatusLine#%T'

  " ==========================================================================
  " Right side
  " ==========================================================================

  "let l:contents .= '%='

  return l:contents
endfunction

" Show function signature using various plugins
function! dkotabline#FunctionSignature() abort
  let l:source = ''
  let l:function = ''

  if exists('g:loaded_cfi')
    let l:function = cfi#format('%s', '')
    if !empty(l:function)
      let l:source = 'cfi'
    endif
  endif

  if empty(l:function) && exists('g:plugs["vim-gazetteer"]')
    try
      let l:function = gazetteer#WhereAmI()
    endtry
    if !empty(l:function)
      let l:source = 'gzt'
    endif
  endif

  return empty(l:source)
        \ ? ''
        \ : '%#StatusLineNC# ' . l:source . ' %#StatusLine# ' . l:function . ' '
endfunction
