" plugin/plug-vim-dko-fzf.vim

if !dkoplug#plugins#IsLoaded('fzf.vim') | finish | endif

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

" Start using meta mappings since I hate the Macbook touchbar
nmap   <silent><special>   <A-g>   :<C-U>FZFGrepper!<CR>
nmap   <silent><special>   <A-b>   :<C-U>FZFBuffers<CR>
nmap   <silent><special>   <A-f>   :<C-U>FZFFiles<CR>
nmap   <silent><special>   <A-m>   :<C-U>FZFMRU<CR>
nmap   <silent><special>   <A-s>   :<C-U>FZFSpecs<CR>
