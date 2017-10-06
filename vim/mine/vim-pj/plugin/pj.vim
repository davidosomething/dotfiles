" package.json integration
"
" Options:
"
" g:PJ_enabled
"   - (default) 0 disable vim-pj on start, enable manually using :PjEnable
"   - 1 enable vim-pj for each buffer that is opened
"
" g:PJ_function
"   - (default) undefined to use default logic (findfile)
"   - a funcref to a function that returns the path of package.json, e.g.
"     integrate with vim-rooter or some other plugin
"   - a path to package.json (relative to the buffer's path, or absolute)
"

" ============================================================================
" Reset
" ============================================================================

augroup plugin-vimpj
  autocmd!
augroup END

" ============================================================================
" Main
" ============================================================================

" Auto-enable pj on buffers and re-read on editing package.json
function! s:Init() abort
  if !exists('*json_decode')
    "echoerr 'vim-pj requires json_decode() functionality'
    return
  endif

  augroup plugin-vimpj
    autocmd!

    " Start pj for the buffer
    autocmd BufNewFile,BufRead * call s:InitBuffer()

    " Re-decode package.json when edited
    autocmd BufWritePost
          \ package.json
          \ call pj#Invalidate(expand('%:p')) | call pj#GetJson()

  augroup END
endfunction

" Default package.json locator. Not used if g:PJ_function is set
function! s:FindPackageJson() abort
  return fnamemodify(findfile('package.json'), ':p')
endfunction

" Enable pj commands for a buffer
function! s:InitBuffer() abort
  if (&buftype !=# '') || &diff || &previewwindow || exists('b:fugitive_type')
    return
  endif

  let b:PJ_file = pj#GetPackageJsonPath(
        \ get(g:, 'PJ_function', function('s:FindPackageJson'))
        \ )
  if empty(b:PJ_file) | return | endif

  " --------------------------------------------------------------------------
  " Provide commands to this buffer since it has a valid package.json
  " --------------------------------------------------------------------------

  " Complex logic commands
  command! -buffer PjEdit   call pj#commands#Edit()
  command! -buffer PjReadme call pj#commands#Readme()
  command! -buffer PjReload call pj#commands#Reload()

  " Simple URL openers
  command! -buffer PjBugs   call pj#commands#OpenUrl(pj#GetValue('bugs', 'url'))
  command! -buffer PjHome   call pj#commands#OpenUrl(pj#GetValue('homepage'))
  command! -buffer PjRepo   call pj#commands#OpenUrl(pj#GetValue('repository', 'url'))
  command! -buffer -complete=customlist,pj#commands#CompleteRun -nargs=1
        \ PjRun
        \ call pj#commands#Run('<args>')
endfunction

" ============================================================================
" Init
" ============================================================================

" Hash of package.json paths to decoded JSON objects in vim dict format
" e.g. { '~/.project/package.json': { json } }
" This saves us from having to json_decode again and store multiple instances
" of the same package.json in memory
if get(g:, 'PJ_enabled', 0)
  " Set b:PJ_file for all new buffers
  call s:Init()
endif

" Call this to re-read g:PJ_function and the package.json for the current
" file, too.
command! PjEnable call s:Init() | call s:InitBuffer()
