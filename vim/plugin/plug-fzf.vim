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
