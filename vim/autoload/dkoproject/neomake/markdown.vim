if !dkoplug#plugins#IsLoaded('neomake') | finish | endif

let s:markdownlint_default = glob(expand('$DOTFILES/markdownlint/config.json'))
function! dkoproject#neomake#markdown#Markdownlint() abort
  let l:maker = { 'errorformat':  '%f: %l: %m' }

  " Use markdownlint in local node_modules/ if available
  let l:bin = 'node_modules/.bin/markdownlint'
  let l:maker.exe = !empty(l:bin) ? 'markdownlint' : l:bin
  if !executable(l:maker.exe) | return | endif

  " Use config local to project if available
  let l:config = dkoproject#GetMarkdownlintrc()
  let l:config = empty(l:config) ? s:markdownlint_default : l:config
  let l:maker.args = empty(l:config) ? [] : ['--config', l:config]

  let b:neomake_markdown_markdownlint_args = l:maker.args
  let b:neomake_markdown_markdownlint_maker = l:maker
endfunction
