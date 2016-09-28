" ============================================================================
" DKO Project
"
" Helpers to finds config files for a project (e.g. linting RC files) relative
" to a git repo root.
"
" "Project Root" is essentially the git root (so doesn't properly support
" projects where the .git directory has been manually defined), or the cwd
" if there is no git root.
" Similar to what this plugin does, but using a single system call to `git`
" instead of using `expand()` with `:h` to traverse up directories.
" https://github.com/dbakker/vim-projectroot/blob/master/autoload/projectroot.vim
"
" Settings:
" b:dkoproject#roots [array] - look for config files in this array of
"                              directory names relative to the project
"                              root if it is set
" g:dkoproject#roots [array] - global overrides
" ============================================================================

if exists('g:loaded_dkoproject') | finish | endif
let g:loaded_dkoproject = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Default Settings
" ============================================================================

" Look for project config files in these paths
let s:default_roots = [
      \   '',
      \   'config/',
      \ ]

" Find git root of current file, set to buffer var
"
" @param {string} [file]
" @return {string} project git root path or empty string
function! dkoproject#GetRoot(...) abort
  if exists('b:dkoproject_root')
    return b:dkoproject_root
  endif

  if !empty(a:0)
    " path for given file
    let l:path = expand(fnamemodify(a:0, ':p:h'))
  elseif filereadable(expand('%'))
    " path for current file
    let l:path = expand('%:p:h')
  else
    let l:path = getcwd()
  endif

  " Determine if git root exists
  " (empty string on error, strip last newline)
  let l:result = system(
        \ 'cd ' . l:path . 
        \ ' && git rev-parse --show-toplevel 2>/dev/null')

  " No git root?
  let l:root = empty(l:result) ? '' : l:result[:-2]
  if !isdirectory(l:root)
    return ''
  endif

  " Found git root
  let b:dkoproject_root = l:root
  return l:root
endfunction

" Get array of possible config file paths for a project -- any dirs where
" files like .eslintrc, package.json, etc. might be stored
"
" @return {String[]} config paths relative to git root
function! dkoproject#GetPaths() abort
  return get(
        \   b:, 'dkoproject#roots', get(
        \   g:, 'dkoproject#roots',
        \   s:default_roots
        \ ))
endfunction

" Get full path to a file in a dkoproject
"
" @param {String} filename
" @return {String} full path to config file
function! dkoproject#GetFile(filename) abort
  if empty(dkoproject#GetRoot())
    return ''
  endif

  for l:root in dkoproject#GetPaths()
    let l:current =
          \ expand(dkoproject#GetRoot() . '/' . l:root)

    if !isdirectory(l:current)
      continue
    endif

    if filereadable(glob(l:current . a:filename))
      return l:current . a:filename
    endif
  endfor

  return ''
endfunction

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
