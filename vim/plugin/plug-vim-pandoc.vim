" plugin/plug-vim-pandoc.vim

" Use this plugin on markdown
let g:pandoc#filetypes#handled = ['pandoc', 'markdown']

" but don't override the filetype (leave it as 'markdown')
"let g:pandoc#filetypes#pandoc_markdown = 0

" Don't bind keys since they assume use of \ instead of <Leader>
let g:pandoc#keyboard#use_default_mappings = 0

" Disabled some modules
let g:pandoc#modules#enabled = [
      \   'completion',
      \   'metadata',
      \   'keyboard',
      \   'toc',
      \   'spell',
      \   'hypertext'
      \ ]

let g:pandoc#syntax#conceal#use = 0

let g:pandoc#syntax#codeblocks#embeds#langs = [
      \   'bash=sh',
      \   'html',
      \   'javascript',
      \   'vim',
      \ ]

