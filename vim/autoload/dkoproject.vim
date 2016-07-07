" ============================================================================
" DKO Project
"
" Helpers to finds config files for a project (e.g. linting RC files) relative
" to a git repo root.
"
" Settings:
" b:dkoproject_config_paths - highest precendence array to look in
" g:dkoproject_config_paths - next highest
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
  "echomsg 'Finding root'
  if exists('b:dkoproject_root')
    "echomsg 'Cached ' . b:dkoproject_root
    return b:dkoproject_root
  endif

  if !empty(a:0)
    " path for given file
    "echomsg 'Using file provided in arg ' . a:0
    let l:path = expand(fnamemodify(a:0, ':p:h'))
  elseif filereadable(expand('%'))
    "echomsg 'Using opened file ' . expand('%')
    " path for current file
    let l:path = expand('%:p:h')
  else
    let l:path = getcwd()
  endif
  "echomsg 'Got filepath: ' . l:path

  " Determine if git root exists (empty string on error, strip last newline)
  execute 'lcd! "' . l:path . '"'
  let l:result = system('git rev-parse --show-toplevel 2>/dev/null')[:-2]
  lcd! -

  " No git root?
  let l:root = empty(l:result) ? '' : l:result
  if !isdirectory(l:root)
    return ''
  endif

  " Found git root
  let b:dkoproject_root = l:root
  return l:root
endfunction

" ============================================================================
" For all windows, change path to project root
function! dkoproject#CdProjectRoot() abort
  if empty(dkoproject#GetProjectRoot())
    echoerr 'Not a git project'
    return
  endif
  execute 'cd! ' . dkoproject#GetProjectRoot()
endfunction

" ============================================================================
" Get array of config paths for a project
" @return {String[]} config paths relative to git root
function! dkoproject#GetConfigPaths() abort
  if exists('b:dkoproject_config_paths')
    return b:dkoproject_config_paths
  elseif exists('g:dkoproject_config_paths')
    return g:dkoproject_config_paths
  endif
  return s:default_config_paths
endfunction

" ============================================================================
" Get config file full path, looks in b:dkoproject_root
" @return {String} full path to config file
function! dkoproject#GetProjectConfigFile(filename) abort
  if empty(dkoproject#GetProjectRoot())
    return ''
  endif

  let l:config_paths = dkoproject#GetConfigPaths()

  for l:config_path in l:config_paths
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
" Get JS linters based on rc file presence
" Currently not used, see plugin/plug-neomake.vim
" @return {String[]} list of linter names
function! dkoproject#JsLinters() abort
  if exists('b:dko_js_linters')
    return b:dko_js_linters
  endif

  let b:dko_js_linters = ['eslint']

  " Can definitely DRY this up...
  let l:jshintrc = dkoproject#GetProjectConfigFile('.jshintrc')
  if !empty(l:jshintrc)
    let b:dko_js_linters += ['jshint']
  endif

  return b:dko_js_linters
endfunction

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save

