" netrw
" disable netrw in favor of vimfiler -- netrw sucks!
let g:loaded_netrwPlugin = 1
" netrw in details format when no vimfiler
let g:netrw_liststyle = 3

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_tree_leaf_icon      = ' '
let g:vimfiler_tree_opened_icon    = '▾'
let g:vimfiler_tree_closed_icon    = '▸'
let g:vimfiler_file_icon           = '-'
let g:vimfiler_marked_file_icon    = '*'
nnoremap  <silent><F9>  :VimFilerExplorer<CR>
inoremap  <silent><F9>  <Esc>:VimFilerExplorer<CR>
vnoremap  <silent><F9>  <Esc>:VimFilerExplorer<CR>
