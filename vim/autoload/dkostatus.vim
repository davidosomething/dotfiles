scriptencoding utf-8

" ============================================================================
" Utility
" ============================================================================

" @return {String}
function! dkostatus#IsNonFile() abort
  return getbufvar(s:bufnr, '&buftype') =~# '\v(nofile|quickfix|terminal)'
endfunction

" @return {String}
function! dkostatus#IsHelp() abort
  return getbufvar(s:bufnr, '&buftype') =~# '\v(help)'
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
  let s:ww    = winwidth(a:winnr)
  let l:contents = ''

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= '%#TabLine# ' . dkostatus#Mode()

  " Filebased
  "let l:contents .= '%h%q%w'     " [help][Quickfix/Location List][Preview]
  let l:contents .= '%#StatusLine#' . dkostatus#Filetype()
  let l:contents .= '%#PmenuSel#' . dkostatus#Filename()
  let l:contents .= '%#Todo#' . dkostatus#Dirty()
  let l:contents .= '%#StatusLine#' . dkostatus#GitBranch()

  " Toggleable
  let l:contents .= '%#DiffText#' . dkostatus#Paste()
  let l:contents .= '%#Error#' . dkostatus#Readonly()

  " Temporary
  let l:contents .= '%#NeomakeErrorSign#'
        \. dkostatus#Neomake('E', dkostatus#NeomakeCounts())
  let l:contents .= '%#NeomakeWarningSign#'
        \. dkostatus#Neomake('W', dkostatus#NeomakeCounts())

  " Search context
  let l:contents .= '%#Search#' . dkostatus#Anzu()

  " ==========================================================================
  " Right side
  " ==========================================================================

  " Instance context
  let l:contents .= '%*%='
  let l:contents .= '%#TermCursor#' . dkostatus#GutentagsStatus()
  let l:contents .= '%#TermCursor#' . dkostatus#NeomakeJobs()
  let l:contents .= '%<'
  let l:contents .= '%#PmenuSel#' . dkostatus#ShortPath(getcwd(), s:ww)
  let l:contents .= '%#TabLine#' . dkostatus#Ruler()

  return l:contents
endfunction

" @return {String}
function! dkostatus#Mode() abort
  " blacklist
  let l:modecolor = '%#TabLine#'
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
  return  l:modecolor . ' ' . l:modeflag . ' '
endfunction

" @return {String}
function! dkostatus#Paste() abort
  return s:winnr != winnr() || empty(&paste)
        \ ? ''
        \ : ' ᴘ '
endfunction

" @return {String}
function! dkostatus#Neomake(key, counts) abort
  let l:e = get(a:counts, a:key, 0)
  return l:e ? ' ⚑' . l:e . ' ' : ''
endfunction

" @return {String}
function! dkostatus#NeomakeCounts() abort
  return s:winnr != winnr()
        \ || !exists('*neomake#statusline#LoclistCounts')
        \ ? {}
        \ : neomake#statusline#LoclistCounts()
endfunction

" @return {String}
function! dkostatus#NeomakeJobs() abort
  return s:winnr != winnr()
        \ || !dko#IsLoaded('neomake')
        \ || !exists('*neomake#GetJobs')
        \ || empty(neomake#GetJobs())
        \ ? ''
        \ : ' ᴍᴀᴋᴇ '
endfunction

" @return {String}
function! dkostatus#Readonly() abort
  return getbufvar(s:bufnr, '&readonly') ? ' ʀ ' : ''
endfunction

" @return {String}
function! dkostatus#Filetype() abort
  let l:ft = getbufvar(s:bufnr, '&filetype')
  return empty(l:ft)
        \ ? ''
        \ : ' ' . l:ft . ' '
endfunction

" @return {String}
function! dkostatus#Filename() abort
  if dkostatus#IsNonFile()
    return ''
  endif

  let l:contents = ' %.64f'
  let l:contents .= isdirectory(expand('%:p')) ? '/ ' : ' '
  return l:contents
endfunction

" @return {String}
function! dkostatus#Dirty() abort
  return getbufvar(s:bufnr, '&modified') ? ' + ' : ''
endfunction

" @return {String}
function! dkostatus#Anzu() abort
  if s:winnr != winnr() || !exists('*anzu#search_status')
    return ''
  endif

  let l:anzu = anzu#search_status()
  return empty(l:anzu)
        \ ? ''
        \ : ' ' . l:anzu . ' '
endfunction

" Use dko#ShortenPath conditionally
"
" @param {String} path
" @param {Int} max
" @return {String}
function! dkostatus#ShortPath(path, max) abort
  if s:ww < a:max
        \ || dkostatus#IsNonFile()
        \ || dkostatus#IsHelp()
    return ''
  endif
  return dko#ShortenPath(a:path, a:max)
endfunction

" Uses fugitive or gita to get cached branch name
"
" @return {String}
function! dkostatus#GitBranch() abort
  return s:ww < 80 || s:winnr != winnr()
        \ || dkostatus#IsNonFile()
        \ || dkostatus#IsHelp()
        \ ? ''
        \ : exists('*fugitive#head')
        \   ? ' ' . fugitive#head(7) . ' '
        \   : exists('g:gita#debug')
        \     ? gita#statusline#format('%lb')
        \     : ''
endfunction

" @return {String}
function! dkostatus#GutentagsStatus() abort
  return s:winnr != winnr() || !exists('g:loaded_gutentags')
        \ ? ''
        \ : '%{gutentags#statusline(" ᴛᴀɢ ")}'
endfunction

" @return {String}
function! dkostatus#Ruler() abort
  return ' %5.(%c%) '
endfunction

