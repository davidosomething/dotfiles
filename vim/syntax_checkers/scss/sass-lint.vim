if exists('g:loaded_syntastic_scss_sass_lint_checker')
  finish
endif
let g:loaded_syntastic_scss_sass_lint_checker = 1

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_scss_sass_lint_GetLocList() dict
  " Use eslint compact format
  let makeprg = self.makeprgBuild({ 'args_before': '-v -f compact' })

  let errorformat =
        \ '%E%f: line %l\, col %c\, Error - %m,' .
        \ '%W%f: line %l\, col %c\, Warning - %m'

  let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'returns': [0, 1, 2, 65, 66] })

  return loclist
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \ 'filetype': 'scss',
      \ 'name': 'sass_lint',
      \ 'exec': 'sass-lint' })

let &cpo = s:save_cpo
unlet s:save_cpo

