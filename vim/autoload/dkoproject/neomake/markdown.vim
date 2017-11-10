" autoload/dkoproject/neomake/markdown.vim

if !dkoplug#plugins#IsLoaded('neomake') | finish | endif

function! dkoproject#neomake#markdown#Markdownlint() abort
  let l:maker = { 'errorformat': '%f: %l: %m' }

  " Use markdownlint in local node_modules/ if available
  let l:maker.exe = 'npx'
  if !executable(l:maker.exe) | return | endif

  " follows rc style traversal
  " https://www.npmjs.com/package/rc#standards
  "let l:config = dkoproject#GetMarkdownlintrc()
  let b:neomake_markdown_markdownlint_args = [ '--quiet', 'markdownlint-cli' ]
  let b:neomake_markdown_markdownlint_maker = l:maker
endfunction
