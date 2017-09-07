" plugin/plug-vim-move.vim

if !dko#IsPlugged('vim-move') | finish | endif

augroup dkovimmove
  autocmd!
augroup END

" Use <C-j/k> to bubble
let g:move_key_modifier = 'C'

" Don't reindent after each move
let g:move_auto_indent = 0

function! s:Unmap() abort
  if dko#IsEditable()
    return
  endif

  " Have to <NOP> these since the vim-move mappings are not <buffer> local
  silent! nnoremap <buffer> <C-j> <NOP>
  silent! nnoremap <buffer> <C-k> <NOP>
  silent! vnoremap <buffer> <C-j> <NOP>
  silent! vnoremap <buffer> <C-k> <NOP>
endfunction

autocmd dkovimmove BufEnter,BufReadPost * call s:Unmap()
