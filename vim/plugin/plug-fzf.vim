" plugin/plug-fzf.vim
" fzf.vim Settings

" iTerm can pipe from a spawned FZF back to Vim
if !has('nvim') && $TERM_PROGRAM ==# 'iTerm.app'
  let g:fzf_launcher = g:dko#vim_dir . '/bin/vim-fzf'
endif

let g:fzf_command_prefix = 'FZF'

let g:fzf_layout = { 'down': 16 }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [Files]
"let g:fzf_files_options = '--something...'

" [Commands]
if has('nvim')
  nnoremap <silent><special> <A-p> :<C-u>FZFCommands<CR>
endif

" junegunn/fzf mappings for the neovim :term
" Bind <fx> to abort FZF (<C-g> is one of the default abort keys in FZF)
" @see #f-keys
function! s:MapCloseFzf() abort
  if !has('nvim') | return | endif

  tnoremap <buffer><special> <F1> <C-g>
  tnoremap <buffer><special> <F2> <C-g>
  tnoremap <buffer><special> <F3> <C-g>
  tnoremap <buffer><special> <F4> <C-g>
  tnoremap <buffer><special> <F5> <C-g>
  tnoremap <buffer><special> <F6> <C-g>
  tnoremap <buffer><special> <F7> <C-g>
  tnoremap <buffer><special> <F8> <C-g>
  tnoremap <buffer><special> <F9> <C-g>
  tnoremap <buffer><special> <F10> <C-g>
  tnoremap <buffer><special> <F11> <C-g>
  tnoremap <buffer><special> <F12> <C-g>
endfunction

augroup dkofzf
  autocmd!
  autocmd FileType fzf call s:MapCloseFzf()
augroup END
