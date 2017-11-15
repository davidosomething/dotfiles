" autoload/dko/neomake/javascript.vim

" Hook for BufWinEnter *
" Sets b:neomake_javascript_enabled_makers based on what is present in the
" project
" Uses pj#HasDevDependency so runs after &filetype is set (by filetypedetect,
" shebang, or modeline)
function! dko#neomake#javascript#Setup() abort
  let l:safeft = neomake#utils#get_ft_confname(&filetype)
  if exists('b:did_dkoneomake_' . l:safeft) | return | endif
  let b:did_dkoneomake_{l:safeft} = 1

  " ==========================================================================
  " Configure NPX to run makers
  " ==========================================================================

  call dko#neomake#NpxMaker(extend(
        \   neomake#makers#ft#javascript#eslint(), {
        \     'ft': 'javascript',
        \     'maker': 'eslint',
        \     'when': '!empty(dko#project#javascript#GetEslintrc())',
        \   }))

  call dko#neomake#NpxMaker(extend(
        \   neomake#makers#ft#javascript#xo(), {
        \     'ft': 'javascript',
        \     'maker': 'xo',
        \     'when': 'get(b:, "PJ_file") && pj#HasDevDependency("xo")',
        \   }))

  call dko#neomake#NpxMaker(extend(
        \   neomake#makers#ft#javascript#jshint(), {
        \     'ft': 'javascript',
        \     'maker': 'jshint',
        \     'when': 'empty(dko#project#javascript#GetEslintrc()) '
        \             . ' && !empty(dko#project#GetFile(".jshintrc"))',
        \   }))

  " flow disabled
  " args overridden from defaults -- allow limiting returned entries
  " call dko#neomake#NpxMaker(extend(
  "       \   neomake#makers#ft#javascript#flow(), {
  "       \     'ft': 'javascript',
  "       \     'maker': 'flow',
  "       \     'args': [ '--from=vim' ],
  "       \     'when': '!empty(dko#project#GetFile(".flowconfig"))',
  "       \   }))

  " ==========================================================================
  " Define which makers should be used
  " ==========================================================================

  call dko#InitList('b:neomake_javascript_enabled_makers')

  if expand('%:p:t') ==# '.eslintrc.js'
    " Skip linting .eslintrc.js
    return
  elseif !empty(dko#project#javascript#GetEslintrc())
    let b:neomake_javascript_enabled_makers += [ 'eslint' ]
  elseif !empty(dko#project#GetFile('.jshintrc'))
    let b:neomake_javascript_enabled_makers += [ 'jshint' ]
  elseif get(b:, 'PJ_file') && pj#HasDevDependency('xo')
    let b:neomake_javascript_enabled_makers += [ 'xo' ]
  endif

  " flow disabled
  " if !empty(dko#project#GetFile('.flowconfig'))
  "   let b:neomake_javascript_enabled_makers += [ 'flow' ]
  " endif
endfunction
