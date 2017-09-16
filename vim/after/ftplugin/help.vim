" after/ftplugin/help.vim
" Help buffer

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Don't hide formatting symbols since I write vim helpfiles
" Vim default is conceallevel=2
" ============================================================================

if !&readonly && has('conceal')
  setlocal conceallevel=0
  setlocal concealcursor=

  augroup dkohelp
    autocmd!
  augroup END

  " Toggle vim-hier for help buffers, run :VimhelpLint manually though
  if dko#IsLoaded('vim-vimhelplint') && dko#IsLoaded('vim-hier')
    autocmd dkohelp   BufEnter,BufReadPost  *   if &filetype ==# 'help' | HierStart | endif
    autocmd dkohelp   BufLeave,BufUnload    *   if &filetype ==# 'help' | HierStop | endif
    HierStart
  endif
endif

" ============================================================================
" Use vim :help when you press K over a word
" ============================================================================

setlocal keywordprg=:help

" include dash when looking up keywords, cursor on v in `vim-modes` will
" look up `vim-modes`, not just `vim`
setlocal iskeyword+=-

if dko#IsLoaded('vim-docopen')
  nnoremap go :<C-u>DocOpen<CR>
endif

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
