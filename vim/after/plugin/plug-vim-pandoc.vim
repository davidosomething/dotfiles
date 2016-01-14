if !exists("g:plugs['tabular']") | finish | endif

let g:pandoc#syntax#codeblocks#embeds#langs = [
      \   "javascript",
      \   "bash=sh"
      \ ]

