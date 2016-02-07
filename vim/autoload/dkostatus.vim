" ============================================================================
" Status line
" ============================================================================

function! dkostatus#Mode() abort
  let l:modecolor = '%#DiffAdd#'
  if mode() ==# 'i'
    let l:modecolor = '%#DiffChange#'
  elseif mode() ==# 'v'
    let l:modecolor = '%#Cursor#'
  endif
  return  l:modecolor . ' %{mode()} %*'
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

  " truncated filename
  let l:contents .= ' %<%f '

  " --------------------------------------------------------------------------
  " Right side
  " --------------------------------------------------------------------------

  let l:contents .= '%='

  if exists("g:plugs['vim-anzu']") && a:winnr == winnr()
    let l:contents .= !empty(anzu#search_status())
          \ ? '%*%#MatchParen#' . ' %{anzu#search_status()} ' . '%*'
          \ : ''
  endif

  " [&ft]
  let l:contents .= !empty(&ft) && a:winnr == winnr()
        \ ? ' ' . &ft . ' '
        \ : ''

  " ruler (10 char long, so can accommodate 99999)
  let l:contents .= '%#VertSplit#' . '%5.(%c%) ' . '%*'

  " Syntastic
  if exists("g:plugs['syntastic']") && a:winnr == winnr()
    let l:contents .= !empty(SyntasticStatuslineFlag())
          \ ? '%#SyntasticErrorSign#' . ' %{SyntasticStatuslineFlag()} ' . '%*'
          \ : ''
  endif

  return l:contents
endfunction
