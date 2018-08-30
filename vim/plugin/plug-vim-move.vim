" plugin/plug-vim-move.vim

if !dkoplug#Exists('vim-move') | finish | endif

augroup dkovimmove
  autocmd!
augroup END

" Use <C-j/k> to bubble
let g:move_key_modifier = 'C'

" Don't reindent after each move
let g:move_auto_indent = 0

function! s:Unmap() abort
  if dko#IsEditable('%') | return | endif

  let s:cpo_save = &cpoptions
  set cpoptions&vim

  " Have to <NOP> these since the vim-move mappings are not <buffer> local
  silent! nnoremap <buffer> <C-j> <NOP>
  silent! vnoremap <buffer> <C-j> <NOP>
  silent! nnoremap <buffer> <C-k> <NOP>
  silent! vnoremap <buffer> <C-k> <NOP>
  silent! nnoremap <buffer> <C-l> <NOP>
  silent! vnoremap <buffer> <C-l> <NOP>
  silent! nnoremap <buffer> <C-h> <NOP>
  silent! vnoremap <buffer> <C-h> <NOP>

  let &cpoptions = s:cpo_save
  unlet s:cpo_save
endfunction

autocmd dkovimmove BufWinEnter * call s:Unmap()
