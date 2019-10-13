" autoload/dko/neomake/css.vim

function! dko#neomake#css#Setup() abort
  let l:safeft = neomake#utils#get_ft_confname(&filetype)
  if exists('b:did_dkoneomake_' . l:safeft) | return | endif
  let b:did_dkoneomake_{l:safeft} = 1

  call dko#neomake#NpxMaker(extend(neomake#makers#ft#css#stylelint(), {
        \     'ft': 'css',
        \     'maker': 'stylelint',
        \     'npx': 'stylelint',
        \     'cwd': dko#project#GetRoot(),
        \   }))

  " let l:config = dko#project#GetFile('.sass-lint.yml')
  " let l:config = empty(l:config) ? s:sasslint_default : l:config
  " let b:neomake_scss_sasslint_args =
  "      \ dko#BorG(
  "      \   'neomake_scss_sasslint_args',
  "      \   neomake#GetMaker('sasslint', 'scss').args
  "      \ ) + [ '--config=' . l:config ]
endfunction
