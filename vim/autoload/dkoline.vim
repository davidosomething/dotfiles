" autoload/dkoline.vim
scriptencoding utf-8

" let g:dkoline#refresh = 0
" let g:dkoline#trefresh = 0
" let g:dkoline#srefresh = 0

function! dkoline#GetTabline() abort
  "let g:dkoline#trefresh += 1
  let l:tabnr = tabpagenr()
  let l:winnr = tabpagewinnr(l:tabnr)
  let l:bufnr = winbufnr(l:winnr)
  let l:cwd   = has('nvim') ? getcwd(l:winnr) : getcwd()

  let l:x = {
        \   'bufnr': l:bufnr,
        \   'ww': 9999,
        \ }

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
        \ ' ' . get(l:, 'cwd', '~') . ' ',
        \ '%#dkoStatusKey# ʟᴄᴅ %(%#dkoStatusValue#%<',
        \ '%)')

  "let l:contents .= ''

  " ==========================================================================

  return l:contents
endfunction

" a:winnr from dkoline#Refresh() or 0 on set statusline
function! dkoline#GetStatusline(winnr) abort
  if empty(a:winnr) | return | endif
  " let g:dkoline#srefresh += 1

  let l:winnr = a:winnr > winnr('$') ? 1 : a:winnr
  let l:bufnr = winbufnr(l:winnr)
  let l:ww    = winwidth(l:winnr)
  let l:cwd   = has('nvim') ? getcwd(l:winnr) : getcwd()

  let l:x = {
        \   'bufnr': l:bufnr,
        \   'ww': l:ww,
        \ }

  let l:contents = ''

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= '%#StatusLineNC# %3(' . dkoline#Mode(l:winnr) . '%)'

  " Filebased
  let l:ft = dkoline#Filetype(l:bufnr)
  let l:contents .= dkoline#Format(
        \   dkoline#Filetype(l:bufnr),
        \   (dkoline#If({ 'winnr': l:winnr }, l:x)
        \     ? '%#dkoStatusValue#' : '%#StatusLineNC#' )
        \ )

  let l:maxwidth = l:ww - 4 - len(l:ft) - 16
  let l:maxwidth = l:maxwidth > 0 ? l:maxwidth : 48
  let l:contents .= dkoline#Format(
        \   dkoline#TailDirFilename(l:bufnr, l:cwd),
        \   '%0.' . l:maxwidth . '('
        \     . (dkoline#If({ 'winnr': l:winnr }, l:x)
        \       ? '%#StatusLine#'
        \       : '%#StatusLineNC#'),
        \   '%)'
        \ )
  let l:contents .= dkoline#Format(dkoline#Dirty(l:bufnr), '%#DiffAdded#')

  " Toggleable
  if !has('nvim')
    let l:contents .= dkoline#Format(dkoline#Paste(), '%#DiffText#')
  endif

  let l:contents .= dkoline#Format(dkoline#Readonly(l:bufnr), '%#dkoLineImportant#')

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%*%='

  let l:contents .= dkoline#Format(
        \ dkoline#GitBranch(l:bufnr),
        \ '%#dkoStatusKey# ∆ %(%#dkoStatusValue#',
        \ '%)')

  " Linting
  if dkoplug#IsLoaded('neomake') && exists('*neomake#GetJobs')
    let l:contents .= dkoline#Neomake(l:winnr, l:bufnr)
  endif

  let l:contents .= dkoline#Format(dkoline#Ruler(), '%#dkoStatusItem#')

  return l:contents
endfunction

" ============================================================================
" Output functions
" ============================================================================

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

" Ignore some filetypes
"
" @param {Int} bufnr
" @return {String}
function! dkoline#Filetype(bufnr) abort
  let l:ft = getbufvar(a:bufnr, '&filetype')
  return empty(l:ft) || index([
        \   'javascript',
        \   'java',
        \   'vim',
        \ ], l:ft) > -1
        \ ? ''
        \ : ' ' . l:ft . ' '
endfunction

" File path of buffer, or just the helpfile name if it is a help file
"
" @param {Int} bufnr
" @param {String} path
" @return {String}
function! dkoline#RelativeFilepath(bufnr, path) abort
  if dko#IsNonFile(a:bufnr)
    return ''
  endif

  let l:filename = bufname(a:bufnr)
  if empty(l:filename)
    let l:contents = '[No Name]'
  else
    let l:contents = dko#IsHelp(a:bufnr)
          \ ? '%t'
          \ : fnamemodify(substitute(l:filename, a:path, '.', ''), ':~:.')
  endif

  return ' ' . l:contents . ' '
endfunction

" Show buffer's filename and immediate parent directory
"
" @param {Int} bufnr
" @param {String} cwd
" @return {String}
function! dkoline#TailDirFilename(bufnr, cwd) abort
  if dko#IsNonFile(a:bufnr)
    return ''
  endif

  let l:filename = bufname(a:bufnr)
  if empty(l:filename)
    let l:contents = '[No Name]'
  else
    if dko#IsHelp(a:bufnr)
      let l:contents = '%t'
    else
      let l:parent_dir = fnamemodify(l:filename, ':h:t')
      let l:parent_dir = l:parent_dir !=# '.' ? l:parent_dir : fnamemodify(a:cwd, ':t')
      let l:contents = l:parent_dir . '/' . fnamemodify(l:filename, ':t')
    endif
  endif

  return ' ' . l:contents . ' '
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

function! dkoline#Init() abort
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
