" ============================================================================
" DKO Project
"
" Helpers to finds config files for a project (e.g. linting RC files) relative
" to a git repo root.
" Useful for syntastic settings.
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
" ============================================================================

" @return string root path
function! dkoproject#GetProjectRoot() abort
  if !filereadable(expand('%'))
    return ''
  endif

  if exists('b:dkoproject_root')
    return b:dkoproject_root
  endif

  cd! %:p:h
  let l:root  = systemlist('git rev-parse --show-toplevel')[0]
  cd! -
  if l:root ==? 'fatal: Not a git repository (or any of the parent directories): .git'
    return ''
  endif

  let b:dkoproject_root = l:root
  return l:root
endfunction


" ============================================================================
" Get array of config paths for a project
" ============================================================================

" @return array of string config paths relative to git root
function! dkoproject#GetConfigPaths() abort
  if exists('b:dkoproject_config_paths')
    return b:dkoproject_config_paths
  elseif exists('g:dkoproject_config_paths')
    return g:dkoproject_config_paths
  endif
  return s:default_config_paths
endfunction


" ============================================================================
" Get config file full path
" ============================================================================

" @return string full path to config file
function! dkoproject#GetProjectConfigFile(filename) abort
  if empty(dkoproject#GetProjectRoot())
    return ''
  endif

  let l:config_paths = dkoproject#GetConfigPaths()

  for l:config_path in l:config_paths
    let l:project_config_path = dkoproject#GetProjectRoot() . '/' . l:config_path

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
" Get JS linters based on rc file presence
" ============================================================================

" @return list of linter names
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

  let l:jscsrc = dkoproject#GetProjectConfigFile('.jscsrc')
  if !empty(l:jscsrc)
    "let b:dko_js_linters += ['jscs']
  endif

  return b:dko_js_linters
endfunction


let &cpoptions = s:cpo_save
unlet s:cpo_save

