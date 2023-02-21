" autoload/dkoline.vim
scriptencoding utf-8

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
  let l:ftoutput = dkoline#Filetype(l:view.ft)
  let l:filename = fnamemodify(l:view.bufname, ':t')
  let l:devicon = luaeval("require('nvim-web-devicons').get_icon('" . l:filename . "')")
  if !empty(l:devicon)
    let l:ftoutput = ' ' . l:devicon . l:ftoutput
  endif
  let l:contents .= dkoline#Format(
        \ l:ftoutput,
        \ dkoline#ActiveColor(l:view, '%#dkoStatusKey#'))

  " Parent dir and filename
  let l:contents .= dkoline#Format(
        \ dkoline#TailDirFilename(l:view),
        \ dkoline#ActiveColor(l:view, '%#StatusLine#'))
  let l:contents .= dkoline#Format(
        \ dkoline#Dirty(l:view.bufnr),
        \ dkoline#ActiveColor(l:view, '%#DiffAdded#'))

  " Toggleable
  let l:contents .= dkoline#Format(
        \ dkoline#Paste(),
        \ dkoline#ActiveColor(l:view, '%#DiffText#'))

  let l:contents .= dkoline#Format(
        \ dkoline#Readonly(l:view.bufnr),
        \ dkoline#ActiveColor(l:view, '%#dkoLineImportant#'))

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%*%='

  " update if active window, otherwise leave as whatever it was previously
  let l:progress = luaeval('require("dko.lsp").status_progress({ bufnr = ' . l:view.bufnr . ' })')
  if type(l:progress) == v:t_dict
    let l:contents .= dkoline#Format(
    \ l:progress.bar . ' ' . l:progress.lowest.name,
    \ '%#dkoStatusKey# ',
    \ ' '
    \)
  endif

  " diagnostics for current buffer
  let l:getter = 'vim.diagnostic.get(' . l:view.bufnr
  let l:errors = len(luaeval(l:getter . ', { severity = vim.diagnostic.severity.ERROR })'))
  let l:warnings = len(luaeval(l:getter . ', { severity = vim.diagnostic.severity.WARN })'))
  let l:info = len(luaeval(l:getter . ', { severity = vim.diagnostic.severity.INFO })'))
  let l:hint = len(luaeval(l:getter . ', { severity = vim.diagnostic.severity.HINT })'))
  let l:total = l:errors + l:warnings + l:info + l:hint
  let l:contents .= dkoline#Format(
        \ l:errors ? '✘' . l:errors : '',
        \ '%#DiagnosticError# ',
        \ l:warnings + l:info + l:hint > 0 ? '' : ' '
        \)
  let l:contents .= dkoline#Format(
        \ l:warnings ? '' . l:warnings : '',
        \ '%#DiagnosticWarn# ',
        \ l:info + l:hint > 0 ? '' : ' '
        \)
  let l:contents .= dkoline#Format(
        \ l:info ? '⚑' . l:info : '',
        \ '%#DiagnosticInfo# ',
        \ l:hint > 0 ? '' : ' '
        \)
  let l:contents .= dkoline#Format(
        \ l:hint ? '' . l:hint : '',
        \ '%#DiagnosticHint# ',
        \ ' '
        \)
  let l:contents .= dkoline#Format(
        \ l:total == 0 ? '' : '',
        \ '%#dkoStatusGood# ',
        \ ' '
        \)

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
  let l:cwd = getcwd(a:winnr)
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

function! dkoline#InitTabline() abort
  let l:tab_refresh_hooks = [
        \   'DirChanged *',
        \   'User LazyDone',
        \   'User LazyUpdate',
        \   'User LazyCheck',
        \   'User VeryLazy',
        \   'User LspProgressUpdate',
        \   'User LspRequest',
        \ ]
endfunction

function! dkoline#Init() abort
  call dkoline#SetStatus(winnr())

  " BufWinEnter will initialize the statusline for each buffer
  let l:refresh_hooks = [
        \   'BufDelete *',
        \   'BufWinEnter *',
        \   'BufWritePost *',
        \   'BufEnter *',
        \   'DiagnosticChanged *',
        \   'DirChanged *',
        \   'FileType *',
        \   'WinEnter *',
        \ ]
        " \   'SessionLoadPost',
        " \   'TabEnter',
        " \   'VimResized',
        " \   'FileWritePost',
        " \   'FileReadPost',

  augroup dkoline
    autocmd!
    for l:hook in l:refresh_hooks
      execute 'autocmd ' . l:hook . ' call dkoline#SetStatus(winnr())'
    endfor
  augroup END
endfunction

function! dkoline#SetStatus(winnr) abort
  let s:view_cache = {}
  exec 'setlocal statusline=%!dkoline#GetStatusline(' . a:winnr . ')'
endfunction
