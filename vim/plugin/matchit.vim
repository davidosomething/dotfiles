" ============================================================================
" Matchit
" ============================================================================

" From tpope/vim-sensible: load matchit.vim, but only if the user hasn't
" installed a newer version.
" For macvim it is found here:
" /Applications/MacVim.app/Contents/Resources/vim/runtime/macros/matchit.vim
if !exists('g:loaded_matchit')
  runtime! macros/matchit.vim
endif

