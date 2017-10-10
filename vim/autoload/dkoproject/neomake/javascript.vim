if !dkoplug#plugins#IsLoaded('neomake') | finish | endif

let g:dkoproject#neomake#javascript#local_eslint = {
      \   'ft':    'javascript',
      \   'maker': 'eslint',
      \   'exe':   'node_modules/.bin/eslint',
      \   'when':  '!empty(dkoproject#GetEslintrc())',
      \ }

let g:dkoproject#neomake#javascript#local_jshint = {
      \   'ft':     'javascript',
      \   'maker':  'jshint',
      \   'exe':    'node_modules/.bin/jshint',
      \   'when':   'empty(dkoproject#GetEslintrc()) '
      \             . ' && !empty(dkoproject#GetFile(".jshintrc"))',
      \ }

let g:dkoproject#neomake#javascript#local_flow = {
      \   'ft':           'javascript',
      \   'maker':        'flow',
      \   'exe':          'node_modules/.bin/flow',
      \   'args':         ['--from=vim', '--show-all-errors'],
      \   'errorformat':  '%EFile "%f"\, line %l\, characters %c-%m,'
      \                   . '%trror: File "%f"\, line %l\, characters %c-%m,'
      \                   . '%C%m,%Z%m',
      \   'postprocess':  function('neomake#makers#ft#javascript#FlowProcess'),
      \   'when':         '!empty(dkoproject#GetFile(".flowconfig"))',
      \ }

" Sets b:neomake_javascript_enabled_makers based on what is present in the
" project
function! dkoproject#neomake#javascript#SetMaker() abort
  " Find an eslintrc in current project. If not found use jshint
  if !empty(dkoproject#GetEslintrc())
    let l:eslint_maker = neomake#GetMaker('eslint', 'javascript')
    let l:eslint_args = get(
          \ g:, 'neomake_javascript_eslint_args',
          \ l:eslint_maker.args)
    let b:neomake_javascript_eslint_args =
          \ l:eslint_args + [ '-c', dkoproject#GetEslintrc() ]

    " Use global eslint if local one wasn't added to b:
    if executable('eslint')
          \ && exists('b:neomake_javascript_enabled_makers')
          \ && index(b:neomake_javascript_enabled_makers, 'eslint') == -1
      call add(b:neomake_javascript_enabled_makers, 'eslint')
    endif

  " This project uses jshint instead of eslint, disable eslint (and flow)
  elseif exists('b:neomake_javascript_enabled_makers')
        \ && dkoproject#neomake#IsMakerExecutable('jshint')
        \ && !empty(dkoproject#GetFile('.jshintrc'))
    " Remove eslint from enabled makers, use only jshint
    let b:neomake_javascript_enabled_makers = filter(
          \   b:neomake_javascript_enabled_makers,
          \   "v:val !~? 'eslint'"
          \ )
  endif
endfunction
