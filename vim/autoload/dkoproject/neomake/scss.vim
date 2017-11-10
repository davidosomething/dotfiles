if !dkoplug#plugins#IsLoaded('neomake') | finish | endif

" sass-lint only looks upwards; use dkoproject#GetFile to look inwards
let s:sasslint_default = glob(expand('$DOTFILES/sasslint/dot.sass-lint.yml'))
function! dkoproject#neomake#scss#Setup() abort
  call dkoproject#neomake#NpxMaker(extend(neomake#makers#ft#scss#sasslint(), {
        \     'ft': 'scss',
        \     'maker': 'sasslint',
        \     'npx': 'sass-lint',
        \   }))

  let l:config = dkoproject#GetFile('.sass-lint.yml')
  let l:config = empty(l:config) ? s:sasslint_default : l:config
  let b:neomake_scss_sasslint_args =
        \ dko#BorG(
        \   'neomake_scss_sasslint_args',
        \   neomake#GetMaker('sasslint', 'scss').args
        \ ) + [ '--config=' . l:config ]
endfunction
