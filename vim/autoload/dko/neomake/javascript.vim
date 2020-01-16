" autoload/dko/neomake/javascript.vim

" For 'javascript' and 'javascriptreact'
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
  " Configure makers to run using NPX and from the cwd
  " ==========================================================================

  call dko#InitList('b:neomake_javascript_enabled_makers')

  let b:dko_is_javascript_xo = get(b:, 'PJ_file') && pj#HasDevDependency('xo')
  let b:dko_jshintrc = dko#project#GetFile('.jshintrc')
  let b:dko_is_javascript_jshint = !empty(b:dko_jshintrc)

  " Conditionally define these rarely used linters
  if b:dko_is_javascript_xo
    call dko#neomake#NpxMaker(extend(
          \   neomake#makers#ft#javascript#xo(), {
          \     'ft': 'javascript',
          \     'maker': 'xo',
          \     'cwd': dko#project#GetRoot(),
          \   }))
    let b:neomake_javascript_enabled_makers += [ 'xo' ]
  elseif b:dko_is_javascript_jshint
    call dko#neomake#NpxMaker(extend(
          \   neomake#makers#ft#javascript#jshint(), {
          \     'ft': 'javascript',
          \     'maker': 'jshint',
          \     'cwd': dko#project#GetRoot(),
          \   }))
    let b:neomake_javascript_enabled_makers += [ 'jshint' ]
  else
    " Flag for autoload/dko/lint.vim to use coc-eslint
    let b:dko_is_coc = 1
  endif

  let b:neomake_javascriptreact_enabled_makers =
        \ b:neomake_javascript_enabled_makers
endfunction
