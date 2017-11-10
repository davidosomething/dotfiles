" autoload/dkoproject/neomake/markdown.vim

if !dkoplug#plugins#IsLoaded('neomake') | finish | endif

" Use npx to execute markdownlint
function! dkoproject#neomake#markdown#Markdownlint() abort
  let l:maker = neomake#makers#ft#markdown#markdownlint()

  " Use markdownlint in local node_modules/ if available
  let l:maker.exe = 'npx'
  if !executable(l:maker.exe) | return | endif

  " Since using npx, run from file's directory; npx will look upwards to
  " global
  let l:maker.cwd = '%:p:h'

  " follows rc style traversal
  " https://www.npmjs.com/package/rc#standards
  let l:maker.args = [ '--quiet', 'markdownlint-cli' ]

  let b:neomake_markdown_markdownlint_maker = l:maker
endfunction
