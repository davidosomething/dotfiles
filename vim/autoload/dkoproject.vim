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

" ============================================================================
" Project root resolution
" ============================================================================

" Find git root of current file, set to buffer var
"
" @param {String} [file]
" @return {String} project root path or empty string
function! dkoproject#GetRoot(...) abort
  if exists('b:dkoproject_root')
    return b:dkoproject_root
  endif

  let l:path = dkoproject#GetRootPath(a:000)
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

" @param {String} [a:1] optional file for which you want the project root
" @return {String} path to project root
function! dkoproject#GetRootPath(...) abort
  " Argument
  " Path for given file
  let l:path = empty(a:1) ? '' : fnamemodify(resolve(expand(a:1)), ':p:h')

  " Fallback to current file if no argument
  " Try current file's path
  let l:path = empty(l:path) && filereadable(expand('%'))
        \ ? expand('%:p:h')
        \ : l:path

  " Fallback if no current file
  " File was not readable so just use current path buffer started from
  let l:path = empty(l:path)
        \ ? getcwd()
        \ : l:path

  " Special circumstances
  " Go up one level if INSIDE the .git/ dir
  let l:path = fnamemodify(l:path, ':t') ==# '.git'
        \ ? fnamemodify(l:path, ':p:h:h')
        \ : l:path

  return l:path
endfunction

" @param {String} path
" @return {String} git root of file or empty string
function! dkoproject#GetGitRootByFile(path) abort
  let l:std = split(
        \ system('cd ' . a:path . ' && git rev-parse --show-toplevel 2>/dev/null'),
        \ '\n'
        \ )
  return v:shell_error || empty(l:std) ? '' : l:std[0]
endfunction

" @param {String[]} markers
" @return {String} root path based on presence of file marker
function! dkoproject#GetRootByFileMarker(markers) abort
  let l:result = ''
  for l:marker in a:markers
    " Try to use nearest first; findfile .; goes from current file upwards
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

" Get full path to a dir in a dkoproject
"
" @param {String} dirname
" @return {String} full path to dir
function! dkoproject#GetDir(dirname) abort
  if empty(dkoproject#GetRoot())
    return ''
  endif

  for l:root in dkoproject#GetPaths()
    let l:current =
          \ expand(dkoproject#GetRoot() . '/' . l:root)

    if !isdirectory(l:current)
      continue
    endif

    if isdirectory(glob(l:current . a:dirname))
      return l:current . a:dirname
    endif
  endfor

  return ''
endfunction

" Get full path to a file in a dkoproject
"
" @param {String} filename
" @return {String} full path to config file
function! dkoproject#GetFile(filename) abort
  " Try to use nearest first; findfile .; goes from current file upwards
  let l:nearest = findfile(a:filename, '.;')
  if !empty(l:nearest)
    return fnamemodify(l:nearest, ':p')
  endif

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

" Get bin local to project
"
" @param {String} bin path relative to project root
" @return {String}
function! dkoproject#GetBin(bin) abort
  if empty(a:bin)
    return ''
  endif

  " Use cached
  let l:bins = dko#InitDict('b:dkoproject_bin')
  if !empty(get(l:bins, a:bin))
    return l:bins[a:bin]
  endif

  let l:exe = dkoproject#GetFile(a:bin)
  if !empty(l:exe) && executable(l:exe)
    let l:bins[a:bin] = l:exe
    return l:exe
  endif
  return ''
endfunction

" Ordered by preference
let s:eslintrc_candidates = [
      \   '.eslintrc.js',
      \   '.eslintrc.yaml',
      \   '.eslintrc.yml',
      \   '.eslintrc.json',
      \   '.eslintrc',
      \ ]
" GetFile looks upwards from current file first, then into project roots
" for eslintrc_candidates in order
" @TODO support package.json configs
" @return {String} eslintrc filename
function! dkoproject#GetEslintrc() abort
  let l:candidates = map(copy(s:eslintrc_candidates), 'dkoproject#GetFile(v:val)')
  return call('dko#First', l:candidates)
endfunction

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
