" plugin/fzf.vim
scriptencoding utf-8

if !g:dko_use_fzf | finish | endif
if !dko#IsPlugged('fzf.vim') | finish | endif

let g:fzf_layout = { 'down': '10' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

execute dko#MapAll({ 'key': '<F1>', 'command': 'Buffers' })
execute dko#MapAll({ 'key': '<F2>', 'command': 'History' })
execute dko#MapAll({ 'key': '<F3>', 'command': 'Files' })
execute dko#MapAll({ 'key': '<F4>', 'command': 'Ag' })
execute dko#MapAll({ 'key': '<F8>', 'command': 'Colors' })

command! FZV
      \ call fzf#run({
      \   'source':   split(globpath(dko#vim_dir, "{after,autoload,ftplugin,plugin,syntax}/**/*.vim"), "\n"),
      \   'sink':     'edit',
      \   'options':  '+m',
      \   'down':     10,
      \ })

