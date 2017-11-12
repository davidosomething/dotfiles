" autoload/dko/neomake/markdown.vim

function! dko#neomake#markdown#Setup() abort
  call dko#neomake#NpxMaker(extend(
        \   neomake#makers#ft#markdown#markdownlint(), {
        \     'ft': 'markdown',
        \     'maker': 'markdownlint',
        \     'npx': 'markdownlint-cli',
        \   }))
endfunction
