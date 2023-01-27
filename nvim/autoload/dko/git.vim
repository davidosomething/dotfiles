" ============================================================================
" Git helpers
" ============================================================================

" Get git root
"
" @param {string} [path] to run in
" @return {string} git root
function! dko#git#GetRoot(...) abort
  let l:path = a:0 && type(a:1) == type('') ? a:1 : ''
  let l:cmd = 'git rev-parse --show-toplevel 2>/dev/null'
  let l:result = split(
        \ ( empty(l:path)
        \   ? system(l:cmd)
        \   : system('cd -- "' . l:path . '" && ' . l:cmd)
        \ ), '\n')
  if v:shell_error | return '' | endif
  return len(l:result) ? l:result[0] : ''
endfunction

" Get git branch
"
" @param {string} [path] to run in
" @return {string} current branch name
function! dko#git#GetBranch(...) abort
  let l:path = a:0 && type(a:1) == type('') ? a:1 : ''
  let l:cmd = 'git rev-parse --abbrev-ref HEAD 2>/dev/null'
  let l:result = split(
        \ ( empty(l:path)
        \   ? system(l:cmd)
        \   : system('cd -- "' . l:path . '" && ' . l:cmd)
        \ ), '\n')
  if v:shell_error | return '' | endif
  return len(l:result) ? l:result[0] : ''
endfunction

" @param {String[]}
" @return {String[]} list of relative files that are in git status
function! dko#git#GetStatusFiles() abort
  let l:cmd = system('git status --porcelain | cut -c4-')
  if v:shell_error | return [] | endif
  return split(l:cmd, '\n')
endfunction

" Depends on my `git-relevant` script, see:
" https://github.com/davidosomething/dotfiles/blob/master/bin/git-relevant
" Alternatively use git-extras' `git-delta` (though it doesn't get unstaged
" files)
"
" @param {String[]} args first should be git root path, rest are passed to
"   git-relevant, e.g. `--branch somebranch`
" @return {String[]} list of shortfilepaths that are relevant to the branch
function! dko#git#GetRelevant(...) abort
  let l:args = get(a:, '000', [])
  let l:path = len(l:args) ? l:args[0] : dko#git#GetRoot(expand('%:p:h'))
  let l:cmd_args = len(l:args) > 1 ? join(l:args[1], ' ') : ''
  let l:cmd = 'git relevant ' . l:cmd_args
  let l:relevant = system('cd -- "' . l:path . '" && ' . l:cmd)
  if v:shell_error | return [] | endif
  return split(l:relevant, '\n')
endfunction
