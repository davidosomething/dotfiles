" autoload/dko/neomake/less.vim

function! dko#neomake#less#Setup() abort
  let l:safeft = neomake#utils#get_ft_confname(&filetype)
  if exists('b:did_dkoneomake_' . l:safeft) | return | endif
  let b:did_dkoneomake_{l:safeft} = 1

  call dko#neomake#NpxMaker(extend(neomake#makers#ft#less#lessc(), {
        \     'ft': 'less',
        \     'maker': 'lessc',
        \     'npx': 'lessc',
        \   }))

  let b:neomake_less_lessc_args =
        \ dko#BorG(
        \   'neomake_less_lessc_args',
        \   neomake#GetMaker('lessc', 'less').args
        \ ) + [ '--include-path=..', '--lint', '--no-color' ]
endfunction
