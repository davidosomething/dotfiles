" package.json integration
"
" Options:
"
" g:PJ_enabled
"   - 0 disable vim-pj on start, enable manually using :PjEnable
"   - 1 enable vim-pj for each buffer that is opened
"
" g:PJ_function
"   - undefined to use default logic (findfile)
"   - a funcref to a function that returns the path of package.json, e.g.
"     integrate with vim-rooter or some other plugin
"   - a path to package.json (relative to the buffer's path, or absolute)
"

" ============================================================================
" My settings
" @TODO extract to settings plugin/
" ============================================================================

" Wrapper function to provide funcref for autoload function
"
" @return {String}
function! g:DKO_FindPackageJson() abort
  return dkoproject#GetFile('package.json')
endfunction
let g:PJ_function = function('g:DKO_FindPackageJson')

" ============================================================================
" Reset
" ============================================================================

augroup vimpj
  autocmd!
augroup END

" ============================================================================
" Helpers
" ============================================================================

" Default package.json locator. Not used if g:PJ_function is set
function! s:FindPackageJson() abort
  return fnamemodify(findfile('package.json'), ':p')
endfunction

" @param {String} url to open
function! s:OpenUrl(url) abort
  if empty(a:url)
    return
  endif

  if has('unix') && executable('xdg-open')
    " https://github.com/vim/vim/blob/890680ca6364386fabb271c85e0755bcaa6a33c1/runtime/autoload/netrw.vim#L5132
    execute 'silent !xdg-open ' . shellescape(a:url, 1)

  elseif has('macunix') && executable('open')
    " https://github.com/vim/vim/blob/890680ca6364386fabb271c85e0755bcaa6a33c1/runtime/autoload/netrw.vim#L5144
    execute 'silent !open ' . shellescape(a:url, 1)

  elseif has('win32unix') && executable('start')
    execute 'silent !start rundll32 url.dll,FileProtocolHandler '
          \. shellescape(a:url, 1)
  endif
endfunction

" ============================================================================
" Commands and their wildmenu completions
" ============================================================================

" Edit the package.json file
" @TODO support options for opening in same window, or new tab or horizontally
"       split window
function! s:CommandEdit() abort
  execute 'vsplit ' . b:PJ_file
endfunction

" Edit the package's main file
function! s:CommandMain() abort
  let l:main = pj#GetValue('main')
  if empty(l:main)
    return
  endif
  execute 'vsplit ' . l:main
endfunction

" Open the package's readme.md in browser
" @TODO if not a URL then edit it
function! s:CommandReadme() abort
  call s:OpenUrl(pj#GetValue('readme'))
endfunction

" Forget the previous package.json data and reload it
function! s:CommandReload() abort
  call pj#Invalidate()
  call pj#GetJson()
endfunction

" Completion for :PjRun
function! s:CompleteRun(arglead, cmdline, pos) abort
  return keys(pj#GetValue('scripts'))
endfunction

" @param {String} name of script to run
" @return {Dict} command results
function! s:CommandRun(name) abort
  if !executable('node') || !executable('npm')
    echoerr 'Vim could not access node and/or npm.'
  endif

  let l:command = 'npm run ' . a:name

  if has('nvim')
    execute 'split | terminal ' . l:command
    return
  endif

  " @TODO -- delegate to Neomake#Sh or dispatch... too lazy to write out
  if exists('*neomake#Sh')
    return neomake#Sh(l:command, function('s:OpenQf'))
  endif

  return {}
endfunction

function! s:OpenQf(...) abort
  copen
endfunction

" ============================================================================
" Main
" ============================================================================

" Auto-enable pj on buffers and re-read on editing package.json
function! s:Init() abort
  if !exists('*json_decode')
    "echoerr 'vim-pj requires json_decode() functionality'
    return
  endif

  augroup vimpj
    autocmd!

    " Start pj for the buffer
    autocmd BufNewFile,BufRead * call s:InitBuffer()

    " Re-decode package.json when edited
    autocmd BufWritePost
          \ package.json
          \ call pj#Invalidate(expand('%:p')) | call pj#GetJson()

  augroup END
endfunction

" Enable pj commands for a buffer
function! s:InitBuffer() abort
  if (&buftype !=# '') || &diff || &previewwindow || exists('b:fugitive_type')
    return
  endif

  let b:PJ_file = pj#GetPackageJsonPath(
        \ get(g:, 'PJ_function', function('s:FindPackageJson'))
        \ )
  if empty(b:PJ_file)
    return
  endif

  " --------------------------------------------------------------------------
  " Provide commands to this buffer since it has a valid package.json
  " --------------------------------------------------------------------------

  " Complex logic commands
  command! -buffer PjEdit   call s:CommandEdit()
  command! -buffer PjReadme call s:CommandReadme()
  command! -buffer PjReload call s:CommandReload()

  " Simple URL openers
  command! -buffer PjBugs   call s:OpenUrl(pj#GetValue('bugs', 'url'))
  command! -buffer PjHome   call s:OpenUrl(pj#GetValue('homepage'))
  command! -buffer PjRepo   call s:OpenUrl(pj#GetValue('repository', 'url'))
  command! -buffer -complete=customlist,s:CompleteRun -nargs=1
        \ PjRun
        \ call s:CommandRun('<args>')
endfunction

" ============================================================================
" Init
" ============================================================================

" Hash of package.json paths to decoded JSON objects in vim dict format
" e.g. { '~/.project/package.json': { json } }
" This saves us from having to json_decode again and store multiple instances
" of the same package.json in memory
if get(g:, 'PJ_enabled', 1)
  " Set b:PJ_file for all new buffers
  call s:Init()
endif

" Call this to re-read g:PJ_function and the package.json for the current
" file, too.
command! PjEnable call s:Init()

