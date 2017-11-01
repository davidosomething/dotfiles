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

function! s:Disable(maker) abort
  " Remove eslint from enabled makers, use only jshint
  let b:neomake_javascript_enabled_makers = filter(
        \   b:neomake_javascript_enabled_makers,
        \   "v:val !~? '" . a:maker . "'"
        \ )
endfunction

function! s:GetEslintArgs() abort
  return copy(get(g:, 'neomake_javascript_eslint_args',
        \ neomake#GetMaker('eslint', 'javascript').args))
endfunction

" Sets b:neomake_javascript_enabled_makers based on what is present in the
" project
function! dkoproject#neomake#javascript#SetMaker() abort
  let b:neomake_javascript_enabled_makers =
        \ copy(g:neomake_javascript_enabled_makers)

  " Find an eslintrc in current project. If not found use jshint
  if empty(dkoproject#GetEslintrc())
    call s:Disable('eslint')
  else
    let b:neomake_javascript_eslint_args = s:GetEslintArgs() + [
          \   '-c', dkoproject#GetEslintrc()
          \ ]
  endif
endfunction
