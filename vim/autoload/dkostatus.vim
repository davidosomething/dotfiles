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

function! dkostatus#readonly() abort
  return &readonly ? '%#Error# 🔒 %*' : ''
endfunction

function! dkostatus#modified() abort
  return &modified ? '%#WildMenu# ⚒ %*' : ''
endfunction

" a:winnr when called from autocmd in plugin/statusline.vim
function! dkostatus#Output(winnr) abort
  let l:contents = ''

  " mode
  let l:contents .= dkostatus#Mode()
  let l:contents .= !empty(&paste) ? '%#DiffText# p %*' : ''

  " [help][Quickfix/Location List][Preview]
  "let l:contents .= '%h%q%w'

  " --------------------------------------------------------------------------
  " File info
  " --------------------------------------------------------------------------

  " DISABLED
  if 0 && exists("g:plugs['vim-fugitive']") && a:winnr == winnr()
    let l:contents .= !empty(fugitive#head())
          \ ? '%#DiffAdd# %{fugitive#head()} %*'
          \ : ''
  endif

  " Syntastic
  if exists("g:plugs['syntastic']") && a:winnr == winnr()
    let l:contents .= !empty(SyntasticStatuslineFlag())
          \ ? '%#SyntasticErrorSign#' . ' %{SyntasticStatuslineFlag()} ' . '%*'
          \ : ''
  endif

  let l:contents .= dkostatus#readonly()
  let l:contents .= dkostatus#modified()

  " &ft
  let l:contents .= !empty(&ft) && a:winnr == winnr()
        \ ? '%#StatusLineNC# ' . &ft . ' %*'
        \ : ''

  " fname 
  let l:contents .= ' %<%f %*'

  " --------------------------------------------------------------------------
  " Right side
  " --------------------------------------------------------------------------

  let l:contents .= '%='

  if exists("g:plugs['vim-anzu']") && a:winnr == winnr()
    let l:contents .= !empty(anzu#search_status())
          \ ? '%*%#MatchParen#' . ' %{anzu#search_status()} ' . '%*'
          \ : ''
  endif

  " pwd
  let l:contents .= ' %<%{getcwd()} %*'

  " ruler (10 char long, so can accommodate 99999)
  let l:contents .= '%#VertSplit#' . ' %5.(%c%) ' . '%*'

  return l:contents
endfunction
