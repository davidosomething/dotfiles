if !exists("g:plugs['tabular']") | finish | endif

let g:pandoc#syntax#codeblocks#embeds#langs = [
      \   'bash=sh',
      \   'handlebars=mustache',
      \   'html',
      \   'javascript',
      \   'php',
      \   'vim',
      \ ]

