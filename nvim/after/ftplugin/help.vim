" after/ftplugin/help.vim
" Help buffer

if exists('b:did_after_ftplugin') | finish | endif

call dko#TwoSpace()

" Don't hide formatting symbols since I write vim helpfiles
" Vim default is conceallevel=2
if !&readonly && has('conceal')
  setlocal conceallevel=0
  setlocal concealcursor=
endif

" include dash when looking up keywords, cursor on v in `vim-modes` will
" look up `vim-modes`, not just `vim`
setlocal iskeyword+=-

" Use vim :help when you press K over a word
setlocal keywordprg=:help

let s:cpo_save = &cpoptions
set cpoptions&vim

if dkoplug#IsLoaded('vim-docopen')
  nnoremap <buffer><silent> go :<C-U>DocOpen<CR>
endif

let &cpoptions = s:cpo_save
unlet s:cpo_save
