" plugin/commitmsg.vim

" https://vi.stackexchange.com/questions/11892/populate-a-git-commit-template-with-variables
function! s:replace_tokens() abort
  let l:context = {
        \   'BRANCH': matchstr(system('git rev-parse --abbrev-ref HEAD'), '\p\+')
        \ }

  let l:lnum = nextnonblank(1)
  while l:lnum && l:lnum < line('$')
    call setline(
          \ l:lnum,
          \ substitute(
          \   getline(l:lnum), '\${\(\w\+\)}',
          \   '\=get(context, submatch(1), submatch(0))', 'g')
          \ )
    let l:lnum = nextnonblank(l:lnum + 1)
  endwhile
endfunction

augroup dkocommitmsg
  autocmd!
  autocmd BufRead COMMIT_EDITMSG call s:replace_tokens()
augroup END
