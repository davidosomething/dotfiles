" ============================================================================
" DKO Project
"
" Helpers to finds config files for a project (e.g. linting RC files) relative
" to a git repo root.
"
" Similar to what this plugin does, but using a single system call to `git`
" instead of using `expand()` with `:h` to traverse up directories.
" https://github.com/dbakker/vim-projectroot/blob/master/autoload/projectroot.vim
"
" Settings:
" b:dko_project_roots [array] - look for config files in this array of
"                              directory names relative to the project
"                              root if it is set
" g:dko_project_roots [array] - global overrides
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Default Settings
" ============================================================================

" Look for project config files in these paths
let s:default_roots = [
      \   '',
      \ ]

" @param {mixed} { bufnr } or number/string bufnr
" @return {Number|String| bufnr
function! s:BufnrFromArgs(...) abort
  if a:0
    return type(a:1) == type(0) || type(a:1) == type('')
          \ ? a:1
          \ : type(a:1) == type({}) && a:1['bufnr']
          \ ? a:1['bufnr']
          \ : '%'
  endif
  return '%'
endfunction

" Mark buffer -- set up buffer local variables or update a buffer's meta data
function! dko#project#MarkBuffer(...) abort
  let l:bufnr = s:BufnrFromArgs(a:000)
  let b:dko_project_root = ''
  call dko#project#GetRoot(l:bufnr) " force reset
endfunction

" ============================================================================
" Project root resolution
" ============================================================================

" Buffer-cached project root, prefer based on file markers
"
" @param {String} [file] from which to look upwards
" @return {String} project root path or empty string
function! dko#project#GetRoot(...) abort
  let l:bufnr = s:BufnrFromArgs(a:000)
  if empty(getbufvar(l:bufnr, 'dko_project_root', ''))
    let l:existing = getbufvar(l:bufnr, 'dko_project_root')
    if !empty(l:existing) | return l:existing | endif

    " Look for markers FIRST, that way we support things like browsing through
    " node_modules/ and monorepos
    let l:root = v:lua.require('dko/project/init').get_root_by_patterns()

    " Try git root
    let l:path = dko#project#GetFilePath(get(a:, 1, ''))
    let l:gitroot = v:lua.require('dko.project').git_root(l:path)
    if !empty(l:gitroot)
      call setbufvar(l:bufnr, 'dko_project_gitroot', l:gitroot)
      if empty(l:root) | let l:root = l:gitroot | endif
    endif

    call setbufvar(l:bufnr, 'dko_project_root', l:root)
  endif
  return getbufvar(l:bufnr, 'dko_project_root', '')
endfunction

" @return {Boolean} if gitroot and project root differ
function! dko#project#IsMonorepo() abort
  if empty(dko#project#GetRoot()) | return 0 | endif
  return b:dko_project_root !=# get(b:, 'dko_project_gitroot', '')
endfunction

" @param {String} file to get path to
" @return {String} path to project root
function! dko#project#GetFilePath(file) abort
  " Argument
  " Path for given file
  let l:path = get(a:, 'file')
        \ ? fnamemodify(resolve(expand(a:file)), ':p:h')
        \ : ''

  " Fallback to current file if no argument
  " Try current file's path
  let l:path = empty(l:path) && filereadable(expand('%'))
        \ ? expand('%:p:h')
        \ : l:path

  " Fallback if no current file
  " File was not readable so just use current path buffer started from
  let l:path = empty(l:path) ? getcwd() : l:path

  " Special circumstances
  " Go up one level if INSIDE the .git/ dir
  let l:path = fnamemodify(l:path, ':t') ==# '.git'
        \ ? fnamemodify(l:path, ':p:h:h')
        \ : l:path

  return l:path
endfunction

" @param {String[]} markers
" @return {String} root path based on presence of file marker
function! dko#project#GetRootByFileMarker(markers) abort
  let l:result = ''
  for l:marker in a:markers
    " Try to use nearest first; findfile .; goes from current file upwards
    let l:filepath = findfile(l:marker, '.;')
    if empty(l:filepath) | continue | endif
    let l:result = fnamemodify(resolve(expand(l:filepath)), ':p:h')
  endfor
  return l:result
endfunction

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
