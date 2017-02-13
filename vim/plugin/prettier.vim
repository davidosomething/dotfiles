" plugin/prettier.vim
"
" Use prettier node module as gq to format JavaScript
"

" DISABLED FOR NOW
finish

augroup dkoprettier
  autocmd!
  autocmd FileType javascript call g:OverrideFormatter()
augroup END

function! g:OverrideFormatter() abort
  let l:bin_candidates = [
        \   dkoproject#GetBin('node_modules/.bin/prettier-eslint'),
        \   dkoproject#GetBin('node_modules/.bin/prettier'),
        \   executable('prettier-eslint') ? 'prettier-eslint' : '',
        \   executable('prettier') ? 'prettier' : '',
        \ ]
  let l:bin = call('dko#First', l:bin_candidates)
  if empty(l:bin)
    return
  endif

  let l:args =  [ '--stdin' ]
  let l:eslint = dkoproject#GetDir('node_modules/eslint') " Module, not bin
  if !empty(l:eslint)
    let l:args += [ '--eslintPath', l:eslint ]
  endif

  let l:eslintrc = dkoproject#GetEslintrc()
  if !empty(l:eslintrc)
    let l:args += [ '--eslintConfig', l:eslintrc ]
  endif

  let l:prettier = dkoproject#GetDir('node_modules/prettier') " Module, not bin
  if !empty(l:prettier)
    let l:args += [ '--prettierPath',  l:prettier ]
  endif

  let l:formatprg = escape(l:bin . ' ' . join(l:args, ' '), ' \')
  execute 'setlocal formatprg=' . l:formatprg
  return l:formatprg
endfunction
