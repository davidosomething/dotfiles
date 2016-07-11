scriptencoding utf-8

" ============================================================================
" Utility
" ============================================================================

function! dkostatus#IsNonFile() abort
  return getbufvar(s:bufnr, '&buftype') =~# '\v(help|nofile|terminal)'
endfunction

" ============================================================================
" Status line
" ============================================================================

" Called by autocmd in vimrc, refresh statusline in each window
function! dkostatus#Refresh() abort
  for l:winnr in range(1, winnr('$'))
    let l:fn = '%!dkostatus#Output(' . l:winnr . ')'
    call setwinvar(l:winnr, '&statusline', l:fn)
  endfor
endfunction

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
  let l:contents .= dkostatus#Neomake()
  let l:contents .= dkostatus#Readonly()
  let l:contents .= dkostatus#Filetype()
  let l:contents .= dkostatus#Filename()
  let l:contents .= dkostatus#Anzu()

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%='
  let l:contents .= dkostatus#ShortPath()
  " too slow
  "let l:contents .= dkostatus#GitaBranch()
  let l:contents .= dkostatus#GutentagsStatus()
  let l:contents .= dkostatus#Ruler()

  return l:contents
endfunction

function! dkostatus#Mode() abort
  " blacklist
  if s:winnr != winnr()
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
        \ : '%#DiffText# ᴘ %*'
endfunction

" Custom formatter based on https://github.com/benekastah/neomake/blob/master/autoload/neomake/statusline.vim#L36
function! dkostatus#FormatNeomakeCounts(counts) abort
  let l:result = ''
  let l:e = get(a:counts, 'E', 0)
  let l:w = get(a:counts, 'W', 0)

  " assuming colorscheme has Syntastic colors defined
  if l:e
    let l:result .= '%#SyntasticErrorSign# ⚑' . l:e
  endif
  if l:w
    let l:result .= '%#SyntasticWarningSign# ⚑' . l:w
  endif
  return (l:e || l:w)
        \ ? l:result . ' %*'
        \ : ''
endfunction

function! dkostatus#Neomake() abort
  return s:winnr != winnr()
        \ || empty(glob(expand(g:plug_home . '/neomake')))
        \ ? ''
        \ : dkostatus#FormatNeomakeCounts(neomake#statusline#LoclistCounts())
endfunction

function! dkostatus#Readonly() abort
  return getbufvar(s:bufnr, '&readonly') ? '%#Error# ʀ %*' : ''
endfunction

function! dkostatus#Filetype() abort
  let l:ft = getbufvar(s:bufnr, '&filetype')
  return empty(l:ft)
        \ ? ''
        \ : '%#StatusLineNC# ' . l:ft . ' %*'
endfunction

function! dkostatus#Filename() abort
  let l:contents = ' '
  let l:contents .= winwidth(0) > 40 ? '%<%f' : '%t'
  let l:contents .= (isdirectory(expand('%p')) ? '/ ' : '')
  let l:contents .= getbufvar(s:bufnr, '&modified') ? '%#PmenuThumb#+' : ''
  let l:contents .= '%* '
  return l:contents
endfunction

function! dkostatus#Anzu() abort
  if s:winnr != winnr() || !exists('g:plugs["vim-anzu"]')
    return ''
  endif
  let l:anzu = anzu#search_status()
  return empty(l:anzu)
        \ ? ''
        \ : '%#Visual# ' . l:anzu .' %*'
endfunction

function! dkostatus#ShortPath() abort
  " blacklist
  if winwidth(0) < 80 || dkostatus#IsNonFile()
    return ''
  endif
  return '%#Folded# %<%{pathshorten(getcwd())} %*'
endfunction

function! dkostatus#GitaBranch() abort
  if winwidth(0) < 80
        \ || s:winnr != winnr()
        \ || !exists('g:gita#debug')
    return ''
  endif
  let l:branch = gita#statusline#format('%lb')
  return empty(l:branch)
        \ ? '' 
        \ : '%#DiffAdd# ' . l:branch . ' %*'
endfunction

function! dkostatus#GutentagsStatus() abort
  if winwidth(0) < 80
        \ || s:winnr != winnr()
        \ || !exists('g:loaded_gutentags')
    return ''
  endif
  return '%#SignColumn#%{gutentags#statusline(" ᴛᴀɢ ")}%*'
endfunction

function! dkostatus#Ruler() abort
  if s:winnr != winnr() || dkostatus#IsNonFile()
    return ''
  endif
  return '%#StatusLineNC# %5.(%c%) %*'
endfunction

