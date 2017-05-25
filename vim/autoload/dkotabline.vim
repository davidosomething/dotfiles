scriptencoding utf-8

" ============================================================================
" Tab line
" ============================================================================

" bound to <F11> - see plugin/mappings.vim
function! dkotabline#Toggle() abort
  execute 'set showtabline=' . (&showtabline ? 0 : 2)
endfunction

" Called by autocmd in vimrc on cursormoved and other win events
function! dkotabline#Refresh() abort
  call setwinvar(winnr(), '&tabline', '%!dkotabline#Output()')
endfunction

" Called by autocmd in vimrc
function! dkotabline#Output() abort
  let l:contents = '%#StatusLine#'

  " ==========================================================================
  " Left side
  " ==========================================================================

  let l:funcinfo = dkocode#GetFunctionInfo()
  let l:contents .= !empty(l:funcinfo.name)
        \ ? '%#PMenu# Fᴜɴᴄ %#PmenuSel# ' . l:funcinfo.name . ' '
        \ : ''

  " ==========================================================================
  " Right side
  " ==========================================================================

  let l:contents .= '%#StatusLine# %= '

  let l:contents .= '%#Pmenu# Pʀᴏᴊ %#PmenuSel#' . dko#ShortenPath(dkoproject#GetRoot(), 80)

  " ==========================================================================

  return l:contents
endfunction
