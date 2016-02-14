scriptencoding utf-8

" ============================================================================
" Options
" ============================================================================

let g:dkotabline_show_function_signature_source = 0

" ============================================================================
" Tab line
" ============================================================================

" bound to <F10>
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

  let l:contents .= dkotabline#ArgumentHints()
  let l:contents .= dkotabline#FunctionSignature()

  " end of tab is showing a tab info
  "let l:contents .= '%#StatusLine#%T'

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%='

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

  " disabled, too many false positives
  if 0 && empty(l:function) && exists('g:plugs["vim-gazetteer"]')
    try
      let l:function = gazetteer#WhereAmI()
    endtry
    if !empty(l:function)
      let l:source = 'gzt'
    endif
  endif

  return empty(l:source)
        \ ? ''
        \ : (g:dkotabline_show_function_signature_source
        \     ? '%#StatusLineNC# ' . l:source . ' '
        \     : '')
        \ . '%#StatusLine# ' . l:function . ' '
endfunction

" Copied function from tern_for_vim and redirect output to variable.
" @see {@link https://github.com/ternjs/tern_for_vim/blob/a26106b42f41edcd8bcd40d750f30339ec37f41c/autoload/tern.vim#L60}
function! dkotabline#ArgumentHints() abort
  " Show argument hints
  if !exists('*tern#LookupArgumentHints')
        \|| getbufvar('', '&ft') !=# 'javascript'
    return ''
  endif

  let l:hints = ''

  let l:pos = match(
        \  getline('.')[:col('.')-2],
        \  '[a-zA-Z0-9_]*([^()]*$'
        \)

  " no arguments () found
  if l:pos < 0
    return ''
  endif

  let l:fname = get(
        \   matchlist(
        \     getline('.')[:col('.')-2],
        \     '\([a-zA-Z0-9_]*\)([^()]*$'
        \   ),
        \   1
        \)

  if has('python')
    redir => l:hints
      python tern_lookupArgumentHints(vim.eval('fname'), int(vim.eval('l:pos')))
    redir END
  elseif has('python3')
    redir => l:hints
      python3 tern_lookupArgumentHints(vim.eval('fname'), int(vim.eval('l:pos')))
    redir END
  endif

  let l:hints = substitute(l:hints, '\%x00', '', 'g')

  return empty(l:hints)
        \ ? ''
        \ : '%#CursorLineNr# ' . l:hints . ' %#StatusLine# '
endfunction
