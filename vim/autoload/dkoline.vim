" autoload/dkoline.vim
scriptencoding utf-8

" let g:dkoline#refresh = 0
" let g:dkoline#trefresh = 0
" let g:dkoline#srefresh = 0

function! dkoline#GetTabline() abort
  "let g:dkoline#trefresh += 1
  let l:tabnr = tabpagenr()
  let l:winnr = tabpagewinnr(l:tabnr)
  let l:view = dkoline#GetView(l:winnr)

  let l:contents = '%#StatusLine#'

  " ==========================================================================
  " Left side
  " ==========================================================================

  " Search context
  let l:lastpat = @/
  let l:contents .= dkoline#Format(
        \ empty(l:lastpat) ? '' : ' ' . l:lastpat . ' ',
        \ '%#dkoStatusKey# ? %(%#Search#',
        \ '%)')

  " ==========================================================================
  " Right side
  " ==========================================================================

  " Leave 24 chars for search
  let l:maxwidth = float2nr(&columns) - 24
  let l:maxwidth = l:maxwidth > 0 ? l:maxwidth : 0
  let l:contents .= '%#StatusLine# %= '

  let l:contents .= dkoline#Format(
        \ ' ' . get(l:view, 'cwd', '~') . ' ',
        \ '%#dkoStatusKey# ʟᴄᴅ %(%#dkoStatusValue#%<',
        \ '%)')

  let l:contents .= dkoline#Format(
        \ dkoline#GitBranch(l:view.bufnr),
        \ '%#dkoStatusKey# ∆ %(%#dkoStatusValue#',
        \ '%)')

  " ==========================================================================

  return l:contents
endfunction

" a:winnr from dkoline#Refresh() or 0 on set statusline
function! dkoline#GetStatusline(winnr) abort
  if empty(a:winnr) | return | endif
  " let g:dkoline#srefresh += 1

  let l:winnr = a:winnr > winnr('$') ? 1 : a:winnr
  let l:view = dkoline#GetView(l:winnr)

  let l:contents = ''

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= '%#StatusLineNC# %3(' . dkoline#Mode(l:winnr) . '%)'

  " Filebased
  let l:contents .= dkoline#Format(
        \   dkoline#Filetype(l:view.ft),
        \   (dkoline#If({ 'winnr': l:winnr }, l:view)
        \     ? '%#dkoStatusValue#' : '%#StatusLineNC#' )
        \ )

  let l:maxwidth = l:view.ww - 4 - len(l:view.ft) - 16
  let l:maxwidth = l:maxwidth > 0 ? l:maxwidth : 48
  let l:contents .= dkoline#Format(
        \   dkoline#TailDirFilename(l:view),
        \   '%0.' . l:maxwidth . '('
        \     . (dkoline#If({ 'winnr': l:winnr }, l:view)
        \       ? '%#StatusLine#'
        \       : '%#StatusLineNC#'),
        \   '%)'
        \ )
  let l:contents .= dkoline#Format(dkoline#Dirty(l:view.bufnr), '%#DiffAdded#')

  " Toggleable
  if !has('nvim')
    let l:contents .= dkoline#Format(dkoline#Paste(), '%#DiffText#')
  endif

  let l:contents .= dkoline#Format(
        \ dkoline#Readonly(l:view.bufnr),
        \ '%#dkoLineImportant#'
        \)

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%*%='

  " Linting
  if dkoplug#IsLoaded('neomake')
    let l:contents .= dkoline#Format(
          \ dkoline#NeomakeStatus(l:view),
          \ '%#DiffText#'
          \)
    if exists('*neomake#GetJobs')
      let l:contents .= dkoline#Neomake(l:winnr, l:view.bufnr)
    endif
  endif

  let l:contents .= dkoline#Format(dkoline#Ruler(), '%#dkoStatusItem#')

  return l:contents
endfunction

" ============================================================================
" Output functions
" ============================================================================

" Display an atom if not empty with prefix/suffix
"
" @param {String} content
" @param {String} [before]
" @param {String} [after]
" @return {String}
function! dkoline#Format(...) abort
  let l:content = get(a:, 1, '')
  let l:before = get(a:, 2, '')
  let l:after = get(a:, 3, '')
  return empty(l:content) ? '' : l:before . l:content . l:after
endfunction

" Assert all conditions pass
function! dkoline#If(conditions, values) abort
  if has_key(a:conditions, 'winnr')
    if winnr() != a:conditions.winnr | return 0 | endif
  endif

  if has_key(a:conditions, 'ww')
    if a:values.ww < a:conditions.ww | return 0 | endif
  endif

  if has_key(a:conditions, 'normal')
    if !getbufvar(a:values.bufnr, '&buflisted') | return 0 | endif
  endif

  return 1
endfunction

" @return {String}
function! dkoline#Mode(winnr) abort
  " blacklist
  let l:modecolor = '%#StatusLineNC#'

  let l:modeflag = mode()
  if a:winnr != winnr()
    let l:modeflag = ' '
  elseif l:modeflag ==# 'c'
    let l:modecolor = '%#DiffDelete#'
  elseif l:modeflag ==# 'i'
    let l:modecolor = '%#dkoStatusItem#'
  elseif l:modeflag ==# 'R'
    let l:modecolor = '%#dkoLineModeReplace#'
  elseif l:modeflag =~? 'v'
    let l:modecolor = '%#Cursor#'
  elseif l:modeflag ==? "\<C-v>"
    let l:modecolor = '%#Cursor#'
    let l:modeflag = 'B'
  endif
  return  l:modecolor . ' ' . l:modeflag . ' '
endfunction

" @return {String}
function! dkoline#Paste() abort
  return empty(&paste)
        \ ? ''
        \ : ' ᴘ '
endfunction


" @param {Int} bufnr
" @return {String}
function! dkoline#Readonly(bufnr) abort
  return getbufvar(a:bufnr, '&readonly') ? ' ʀ ' : ''
endfunction

" @param {Int} bufnr
" @return {String}
function! dkoline#Filetype(ft) abort
  return empty(a:ft)
        \ ? ''
        \ : ' ' . a:ft . ' '
endfunction

" Show buffer's filename and immediate parent directory
"
" @param {Dict} view
" @return {String}
function! dkoline#TailDirFilename(view) abort
  if dko#IsNonFile(a:view.bufnr)
    return ''
  endif

  if empty(a:view.bufname)
    return ' [No Name] '
  endif

  if dko#IsHelp(a:view.bufnr)
    return ' ' . a:view.bufname . ' '
  endif

  let l:parent = fnamemodify(a:view.bufname, ':p:h:t')
  let l:filename = fnamemodify(a:view.bufname, ':t')
  return ' ' . l:parent . '/' . l:filename . ' '
endfunction

" @param {Int} bufnr
" @return {String}
function! dkoline#Dirty(bufnr) abort
  return getbufvar(a:bufnr, '&modified') ? ' + ' : ''
endfunction

" @param {Int} bufnr
" @return {String}
function! dkoline#GitBranch(bufnr) abort
  return dko#IsNonFile(a:bufnr) || empty(get(b:, 'dko_branch'))
        \ ? ''
        \ : ' ' . b:dko_branch . ' '
endfunction

" Whether or not neomake is disabled
" @param {Dict} view
" @return {String}
function! dkoline#NeomakeStatus(view) abort
  return dko#IsNonFile(a:view.bufnr)
        \ || !empty(neomake#GetEnabledMakers(a:view.ft))
        \ ? ''
        \ : ' ɴᴏ ᴍᴀᴋᴇʀs '
endfunction

" @return {string} job1,job2,job3
function! dkoline#NeomakeJobs(bufnr) abort
  if !a:bufnr | return '' | endif
  let l:running_jobs = filter(copy(neomake#GetJobs()),
        \ 'v:val.bufnr == ' . a:bufnr . ' && !get(v:val, "canceled", 0)')
  if empty(l:running_jobs) | return | endif

  return join(map(l:running_jobs, 'v:val.name'), ',')
endfunction

function! dkoline#Neomake(winnr, bufnr) abort
  if !a:bufnr | return '' | endif
  let l:result = neomake#statusline#get(a:bufnr, {
        \   'format_running':         '%#dkoLineNeomakeRunning# ᴍ:'
        \                             . dkoline#NeomakeJobs(a:bufnr) . ' ',
        \   'format_loclist_ok':      '%#dkoStatusGood# ⚑ ',
        \   'format_loclist_unknown': '',
        \   'format_loclist_type_E':  '%#dkoStatusError# ⚑{{count}} ',
        \   'format_loclist_type_W':  '%#dkoStatusWarning# ⚑{{count}} ',
        \   'format_loclist_type_I':  '%#dkoStatusInfo# ⚑{{count}} ',
        \ })
  return l:result
endfunction

" @return {String}
function! dkoline#Ruler() abort
  return ' %5.(%c%) '
endfunction

" ============================================================================
" Utility
" ============================================================================

let s:view_cache = {}

" Get cached properties for a window. Cleared on status line refresh
"
" @param {Int} winnr
" @return {Dict} properties derived from the active window
function! dkoline#GetView(winnr) abort
  let l:cached_view = get(s:view_cache, a:winnr, {})
  if !empty(l:cached_view)
    return l:cached_view
  endif
  let l:bufnr = winbufnr(a:winnr)
  let l:bufname = bufname(l:bufnr)
  let l:cwd = has('nvim') ? getcwd(a:winnr) : getcwd()
  let l:ft = getbufvar(l:bufnr, '&filetype')
  let l:ww = winwidth(a:winnr)
  let s:view_cache[a:winnr] = {
        \   'bufnr': l:bufnr,
        \   'bufname': l:bufname,
        \   'cwd': l:cwd,
        \   'ft': l:ft,
        \   'ww':  l:ww,
        \ }
  return s:view_cache[a:winnr]
endfunction

function! dkoline#Init() abort
  let s:view_cache = {}
  set statusline=%!dkoline#GetStatusline(1)
  call dkoline#RefreshTabline()
  set showtabline=2

  silent! nunmap <special> <Plug>(dkoline-refresh-tabline)
  nmap <silent><special>
        \ <Plug>(dkoline-refresh-tabline)
        \ :call dkoline#RefreshTabline()<CR>

  " BufWinEnter will initialize the statusline for each buffer
  let l:refresh_hooks = [
        \   'BufEnter',
        \   'BufWinEnter',
        \   'DirChanged',
        \ ]
        " \   'SessionLoadPost',
        " \   'TabEnter',
        " \   'VimResized',
        " \   'WinEnter',
        " \   'FileType',
        " \   'FileWritePost',
        " \   'FileReadPost',
        " \   'BufEnter' for different buffer
        " \   'CursorMoved' is for updating anzu search status accurately,
        "     using Plug mapping instead.

  let l:user_refresh_hooks = [
        \   'NeomakeFinished',
        \ ]
  " 'NeomakeCountsChanged',

  augroup dkoline
    autocmd!
    if !empty(l:refresh_hooks)
      execute 'autocmd dkoline ' . join(l:refresh_hooks, ',') . ' *'
            \ . ' call dkoline#RefreshStatus()'
    endif
    if !empty(l:user_refresh_hooks)
      execute 'autocmd dkoline User ' . join(l:user_refresh_hooks, ',')
            \ . ' call dkoline#RefreshStatus()'
    endif
  augroup END
endfunction

function! dkoline#RefreshStatus() abort
  let s:view_cache = {}
  " let g:dkoline#refresh += 1
  for l:winnr in range(1, winnr('$'))
    let l:fn = '%!dkoline#GetStatusline(' . l:winnr . ')'
    call setwinvar(l:winnr, '&statusline', l:fn)
  endfor
endfunction

function! dkoline#RefreshTabline() abort
  set tabline=%!dkoline#GetTabline()
endfunction

" bound to <F11> - see ../plugin/mappings.vim
function! dkoline#ToggleTabline() abort
  let &showtabline = &showtabline ? 0 : 2
endfunction
