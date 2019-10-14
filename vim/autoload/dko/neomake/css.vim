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

  if dkoplug#IsLoaded('coc.nvim') && expand('%:t') =~# '.module.css'
    let b:dko_is_coc = 1
  endif
endfunction
