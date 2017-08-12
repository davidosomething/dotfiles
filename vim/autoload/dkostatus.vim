scriptencoding utf-8

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
  if empty(a:winnr) | return | endif
  let l:bufnr = winbufnr(a:winnr)
  let l:ww    = winwidth(a:winnr)
  let l:cwd   = has('nvim') ? getcwd(a:winnr) : getcwd()
  let l:contents = ''

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= '%#TabLine# ' . dkostatus#Mode(a:winnr)

  " Filebased
  "let l:contents .= '%h%q%w'     " [help][Quickfix/Location List][Preview]
  let l:contents .= '%#StatusLine#' . dkostatus#Filetype(l:bufnr)
  let l:contents .= '%#PmenuSel#' . dkostatus#Filename(l:bufnr)
  let l:contents .= '%#Todo#' . dkostatus#Dirty(l:bufnr)
  let l:contents .= '%#StatusLine#' . dkostatus#GitBranch(a:winnr, l:ww, l:bufnr)

  " Toggleable
  let l:contents .= '%#DiffText#' . dkostatus#Paste(a:winnr)
  let l:contents .= '%#Error#' . dkostatus#Readonly(l:bufnr)

  " Temporary
  let l:contents .= '%#NeomakeErrorSign#'
        \. dkostatus#Neomake('E', dkostatus#NeomakeCounts(a:winnr))
  let l:contents .= '%#NeomakeWarningSign#'
        \. dkostatus#Neomake('W', dkostatus#NeomakeCounts(a:winnr))

  " Search context
  let l:contents .= '%#Search#' . dkostatus#Anzu(a:winnr)

  " ==========================================================================
  " Right side
  " ==========================================================================

  " Instance context
  let l:contents .= '%*%='
  let l:contents .= '%#TermCursor#' . dkostatus#GutentagsStatus(a:winnr)
  let l:contents .= '%#TermCursor#' . dkostatus#NeomakeJobs(a:winnr)
  let l:contents .= '%<'
  let l:contents .= '%#PmenuSel#' . dkostatus#ShortPath(l:bufnr, l:cwd, l:ww)
  let l:contents .= '%#TabLine#' . dkostatus#Ruler()

  return l:contents
endfunction

" @return {String}
function! dkostatus#Mode(winnr) abort
  " blacklist
  let l:modecolor = '%#TabLine#'

  let l:modeflag = mode()
  if a:winnr != winnr()
    let l:modeflag = ' '
  elseif l:modeflag ==# 'i'
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
function! dkostatus#Paste(winnr) abort
  return a:winnr != winnr() || empty(&paste)
        \ ? ''
        \ : ' ᴘ '
endfunction

" @return {String}
function! dkostatus#Neomake(key, counts) abort
  let l:e = get(a:counts, a:key, 0)
  return l:e ? ' ⚑' . l:e . ' ' : ''
endfunction

" @return {String}
function! dkostatus#NeomakeCounts(winnr) abort
  return a:winnr != winnr()
        \ || !exists('*neomake#statusline#LoclistCounts')
        \ ? {}
        \ : neomake#statusline#LoclistCounts()
endfunction

" @return {String}
function! dkostatus#NeomakeJobs(winnr) abort
  return a:winnr != winnr()
        \ || !dko#IsLoaded('neomake')
        \ || !exists('*neomake#GetJobs')
        \ || empty(neomake#GetJobs())
        \ ? ''
        \ : ' ᴍᴀᴋᴇ '
endfunction

" @return {String}
function! dkostatus#Readonly(bufnr) abort
  return getbufvar(a:bufnr, '&readonly') ? ' ʀ ' : ''
endfunction

" @return {String}
function! dkostatus#Filetype(bufnr) abort
  let l:ft = getbufvar(a:bufnr, '&filetype')
  return empty(l:ft)
        \ ? ''
        \ : ' ' . l:ft . ' '
endfunction

" @return {String}
function! dkostatus#Filename(bufnr) abort
  if dko#IsNonFile(a:bufnr)
    return ''
  endif

  let l:contents = ' %.64f'
  let l:contents .= isdirectory(expand('%:p')) ? '/ ' : ' '
  return l:contents
endfunction

" @return {String}
function! dkostatus#Dirty(bufnr) abort
  return getbufvar(a:bufnr, '&modified') ? ' + ' : ''
endfunction

" @return {String}
function! dkostatus#Anzu(winnr) abort
  if a:winnr != winnr() || !exists('*anzu#search_status')
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
function! dkostatus#ShortPath(bufnr, path, max) abort
  if dko#IsNonFile(a:bufnr) || dko#IsHelp(a:bufnr)
    return ''
  endif
  return dko#ShortenPath(a:path, a:max)
endfunction

" Uses fugitive or gita to get cached branch name
"
" @return {String}
function! dkostatus#GitBranch(winnr, ww, bufnr) abort
  return a:ww < 80 || a:winnr != winnr()
        \ || dko#IsNonFile(a:bufnr)
        \ || dko#IsHelp(a:bufnr)
        \ ? ''
        \ : exists('*fugitive#head')
        \   ? ' ' . fugitive#head(7) . ' '
        \   : exists('g:gita#debug')
        \     ? gita#statusline#format('%lb')
        \     : ''
endfunction

" @return {String}
function! dkostatus#GutentagsStatus(winnr) abort
  return a:winnr != winnr() || !exists('g:loaded_gutentags')
        \ ? ''
        \ : '%{gutentags#statusline(" ᴛᴀɢ ")}'
endfunction

" @return {String}
function! dkostatus#Ruler() abort
  return ' %5.(%c%) '
endfunction
