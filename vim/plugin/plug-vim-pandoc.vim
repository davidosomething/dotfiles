" plugin/plug-vim-pandoc.vim

" Use this plugin on markdown
let g:pandoc#filetypes#handled = ['pandoc', 'markdown']

" but don't override the filetype (leave it as 'markdown')
"let g:pandoc#filetypes#pandoc_markdown = 0

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
      \   'handlebars=mustache',
      \   'html',
      \   'javascript',
      \   'php',
      \   'vim',
      \ ]

