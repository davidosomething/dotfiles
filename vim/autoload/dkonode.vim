" autoload/dkonode.vim
"
" nvm and node related
"

" @return {string} cached default node directory or 0
function! dkonode#Default() abort
  let s:default = get(s:, 'default')
  if s:default == 0
    let s:default = expand('$NVM_DIR/versions/node/v$DKO_DEFAULT_NODE_VERSION')
    let s:default = isdirectory(s:default) ? s:default : ''
  endif
  return s:default
endfunction

" @return {string} cached default node package directory or 0
function! dkonode#Packages() abort
  let s:packages = get(s:, 'packages')
  if s:packages == 0
    let l:package_dir = !empty(dkonode#Default())
          \ ? dkonode#Default() . '/lib/node_modules'
          \ : ''
    let s:packages = isdirectory(l:package_dir) ? l:package_dir : ''
  endif
  return s:packages
endfunction

" @param {string} package name
" @return {string|int} package directory or 0
function! dkonode#Package(package) abort
  let l:package_dir = dkonode#Packages() . '/' . a:package
  return isdirectory(l:package_dir) ? l:package_dir : ''
endfunction
