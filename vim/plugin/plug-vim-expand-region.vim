" plugin/plug-vim-expand-region.vim

if !dko#IsPlugged('vim-expand-region') | finish | endif

" Extend the global default (NOTE: Remove comments in dictionary before sourcing)
call expand_region#custom_text_objects({
      \   'ab': 0,
      \   'ad': 0,
      \   'aD': 0,
      \   'ii': 0,
      \   'ai': 0,
      \ })

call expand_region#custom_text_objects('javascript', {
      \   'if': 0,
      \   'af': 0,
      \ })

call expand_region#custom_text_objects('php', {
      \   'if': 0,
      \   'af': 0,
      \ })
