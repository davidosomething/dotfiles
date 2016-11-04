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
" Helpers
" ============================================================================

function! s:FindPackageJson() abort
  return fnamemodify(findfile('package.json'), ':p')
endfunction

" Get a value from the buffer's decoded package.json dict
"
" @param {String} ... keys to get, e.g. ('repository', 'url')
" @return {Mixed} empty dict if not found
function! s:GetValue(...) abort
  if !exists('b:PJ_file')
    echoerr 'This buffer has no package.json path in b:PJ_file.'
    return {}
  endif

  let l:hash = get(s:jsons, b:PJ_file, {})
  if empty(l:hash)
    echoerr 'The package.json filepath for this buffer does not correspond to a decoded file.'
    return {}
  endif

  " There must be a better way to deep traverse an object...
  let l:result = l:hash
  for l:deep_key in a:000
    " Requested more keys than there were available
    if type(l:result) !=# 4
      return {}
    endif

    let l:result = get(l:result, l:deep_key, {})
    if empty(l:result)
      return {}
    endif
  endfor
  return l:result
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

" Edit the package's main file
function! s:CommandMain() abort
  let l:main = s:GetValue('main')
  if empty(l:main)
    return
  endif
  execute 'vsplit ' . l:main
endfunction

" Open the package's readme.md in browser
" @TODO if not a URL then edit it
function! s:CommandReadme() abort
  call s:OpenUrl(s:GetValue('readme'))
endfunction

" Edit the package.json file
" @TODO support options for opening in same window, or new tab or horizontally
"       split window
function! s:CommandEdit() abort
  execute 'vsplit ' . b:PJ_file
endfunction

" Completion for :PjRun
function! s:CompleteRun(arglead, cmdline, pos) abort
  return keys(s:GetValue('scripts'))
endfunction

" @param {String} name of script to run
function! s:CommandRun(name) abort
  if  !executable('node') || !executable('npm')
    echoerr 'Vim could not access node and/or npm.'
  endif

  " @TODO -- delegate to Neomake#Sh or dispatch... too lazy to write out
  echom 'npm run ' . a:name
endfunction

" ============================================================================
" Main
" ============================================================================

function! s:Main() abort
  if !exists('*json_decode')
    echoerr 'vim-pj requires json_decode() functionality'
    return
  endif

  let s:PJ_function = get(g:, 'PJ_function', function('s:FindPackageJson'))

  " Use PJ_function if string, call if funcref
  let l:path =
        \   type(s:PJ_function) ==# 1 ? s:PJ_function
        \ : type(s:PJ_function) ==# 2 ? s:PJ_function()
        \ : ''
  if empty(l:path)
    return
  endif

  if !filereadable(l:path)
    echoerr 'Could not read package.json at ' . l:path
  endif

  " Expose only if file was found
  let b:PJ_file = l:path

  " Decode file contents and remember for this session
  let l:text = readfile(l:path)
  let s:jsons[l:path] = json_decode(l:text)

  " --------------------------------------------------------------------------
  " Provide commands to this buffer since it has a valid package.json
  " --------------------------------------------------------------------------

  " Complex logic commands
  command! -buffer PjEdit   call s:CommandEdit()
  command! -buffer PjReadme call s:CommandReadme()

  " Simple URL openers
  command! -buffer PjBugs   call s:OpenUrl(s:GetValue('bugs', 'url'))
  command! -buffer PjHome   call s:OpenUrl(s:GetValue('homepage'))
  command! -buffer PjRepo   call s:OpenUrl(s:GetValue('repository', 'url'))
  command! -buffer -complete=customlist,s:CompleteRun -nargs=1
        \ PjRun
        \ call s:CommandRun('<args>')

endfunction

" ============================================================================
" Init
" ============================================================================

augroup vimpj
  autocmd!
augroup END

" Hash of package.json paths to decoded JSON objects in vim dict format
" e.g. { '~/.project/package.json': { json } }
" This saves us from having to json_decode again and store multiple instances
" of the same package.json in memory
let s:jsons = {}
if get(g:, 'PJ_enabled', 1)
  autocmd vimpj BufNewFile,BufRead  *   call s:Main()
endif

" Call this to re-read g:PJ_function and the package.json for the current
" file, too.
command! PjEnable call s:Main()

