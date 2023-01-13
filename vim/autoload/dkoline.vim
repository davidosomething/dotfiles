" autoload/dkoline.vim
scriptencoding utf-8

function! dkoline#GetTabline() abort
  let l:view = dkoline#GetView(winnr())

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

  if dkoplug#IsLoaded('coc.nvim')
    let l:contents .= dkoline#Format(
          \ dkoline#CocStatus(l:view),
          \ '%(%#dkoStatusValue# ',
          \ ' %)'
          \)
  endif

  let l:contents .= dkoline#Format(
        \ ' ' . get(l:view, 'cwd', '~') . ' ',
        \ '%#dkoStatusKey# ʟᴄᴅ %(%#dkoStatusValue#%<',
        \ '%)')

  let l:contents .= !empty(get(g:, 'coc_git_status', ''))
        \ ? '%#dkoStatusKey# ' . g:coc_git_status . ' '
        \ : dkoline#Format(
        \     dkoline#GitBranch(l:view),
        \     '%#dkoStatusKey# ∆ %(%#dkoStatusValue#',
        \     '%)'
        \   )

  " ==========================================================================

  return l:contents
endfunction

function! dkoline#GetStatusline(winnr) abort
  if empty(a:winnr) || a:winnr > winnr('$')
    return
  endif
  let l:view = dkoline#GetView(a:winnr)

  let l:contents = ''

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:contents .= dkoline#Mode(l:view.winnr)

  " Restore color to ensure parts aren't hidden on inactive buffers
  let l:contents .= '%#StatusLine#'

  " Filebased
  let l:contents .= dkoline#Format(
        \ dkoline#Filetype(l:view.ft),
        \ dkoline#ActiveColor(l:view, '%#dkoStatusKey#'))

  " Parent dir and filename
  let l:contents .= dkoline#Format(
        \ dkoline#TailDirFilename(l:view),
        \ dkoline#ActiveColor(l:view, '%#StatusLine#'))
  let l:contents .= dkoline#Format(
        \ dkoline#Dirty(l:view.bufnr),
        \ dkoline#ActiveColor(l:view, '%#DiffAdded#'))

  let l:contents .= dkoline#Format(
        \ dkoline#Readonly(l:view.bufnr),
        \ dkoline#ActiveColor(l:view, '%#dkoLineImportant#'))

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%*%='

  " Blame
  " let l:contents .= dkoline#Format(
  "      \ ' ' . get(b:, 'coc_git_blame', '') . ' ',
  "      \ '%(%#dkoStatusValue#%<',
  "      \ '%)')

  " Linting
  if dkoplug#IsLoaded('coc.nvim')
    let l:contents .= dkoline#CocDiagnostics(l:view)
  endif
  if dkoplug#IsLoaded('neomake') && exists('*neomake#GetJobs')
    let l:contents .= dkoline#Neomake(l:view)
  endif

  let l:contents .= dkoline#Format(
        \ dkoline#Ruler(),
        \ dkoline#ActiveColor(l:view, '%#dkoStatusItem#'))

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

function! dkoline#ActiveColor(view, color) abort
  return a:view.winnr == winnr() ? a:color : '%#StatusLineNC#'
endfunction

" @param {Number} winnr
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

" @param {String} ft
" @return {String}
function! dkoline#Filetype(ft) abort
  return empty(a:ft) ? '' : ' ' . a:ft . ' '
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
    return ' ᴜɴɴᴀᴍᴇᴅ '
  endif

  if dko#IsHelp(a:view.bufnr)
    return ' ' . a:view.bufname . ' '
  endif

  let l:parent0 = fnamemodify(a:view.bufname, ':p:h:t')
  let l:parent1 = fnamemodify(a:view.bufname, ':p:h:h:t')
  let l:parent2 = fnamemodify(a:view.bufname, ':p:h:h:h:t')
  let l:filename = fnamemodify(a:view.bufname, ':t')
  return ' ' . substitute(
        \   join([ l:parent2, l:parent1, l:parent0, l:filename ], '/'),
        \   '//', '', 'g'
        \ ) . ' '
endfunction

" @param {Int} bufnr
" @return {String}
function! dkoline#Dirty(bufnr) abort
  return getbufvar(a:bufnr, '&modified') ? ' + ' : ''
endfunction

" Get the git branch for the file in buffer
"
" @param {Dict} view
" @return {String}
function! dkoline#GitBranch(view) abort
  return dko#IsNonFile(a:view.bufnr)
        \ || empty(getbufvar(a:view.bufnr, 'dko_branch'))
        \ ? ''
        \ : ' ' . getbufvar(a:view.bufnr, 'dko_branch') . ' '
endfunction

" @param {Dict} view
" @return {String}
function! dkoline#CocDiagnostics(view) abort
  if dko#IsNonFile(a:view.bufnr) | return '' | endif
  let l:d = getbufvar(a:view.bufnr, 'coc_diagnostic_info')
  return empty(l:d) ? '' :
        \ dkoline#Format(
        \   !l:d.error ? '' : ' ⚑' . l:d.error . ' ',
        \   '%(%#dkoStatusError#', '%)') .
        \ dkoline#Format(
        \   !l:d.warning ? '' : ' ⚑' . l:d.warning . ' ',
        \   '%(%#dkoStatusWarning#', '%)') .
        \ dkoline#Format(
        \   !l:d.information ? '' : ' ⚑' . l:d.information . ' ',
        \   '%(%#dkoStatusInfo#', '%)') .
        \ dkoline#Format(
        \   !l:d.hint ? '' : ' ⚑' . l:d.hint . ' ',
        \   '%(%#dkoStatusItem#', '%)')
endfunction

function! dkoline#CocStatus(view) abort
  return trim(get(g:, 'coc_status', ''))
endfunction

" @return {string} job1,job2,job3
function! dkoline#NeomakeJobs(bufnr) abort
  if !a:bufnr | return '' | endif
  let l:running_jobs = filter(copy(neomake#GetJobs()),
        \ 'v:val.bufnr == ' . a:bufnr . ' && !get(v:val, "canceled", 0)')
  if empty(l:running_jobs) | return | endif

  return join(map(l:running_jobs, 'v:val.name'), ',')
endfunction

" @param {Dict} view
" @return {String}
function! dkoline#Neomake(view) abort
  let l:result = neomake#statusline#get(a:view.bufnr, {
        \   'format_running':         '%#dkoLineNeomakeRunning# ᴍ:'
        \                             . dkoline#NeomakeJobs(a:view.bufnr) . ' ',
        \   'format_loclist_ok':      '%#dkoStatusGood# ✓ ',
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
  let l:cwd = getcwd()
  let l:ft = getbufvar(l:bufnr, '&filetype')
  let l:ww = winwidth(a:winnr)
  let s:view_cache[a:winnr] = {
        \   'winnr': a:winnr,
        \   'bufnr': l:bufnr,
        \   'bufname': l:bufname,
        \   'cwd': l:cwd,
        \   'ft': l:ft,
        \   'ww':  l:ww,
        \ }
  return s:view_cache[a:winnr]
endfunction

function! dkoline#Init() abort
  call dkoline#SetStatus(winnr())

  call dkoline#RefreshTabline()
  set showtabline=2

  silent! nunmap <special> <Plug>(dkoline-refresh-tabline)
  nmap <silent><special>
        \ <Plug>(dkoline-refresh-tabline)
        \ :call dkoline#RefreshTabline()<CR>

  " BufWinEnter will initialize the statusline for each buffer
  let l:refresh_hooks = [
        \   'BufDelete *',
        \   'BufWinEnter *',
        \   'BufWritePost *',
        \   'BufEnter *',
        \   'FileType *',
        \   'WinEnter *',
        \   'User CocDiagnosticChange',
        \   'User NeomakeCountsChanged',
        \   'User NeomakeFinished',
        \ ]
        " \   'SessionLoadPost',
        " \   'TabEnter',
        " \   'VimResized',
        " \   'FileWritePost',
        " \   'FileReadPost',

  let l:tab_refresh_hooks = [
        \   'User CocStatusChange',
        \ ]

  augroup dkoline
    autocmd!
    for l:hook in l:tab_refresh_hooks
      execute 'autocmd ' . l:hook . ' call dkoline#RefreshTabline()'
    endfor
    for l:hook in l:refresh_hooks
      execute 'autocmd ' . l:hook . ' call dkoline#SetStatus(winnr())'
    endfor
  augroup END
endfunction

function! dkoline#SetStatus(winnr) abort
  let s:view_cache = {}
  exec 'setlocal statusline=%!dkoline#GetStatusline(' . a:winnr . ')'
endfunction

function! dkoline#RefreshTabline() abort
  set tabline=%!dkoline#GetTabline()
endfunction

" bound to <F11> - see ../plugin/mappings.vim
function! dkoline#ToggleTabline() abort
  let &showtabline = &showtabline ? 0 : 2
endfunction
