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

" Auto-enable pj on buffers and re-read on editing package.json
if !exists('*json_decode') || !v:version == 800 | finish | endif

" ============================================================================
" Reset
" ============================================================================

augroup plugin-vimpj
  autocmd!
augroup END

" ============================================================================
" Main
" ============================================================================

" Default package.json locator. Not used if g:PJ_function is set
"
" @return {string}
function! s:FindPackageJson() abort
  if empty(expand('%')) | return '' | endif
  return fnamemodify(findfile('package.json', expand('%:p:h') . ';'), ':p')
endfunction

" Enable pj commands for a buffer
function! s:InitBuffer() abort
  if &diff || &previewwindow || &buftype !=# ''
        \ || get(b:, 'PJ_file')
        \ || get(b:, 'fugitive_type')
    return
  endif

  let l:pj_file = pj#GetPackageJsonPath(
        \ get(g:, 'PJ_function', function('s:FindPackageJson'))
        \ )
  if empty(l:pj_file) | return | endif
  let b:PJ_file = l:pj_file

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

command! PjEnable call s:InitBuffer()

" Start pj for the buffer. Done super early to provide info to other
" plugins like neomake. Not dependent on FileType, just a cwd
autocmd plugin-vimpj BufNewFile,BufReadPre,BufWritePost,BufFilePost *
      \ call s:InitBuffer()

" Re-decode package.json when edited
autocmd plugin-vimpj BufWritePost package.json
      \   call pj#Invalidate(expand('%:p'))
      \ | call pj#GetJson()
