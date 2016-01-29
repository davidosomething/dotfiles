scriptencoding utf-8
if !exists("g:plugs['vimfiler.vim']") | finish | endif

let g:vimfiler_as_default_explorer = 1

" ============================================================================
" List settings
" ============================================================================

" Default was all dot files. Overriding with just these:
let g:vimfiler_ignore_pattern = [
      \   '^\.git$',
      \   '^\.DS_Store$',
      \ ]

" ============================================================================
" Symbol setup
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
  VimFilerExplorer -parent -explorer-columns=type
endfunction

nnoremap <silent> <F10>  :call <SID>DKO_VimFilerExplorer()<CR>
inoremap <silent> <F10>  <Esc>:call <SID>DKO_VimFilerExplorer()<CR>
vnoremap <silent> <F10>  <Esc>:call <SID>DKO_VimFilerExplorer()<CR>

