" autoload/dko/neomake/scss.vim

" sass-lint only looks upwards; use dko#project#GetFile to look inwards
let s:sasslint_default = glob(expand('$DOTFILES/sasslint/dot.sass-lint.yml'))
function! dko#neomake#scss#Setup() abort
  let l:safeft = neomake#utils#get_ft_confname(&filetype)
  if exists('b:did_dkoneomake_' . l:safeft) | return | endif
  let b:did_dkoneomake_{l:safeft} = 1

  call dko#neomake#NpxMaker(extend(neomake#makers#ft#scss#sasslint(), {
        \     'ft': 'scss',
        \     'maker': 'sasslint',
        \     'npx': 'sass-lint',
        \     'cwd': dko#project#GetRoot(),
        \   }))

  let l:config = dko#project#GetFile('.sass-lint.yml')
  let l:config = empty(l:config) ? s:sasslint_default : l:config
  let b:neomake_scss_sasslint_args =
        \ dko#BorG(
        \   'neomake_scss_sasslint_args',
        \   neomake#GetMaker('sasslint', 'scss').args
        \ ) + [ '--config=' . l:config ]
endfunction
