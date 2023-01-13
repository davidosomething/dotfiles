" autoload/dko/project/javascript.vim

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
  let l:found = ''

  if !exists('b:dko_project_javascript_eslintrc')
    let l:found = dko#project#GetCandidate(s:eslintrc_candidates)
    if !empty(l:found)
      let b:dko_project_javascript_eslintrc = fnamemodify(l:found, ':p')
    endif
  endif

  " Check in package.json
  if empty(l:found)
    if exists('*pj#GetValue') && len(pj#GetValue('eslintConfig'))
      let b:dko_project_javascript_eslintrc = b:PJ_file
    else
      let l:packagejson = dko#project#GetFile('package.json')
      if !empty(l:packagejson)
        let l:eslint_config =
              \ system('grep eslintConfig ' . shellescape(l:packagejson))
        if !empty(l:eslint_config)
          let b:dko_project_javascript_eslintrc = l:packagejson
        endif
      endif
    endif
  endif

  return get(b:, 'dko_project_javascript_eslintrc', '')
endfunction
