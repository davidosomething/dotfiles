" plugin/plug-vim-dko-fzf.vim

if !dko#IsLoaded('fzf.vim') | finish | endif

augroup dkovimdkofzf
  autocmd!
augroup END

" Map the commands -- the actual plugin is loaded by a vim-plug 'on' hook when
" a command is run for the first time
execute dko#MapAll({ 'key': '<F1>', 'command': 'FZFGrepper!' })
execute dko#MapAll({ 'key': '<F2>', 'command': 'FZFRelevant' })
execute dko#MapAll({ 'key': '<F3>', 'command': 'FZFProject' })
execute dko#MapAll({ 'key': '<F4>', 'command': 'FZFMRU' })
execute dko#MapAll({ 'key': '<F5>', 'command': 'FZFFiles' })
execute dko#MapAll({ 'key': '<C-s>', 'command': 'FZFSpecs' })
map   <special>   <Leader>b   :<C-U>FZFBuffers<CR>
