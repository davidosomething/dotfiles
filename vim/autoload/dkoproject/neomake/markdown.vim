" autoload/dkoproject/neomake/markdown.vim

function! dkoproject#neomake#markdown#Setup() abort
  call dkoproject#neomake#NpxMaker(extend(
        \   neomake#makers#ft#markdown#markdownlint(), {
        \     'ft': 'markdown',
        \     'maker': 'markdownlint',
        \     'npx': 'markdownlint-cli',
        \   }))
endfunction
