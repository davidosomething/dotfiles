scriptencoding utf-8

" ============================================================================
" Status line
" ============================================================================

" a:winnr from dkostatus#Refresh() or 0 on set statusline
function! dkostatus#Output(winnr) abort
  let s:winnr = a:winnr
  let s:bufnr = winbufnr(a:winnr)

  let l:contents = ''

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= dkostatus#Mode()
  let l:contents .= dkostatus#Paste()
  "let l:contents .= '%h%q%w'     " [help][Quickfix/Location List][Preview]
  let l:contents .= dkostatus#Syntastic()
  let l:contents .= dkostatus#Readonly()
  let l:contents .= dkostatus#Filetype()
  let l:contents .= dkostatus#Filename()
  let l:contents .= dkostatus#Anzu()

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%='
  let l:contents .= dkostatus#ShortPath()
  let l:contents .= dkostatus#GitaBranch()
  let l:contents .= dkostatus#Ruler()

  return l:contents
endfunction

" Called by autocmd in vimrc
function! dkostatus#Refresh() abort
  for l:winnr in range(1, winnr('$'))
    call setwinvar(l:winnr, '&statusline', '%!dkostatus#Output(' . l:winnr . ')')
  endfor
endfunction

function! dkostatus#Mode() abort
  " blacklist
  if getbufvar(s:bufnr, '&ft') =~# 'gita-'
    return ''
  endif

  let l:modecolor = '%#DiffAdd#'
  let l:modeflag = mode()
  if l:modeflag ==# 'i'
    let l:modecolor = '%#PmenuSel#'
  elseif l:modeflag ==# 'R'
    let l:modecolor = '%#DiffDelete#'
  elseif l:modeflag =~? 'v'
    let l:modecolor = '%#Cursor#'
  elseif l:modeflag ==? "\<C-v>"
    let l:modecolor = '%#Cursor#'
    let l:modeflag = 'B'
  endif
  return  l:modecolor . ' ' . l:modeflag . ' %*'
endfunction

function! dkostatus#Paste() abort
  return s:winnr != winnr()
        \ || empty(&paste)
        \ ? ''
        \ : '%#DiffText# p %*'
endfunction

function! dkostatus#Syntastic() abort
  return s:winnr != winnr()
        \ || !exists('*SyntasticStatuslineFlag')
        \ || empty(SyntasticStatuslineFlag())
        \ ? ''
        \ : '%#SyntasticErrorSign# %{SyntasticStatuslineFlag()} %*'
endfunction

function! dkostatus#Readonly() abort
  return getbufvar(s:bufnr, '&readonly') ? '%#Error# ᴙ %*' : ''
endfunction

function! dkostatus#Filetype() abort
  let l:ft = getbufvar(s:bufnr, '&filetype')
  return empty(l:ft)
        \ ? ''
        \ : '%#StatusLineNC# ' . l:ft . ' %*'
endfunction

function! dkostatus#Filename() abort
  let l:contents = ' '
  let l:contents .= '%<%f' . (isdirectory(expand('%p')) ? '/ ' : '')
  let l:contents .= getbufvar(s:bufnr, '&modified') ? '%#PmenuThumb#+' : ''
  let l:contents .= '%* '
  return l:contents
endfunction

function! dkostatus#Anzu() abort
  if s:winnr != winnr() || !exists('*anzu#search_status')
    return ''
  endif
  let l:anzu = anzu#search_status()
  return empty(l:anzu)
        \ ? ''
        \ : '%#Visual# %{anzu#search_status()} %*'
endfunction

function! dkostatus#ShortPath() abort
  " blacklist
  if getbufvar(s:bufnr, '&ft') =~# 'gita-'
    return ''
  endif
  return '%#Folded# %<%{pathshorten(getcwd())} %*'
endfunction

function! dkostatus#GitaBranch() abort
function! dkostatus#Syntastic() abort
  return s:winnr != winnr()
        \ || !exists('*SyntasticStatuslineFlag')
        \ || empty(SyntasticStatuslineFlag())
        \ ? ''
        \ : '%#SyntasticErrorSign# %{SyntasticStatuslineFlag()} %*'
endfunction

  if s:winnr != winnr() || !exists('*gita#statusline#format')
    return ''
  endif
  return '%#DiffAdd# ' . gita#statusline#format('%lb') . '%*'
endfunction

function! dkostatus#Ruler() abort
  if s:winnr != winnr() || getbufvar(s:bufnr, '&ft') =~# 'gita-'
    return ''
  endif
  return '%#VertSplit# %5.(%c%) %*'
endfunction

