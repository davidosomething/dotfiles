" autoload/dko/neomake/javascript.vim

if !dkoplug#IsLoaded('neomake') | finish | endif

" Hook for BufWinEnter *
" Sets b:neomake_javascript_enabled_makers based on what is present in the
" project
" Uses pj#HasDevDependency so runs after &filetype is set (by filetypedetect,
" shebang, or modeline)
function! dko#neomake#javascript#Setup() abort
  if &filetype !=# 'javascript' | return | endif

  " ==========================================================================
  " Configure NPX to run makers
  " ==========================================================================

  call dko#neomake#NpxMaker(extend(
        \   neomake#makers#ft#javascript#eslint(), {
        \     'ft': 'javascript',
        \     'maker': 'eslint',
        \     'when': '!empty(dko#project#GetEslintrc())',
        \   }))

  call dko#neomake#NpxMaker(extend(
        \   neomake#makers#ft#javascript#xo(), {
        \     'ft': 'javascript',
        \     'maker': 'xo',
        \     'when': 'pj#HasDevDependency("xo")',
        \   }))

  call dko#neomake#NpxMaker(extend(
        \   neomake#makers#ft#javascript#jshint(), {
        \     'ft': 'javascript',
        \     'maker': 'jshint',
        \     'when': 'empty(dko#project#GetEslintrc()) '
        \             . ' && !empty(dko#project#GetFile(".jshintrc"))',
        \   }))

  call dko#neomake#NpxMaker(extend(
        \   neomake#makers#ft#javascript#flow(), {
        \     'ft': 'javascript',
        \     'maker': 'flow',
        \     'when': '!empty(dko#project#GetFile(".flowconfig"))',
        \   }))

  " ==========================================================================
  " Define which makers should be used
  " ==========================================================================

  call dko#InitList('b:neomake_javascript_enabled_makers')

  if expand('%:p:t') ==# '.eslintrc.js'
    " Skip linting .eslintrc.js
    return
  elseif !empty(dko#project#GetEslintrc())
    let b:neomake_javascript_enabled_makers += [ 'eslint' ]
  elseif !empty(dko#project#GetFile('.jshintrc'))
    let b:neomake_javascript_enabled_makers += [ 'jshint' ]
  elseif pj#HasDevDependency('xo')
    let b:neomake_javascript_enabled_makers += [ 'xo' ]
  endif

  if !empty(dko#project#GetFile('.flowconfig'))
    let b:neomake_javascript_enabled_makers += [ 'flow' ]
  endif
endfunction
