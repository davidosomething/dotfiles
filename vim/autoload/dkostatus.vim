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

  " signs column size
  let l:contents = '%#VertSplit# '

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= dkostatus#Mode()

  " Filebased
  "let l:contents .= '%h%q%w'     " [help][Quickfix/Location List][Preview]
  let l:contents .= '%#PmenuSel#' . dkostatus#Filetype()
  let l:contents .= dkostatus#Filename()
  let l:contents .= '%#Todo#' . dkostatus#Dirty()

  " Toggleable
  let l:contents .= '%#DiffText#' . dkostatus#Paste()
  let l:contents .= '%#Error#' . dkostatus#Readonly()

  " Temporary
  let l:contents .= '%#TermCursor#' . dkostatus#GutentagsStatus()
  let l:contents .= '%#TermCursor#' . dkostatus#NeomakeJobs()
  let l:contents .= '%#NeomakeWarningSign#' . dkostatus#NeomakeWarnings(dkostatus#NeomakeCounts())
  let l:contents .= '%#NeomakeErrorSign#' . dkostatus#NeomakeErrors(dkostatus#NeomakeCounts())


  " Search context
  let l:contents .= '%* '
  let l:contents .= '%#Visual#' . dkostatus#Anzu()

  " ==========================================================================
  " Right side
  " ==========================================================================

  " Instance context
  let l:contents .= '%='
  let l:contents .= '%* ' . dkostatus#ShortPath()
  let l:contents .= '%* '

  " too slow
  "let l:contents .= dkostatus#GitaBranch()
  "
  let l:contents .= '%#PmenuSel# ' . dkostatus#Ruler() . ' '

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
        \ : ' ᴘ '
endfunction

function! dkostatus#NeomakeErrors(counts) abort
  let l:e = get(a:counts, 'E', 0)
  return l:e ? ' ⚑' . l:e . ' ' : ''
endfunction

function! dkostatus#NeomakeWarnings(counts) abort
  let l:w = get(a:counts, 'W', 0)
  return l:w ? ' ⚑' . l:w . ' ' : ''
endfunction

function! dkostatus#NeomakeCounts() abort
  return s:winnr != winnr()
        \ || !dko#IsPlugged('neomake')
        \ || !exists('*neomake#statusline#LoclistCounts')
        \ ? {}
        \ : neomake#statusline#LoclistCounts()
endfunction

function! dkostatus#NeomakeJobs() abort
  return s:winnr != winnr()
        \ || !dko#IsPlugged('neomake')
        \ || !exists('*neomake#GetJobs')
        \ || empty(neomake#GetJobs())
        \ ? ''
        \ : ' ᴍᴀᴋᴇ '
endfunction

function! dkostatus#Readonly() abort
  return getbufvar(s:bufnr, '&readonly') ? ' ʀ ' : ''
endfunction

function! dkostatus#Filetype() abort
  let l:ft = getbufvar(s:bufnr, '&filetype')
  return empty(l:ft)
        \ ? ''
        \ : '%#StatusLineNC# ' . l:ft . ' %*'
endfunction

function! dkostatus#Filename() abort
  let l:contents = winwidth(0) > 40 ? ' %<%f' : ' %t'
  let l:contents .= isdirectory(expand('%:p')) ? '/ ' : ' '
  return l:contents
endfunction

function! dkostatus#Dirty() abort
  return getbufvar(s:bufnr, '&modified') ? ' + ' : ''
endfunction

function! dkostatus#Anzu() abort
  if s:winnr != winnr()
        \ || !dko#IsPlugged('vim-anzu')
        \ || !exists('*anzu#search_status')
    return ''
  endif

  let l:anzu = anzu#search_status()
  return empty(l:anzu)
        \ ? ''
        \ : ' ' . l:anzu . ' '
endfunction

function! dkostatus#ShortPath() abort
  if winwidth(0) < 80 || dkostatus#IsNonFile()
    return ''
  endif

  let l:short = pathshorten(getcwd())
  if len(l:short) > winwidth(0)
    return ''
  endif

  let l:full = fnamemodify(getcwd(), ':~:.')
  return len(l:full) > winwidth(0) - len(expand('%:~:.')) ? l:short : l:full
endfunction

function! dkostatus#GitaBranch() abort
  if winwidth(0) < 80
        \ || s:winnr != winnr()
        \ || !dko#IsPlugged('vim-gita')
        \ || !exists('g:gita#debug')
    return ''
  endif

  let l:branch = gita#statusline#format('%lb')
  return empty(l:branch)
        \ ? '' 
        \ : '%#DiffAdd# ' . l:branch . ' %*'
endfunction

function! dkostatus#GutentagsStatus() abort
  if s:winnr != winnr()
        \ || !dko#IsPlugged('vim-gutentags')
        \ || !exists('g:loaded_gutentags')
    return ''
  endif
  return '%{gutentags#statusline(" ᴛᴀɢ ")}'
endfunction

function! dkostatus#Ruler() abort
  if s:winnr != winnr() || dkostatus#IsNonFile()
    return ''
  endif
  return '%5.(%c%)'
endfunction

