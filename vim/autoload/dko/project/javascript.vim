" autoload/dko/project/javascript.vim

" @TODO support package.json configs

" Ordered by preference
let s:eslintrc_candidates = [
      \   '.eslintrc.js',
      \   '.eslintrc.yaml',
      \   '.eslintrc.yml',
      \   '.eslintrc.json',
      \   '.eslintrc',
      \ ]

" @return {String} eslintrc filename
function! dko#project#javascript#GetEslintrc() abort
  if !exists('b:dko_project_javascript_eslintrc')
    let b:dko_project_javascript_eslintrc =
          \ dko#project#GetCandidate(s:eslintrc_candidates)
  endif
  return b:dko_project_javascript_eslintrc
endfunction

let s:prettierrc_candidates = [
      \   '.prettierrc',
      \   '.prettierrc.yaml',
      \   '.prettierrc.yml',
      \   '.prettierrc.json',
      \   '.prettierrc.js',
      \   'prettier.config.js',
      \ ]

" @return {String} prettierrc filename
function! dko#project#javascript#GetPrettierrc() abort
  if !exists('b:dko_project_javascript_prettierrc')
    let b:dko_project_javascript_prettierrc =
          \ dko#project#GetCandidate(s:prettierrc_candidates)
    if empty(b:dko_project_javascript_prettierrc)
      let b:dko_project_javascript_prettierrc =
            \ expand('$DOTFILES/prettier/prettier.config.js')
    endif
  endif
  return b:dko_project_javascript_prettierrc
endfunction
