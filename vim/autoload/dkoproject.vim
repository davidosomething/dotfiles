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
" "Config Paths" are where rc files (e.g. linter configs) are stored, which
" may not necessarily be in the immediate Project Root (even though I wish
" they were).
"
" Settings:
" b:dkoproject_config_paths [array] - look for config files in this array of
"                                     directory names relative to the project
"                                     root if it is set
" g:dkoproject_config_paths [array] - global overrides
" ============================================================================

if exists('g:loaded_dkoproject')
  finish
endif
let g:loaded_dkoproject = 1

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Default Settings
" ============================================================================

" Look for project config files in these paths
let s:default_config_paths = [
      \   '',
      \   'config/',
      \ ]

" ============================================================================
" Find git root of current file, set to buffer var
" @param {string} [file]
" @return {string} project git root path or empty string
function! dkoproject#GetProjectRoot(...) abort
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

" ============================================================================
" Get array of config paths for a project
" @return {String[]} config paths relative to git root
function! dkoproject#GetConfigPaths() abort
  return get(
        \   b:, 'dkoproject_config_paths', get(
        \   g:, 'dkoproject_config_paths',
        \   s:default_config_paths
        \ ))
endfunction

" ============================================================================
" Get config file full path, looks in b:dkoproject_root
" @return {String} full path to config file
function! dkoproject#GetProjectConfigFile(filename) abort
  if empty(dkoproject#GetProjectRoot())
    return ''
  endif

  for l:config_path in dkoproject#GetConfigPaths()
    let l:project_config_path = dkoproject#GetProjectRoot()
          \ . '/' . l:config_path

    if !isdirectory(l:project_config_path)
      continue
    endif

    if filereadable(glob(l:project_config_path . a:filename))
      return l:project_config_path . a:filename
    endif
  endfor

  return ''
endfunction

" ============================================================================
" Assign project config path to a var
" @param {String} file relative path
" @param {String} var
function! dkoproject#AssignConfigPath(file, var) abort
  let l:file = dkoproject#GetProjectConfigFile(a:file)
  if !empty(l:file)
    let {a:var} = l:file
  else
    unlet! {a:var}
  endif
endfunction

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

