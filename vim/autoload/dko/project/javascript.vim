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

" @return {String} .eslintrc* filepath
function! dko#project#javascript#GetEslintrc() abort
  if !exists('b:dko_project_javascript_eslintrc')
    let l:found = dko#project#GetCandidate(s:eslintrc_candidates)
    if !empty(l:found)
      let b:dko_project_javascript_eslintrc = fnamemodify(l:found, ':p')
    endif
  endif
  return get(b:, 'dko_project_javascript_eslintrc', '')
endfunction

" @return {String} .tern-project file path
function! dko#project#javascript#GetTernProject() abort
  if !exists('b:dko_project_javascript_ternproject')
    let l:found = dko#project#GetCandidate(['.tern-project'])
    if !empty(l:found)
      let b:dko_project_javascript_ternproject = fnamemodify(l:found, ':p')
    endif
  endif
  return get(b:, 'dko_project_javascript_ternproject', '')
endfunction
