if !dkoplug#plugins#IsLoaded('neomake') | finish | endif

let g:dkoproject#neomake#scss#local_sasslint = {
      \   'ft':     'scss',
      \   'maker':  'sasslint',
      \   'exe':    'node_modules/.bin/sass-lint',
      \ }

let s:sasslint_default = glob(expand('$DOTFILES/sasslint/dot.sass-lint.yml'))
function! dkoproject#neomake#scss#Sasslint() abort
  let l:config = dkoproject#GetFile('.sass-lint.yml')
  let l:config = empty(l:config) ? s:sasslint_default : l:config
  let b:neomake_scss_sasslint_args = neomake#GetMaker('sasslint', 'scss').args
        \ + ['--config=' . l:config]
endfunction

function! dkoproject#neomake#scss#SetMaker() abort
  if empty(dkoproject#GetFile('.scss-lint.yml')) | return | endif

  " Only if scss-lint is executable (globally or locally)
  if !dkoproject#neomake#IsMakerExecutable('scsslint') | return | endif

  " Remove sasslint from enabled makers, use only scsslint
  let b:neomake_scss_enabled_makers = filter(
        \   copy(get(b:, 'neomake_scss_enabled_makers', [])),
        \   "v:val !~? 'sasslint'"
        \ )
endfunction
