scriptencoding utf-8

" ============================================================================
" Status line
" ============================================================================

function! dkostatus#Mode() abort
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

function! dkostatus#Readonly(bufnr) abort
  return getbufvar(a:bufnr, '&readonly') ? '%#Error# 🔒 %*' : ''
endfunction

function! dkostatus#Modified(bufnr) abort
  return getbufvar(a:bufnr, '&modified') ? '%#WildMenu# ⚒ %*' : ''
endfunction

function! dkostatus#Filetype(bufnr) abort
  let l:ft = getbufvar(a:bufnr, '&filetype')
  return !empty(l:ft)
        \ ? '%#StatusLineNC# ' . l:ft . ' %*'
        \ : ''
endfunction

" a:winnr when called from autocmd in plugin/statusline.vim
function! dkostatus#Output(winnr) abort
  let l:bufnr = winbufnr(a:winnr)

  let l:contents = ''

  " --------------------------------------------------------------------------
  " Mode
  " --------------------------------------------------------------------------

  let l:contents .= dkostatus#Mode()

  let l:contents .= !empty(&paste) ? '%#DiffText# p %*' : ''

  " --------------------------------------------------------------------------
  " Buffer Info
  " --------------------------------------------------------------------------

  " [help][Quickfix/Location List][Preview]
  "let l:contents .= '%h%q%w'

  " DISABLED branch only in current window
  if 0 && exists("g:plugs['vim-fugitive']") && a:winnr == winnr()
    let l:contents .= !empty(fugitive#head())
          \ ? '%#DiffAdd# %{fugitive#head()} %*'
          \ : ''
  endif

  " Syntastic only in current window
  if exists("g:plugs['syntastic']") && a:winnr == winnr()
    let l:contents .= !empty(SyntasticStatuslineFlag())
          \ ? '%#SyntasticErrorSign#' . ' %{SyntasticStatuslineFlag()} ' . '%*'
          \ : ''
  endif

  let l:contents .= dkostatus#Readonly(l:bufnr)
  let l:contents .= dkostatus#Modified(l:bufnr)
  let l:contents .= dkostatus#Filetype(l:bufnr)

  " fname
  let l:contents .= ' %<%f %*'

  " anzu only in current window
  if exists("g:plugs['vim-anzu']") && a:winnr == winnr()
    let l:contents .= !empty(anzu#search_status())
          \ ? '%*%#Visual#' . ' %{anzu#search_status()} ' . '%*'
          \ : ''
  endif

  " --------------------------------------------------------------------------
  " Right side
  " --------------------------------------------------------------------------

  let l:contents .= '%='

  " pwd
  let l:contents .= '%#Folded# %<%{pathshorten(getcwd())} %*'

  " ruler (10 char long, so can accommodate 99999)
  let l:contents .= '%#VertSplit#' . ' %5.(%c%) ' . '%*'

  return l:contents
endfunction
