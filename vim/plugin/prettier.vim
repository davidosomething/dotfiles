" plugin/prettier.vim
"
" Use prettier node module as gq to format JavaScript
"

augroup dkoprettier
  autocmd!
  autocmd FileType javascript call g:OverrideFormatter()
augroup END

function! g:OverrideFormatter() abort
  let l:candidates = [
        \   dkoproject#GetBin('node_modules/.bin/prettier-eslint'),
        \   dkoproject#GetBin('node_modules/.bin/prettier'),
        \   executable('prettier-eslint') ? 'prettier-eslint' : '',
        \   executable('prettier') ? 'prettier' : '',
        \ ]

  let l:bin = call('dko#First', l:candidates)
  if !empty(l:bin)
    execute 'setlocal formatprg=' . l:bin . '\ --stdin'
  endif

  return l:bin
endfunction
