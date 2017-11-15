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
  let b:dkoproject_javascript_eslintrc =
        \ get(b:, 'dkoproject_javascript_eslintrc',
        \   dko#project#GetCandidate(s:eslintrc_candidates))
  return b:dkoproject_javascript_eslintrc
endfunction
