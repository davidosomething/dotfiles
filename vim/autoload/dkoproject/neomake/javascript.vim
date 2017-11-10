" autoload/dkoproject/neomake/javascript.vim

if !dkoplug#plugins#IsLoaded('neomake') | finish | endif

" Sets b:neomake_javascript_enabled_makers based on what is present in the
" project
function! dkoproject#neomake#javascript#Setup() abort
  call dkoproject#neomake#NpxMaker(extend(
        \   neomake#makers#ft#javascript#eslint(), {
        \     'ft': 'javascript',
        \     'maker': 'eslint',
        \     'when': '!empty(dkoproject#GetEslintrc())',
        \   }))

  call dkoproject#neomake#NpxMaker(extend(
        \   neomake#makers#ft#javascript#jshint(), {
        \     'ft': 'javascript',
        \     'maker': 'jshint',
        \     'when': 'empty(dkoproject#GetEslintrc()) '
        \             . ' && !empty(dkoproject#GetFile(".jshintrc"))',
        \   }))

  call dkoproject#neomake#NpxMaker(extend(
        \   neomake#makers#ft#javascript#flow(), {
        \     'ft': 'javascript',
        \     'maker': 'flow',
        \     'when': '!empty(dkoproject#GetFile(".flowconfig"))',
        \   }))

  let b:neomake_javascript_enabled_makers = []
  if !empty(dkoproject#GetEslintrc())
    let b:neomake_javascript_enabled_makers += [ 'eslint' ]
  elseif !empty(dkoproject#GetFile('.jshintrc'))
    let b:neomake_javascript_enabled_makers += [ 'jshint' ]
  endif
  if !empty(dkoproject#GetFile('.flowconfig'))
    let b:neomake_javascript_enabled_makers += [ 'flow' ]
  endif
endfunction
