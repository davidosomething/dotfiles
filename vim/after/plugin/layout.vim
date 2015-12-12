" ============================================================================
" Buffer manip
" ============================================================================

" close buffer with space-bd and auto close loc list first
nnoremap  <Leader>bd :lclose<CR>:bdelete<CR>
cabbrev   <silent>bd lclose\|bdelete

" ============================================================================
" Split manip
" ============================================================================

" Navigate with ctrl+arrow
nnoremap <silent> <C-Left>       :wincmd h<CR>
inoremap <silent> <C-Left>  <Esc>:wincmd h<CR>
nnoremap <silent> <C-Down>       :wincmd j<CR>
inoremap <silent> <C-Down>  <Esc>:wincmd j<CR>
nnoremap <silent> <C-Up>         :wincmd k<CR>
inoremap <silent> <C-Up>    <Esc>:wincmd k<CR>
nnoremap <silent> <C-Right>      :wincmd l<CR>
inoremap <silent> <C-Right> <Esc>:wincmd l<CR>
nmap <A-x> :close<CR>

" Cycle with tab in normal mode
nnoremap <Tab> <C-w>w

" Resize
nnoremap <silent> <S-Left>  4<C-w><
nnoremap <silent> <S-Down>  4<C-W>-
nnoremap <silent> <S-Up>    4<C-W>+
nnoremap <silent> <S-Right> 4<C-w>>
inoremap <silent> <S-Left>  <Esc>4<C-w><
inoremap <silent> <S-Down>  <Esc>4<C-W>-
inoremap <silent> <S-Up>    <Esc>4<C-W>+
inoremap <silent> <S-Right> <Esc>4<C-w>>

