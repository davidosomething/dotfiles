" autoload/dko/project/javascript.vim

" Ordered by preference
let s:eslintrc_candidates = [
      \   '.eslintrc.js',
      \   '.eslintrc.yaml',
      \   '.eslintrc.yml',
      \   '.eslintrc.json',
      \   '.eslintrc',
      \ ]

" @TODO support package.json configs
" @return {String} eslintrc filename
function! dko#project#javascript#GetEslintrc() abort
  if !exists('b:dko_project_javascript_eslintrc')
    let b:dko_project_javascript_eslintrc =
          \ dko#project#GetCandidate(s:eslintrc_candidates)
  endif
  return b:dko_project_javascript_eslintrc
endfunction
