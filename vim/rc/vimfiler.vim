scriptencoding utf-8

let g:vimfiler_as_default_explorer = 1

" ============================================================================
" Disable netrw
" ============================================================================

let g:loaded_netrwPlugin = 1
" netrw in details format when no vimfiler
let g:netrw_liststyle = 3

" ============================================================================
" List settings
" ============================================================================

" Default was all dot files. Overriding with just these:
let g:vimfiler_ignore_pattern = [
      \   '^\.git$',
      \   '^\.DS_Store$',
      \ ]

" ============================================================================
" Symbol setup -- vim-devicons will override
" ============================================================================

let g:vimfiler_tree_leaf_icon     = ' '
let g:vimfiler_tree_opened_icon   = '▾'
let g:vimfiler_tree_closed_icon   = '▸'
let g:vimfiler_file_icon          = '-'
let g:vimfiler_marked_file_icon   = '*'
let g:vimfiler_readonly_file_icon = ''

" ============================================================================
" Shortcut
" ============================================================================

function! s:DKO_VimFilerExplorer()
  if exists("g:plugs['vim-devicons']")
    VimFilerExplorer -parent -explorer-columns=devicons
  else
    VimFilerExplorer -parent -explorer-columns=type
  endif
endfunction

nnoremap <silent> <F9>  :call <SID>DKO_VimFilerExplorer()<CR>
inoremap <silent> <F9>  <Esc>:call <SID>DKO_VimFilerExplorer()<CR>
vnoremap <silent> <F9>  <Esc>:call <SID>DKO_VimFilerExplorer()<CR>

