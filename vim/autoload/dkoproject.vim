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

" Look for project root using these file markers if not a git project
let s:default_markers = [
      \   'package.json',
      \   'composer.json',
      \   'requirements.txt',
      \   'Gemfile',
      \ ]

" Find git root of current file, set to buffer var
"
" @param {String} [file]
" @return {String} project git root path or empty string
function! dkoproject#GetRoot(...) abort
  if exists('b:dkoproject_root')
    return b:dkoproject_root
  endif

  " Get root for a specific file
  if !empty(a:0)
    " path for given file
    let l:path = fnamemodify(resolve(expand(a:0)), ':p:h')
  elseif filereadable(expand('%'))
    " path for current file
    let l:path = expand('%:p:h')
  else
    let l:path = getcwd()
  endif

  let l:root = dkoproject#GetGitRootByFile(l:path)
  let l:root = empty(l:root)
        \ ? dkoproject#GetRootByFileMarker(s:default_markers)
        \ : l:root
  let l:root = empty(l:root)
        \ ? expand('%:p:h')
        \ : l:root

  let b:dkoproject_root = l:root
  return l:root
endfunction

" @param {String} filepath
" @return {String} git root of file or empty string
function! dkoproject#GetGitRootByFile(filepath) abort
  let l:result = split(system(
        \   'cd ' . a:filepath . ' && git rev-parse --show-toplevel'
        \ ), '\n')[0]
  return v:shell_error ? '' : l:result
endfunction

" @param {String[]} markers
" @return {String} root path based on presence of file marker
function! dkoproject#GetRootByFileMarker(markers) abort
  let l:result = ''
  for l:marker in a:markers
    let l:filepath = findfile(l:marker, '.;')
    if empty(l:filepath)
      continue
    endif
    let l:result = fnamemodify(resolve(expand(l:filepath)), ':h')
  endfor

  return l:result
endfunction

" Get array of possible config file paths for a project -- any dirs where
" files like .eslintrc, package.json, etc. might be stored. These will be
" paths relative to the root from dkoproject#GetRoot
"
" @return {String[]} config paths relative to dkoproject#GetRoot
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

" @TODO support package.json configs
" @return {String} eslintrc filename
function! dkoproject#GetEslintrc() abort
  let l:candidates = [
        \   '.eslintrc.js',
        \   '.eslintrc.yaml',
        \   '.eslintrc.yml',
        \   '.eslintrc.json',
        \   '.eslintrc',
        \ ]

  let l:result = ''
  for l:candidate in l:candidates
    if empty(dkoproject#GetFile(l:candidate))
      continue
    endif
    let l:result = l:candidate
  endfor

  return l:result
endfunction

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
