if !exists("g:plugs['vim-pandoc-syntax']") | finish | endif

let g:pandoc#syntax#codeblocks#embeds#langs = [
      \   'bash=sh',
      \   'handlebars=mustache',
      \   'html',
      \   'javascript',
      \   'php',
      \   'vim',
      \ ]

