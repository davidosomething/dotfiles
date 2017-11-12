" autoload/dko/neomake/scss.vim

if !dko#plug#IsLoaded('neomake') | finish | endif

" sass-lint only looks upwards; use dko#project#GetFile to look inwards
let s:sasslint_default = glob(expand('$DOTFILES/sasslint/dot.sass-lint.yml'))
function! dko#neomake#scss#Setup() abort
  call dko#neomake#NpxMaker(extend(neomake#makers#ft#scss#sasslint(), {
        \     'ft': 'scss',
        \     'maker': 'sasslint',
        \     'npx': 'sass-lint',
        \   }))

  let l:config = dko#project#GetFile('.sass-lint.yml')
  let l:config = empty(l:config) ? s:sasslint_default : l:config
  let b:neomake_scss_sasslint_args =
        \ dko#BorG(
        \   'neomake_scss_sasslint_args',
        \   neomake#GetMaker('sasslint', 'scss').args
        \ ) + [ '--config=' . l:config ]
endfunction
