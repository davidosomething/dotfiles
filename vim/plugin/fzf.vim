" plugin/fzf.vim
scriptencoding utf-8
if !dko#IsPlugged('fzf.vim') | finish | endif

augroup dkofzf
  autocmd!

  " Bind <fx> to abort FZF (<C-g> is one of the default abort keys in FZF)
  " @see #f-keys
  autocmd FileType fzf tnoremap <buffer><special> <F1> <C-g>
  autocmd FileType fzf tnoremap <buffer><special> <F2> <C-g>
  autocmd FileType fzf tnoremap <buffer><special> <F3> <C-g>
  autocmd FileType fzf tnoremap <buffer><special> <F4> <C-g>
  autocmd FileType fzf tnoremap <buffer><special> <F5> <C-g>
  autocmd FileType fzf tnoremap <buffer><special> <F8> <C-g>
augroup END

let g:fzf_command_prefix = 'FZF'

let g:fzf_layout = { 'down': '10' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

execute dko#MapAll({ 'key': '<F1>', 'command': 'FZFBuffers' })
execute dko#MapAll({ 'key': '<F2>', 'command': 'FZFModified' })
execute dko#MapAll({ 'key': '<F3>', 'command': 'FZFMRU' })
execute dko#MapAll({ 'key': '<F4>', 'command': 'FZFFiles' })
execute dko#MapAll({ 'key': '<F5>', 'command': 'FZFAg' })

execute dko#MapAll({ 'key': '<F8>', 'command': 'FZFColors' })

" ============================================================================
" My custom sources
" ============================================================================
"
" Notes:
" - Use fzf#wrap() instead of 'sink' option to get the <C-T/V/X> keybindings
"   when the source is to open files
"

" Some default options. Removed --ansi for now, not using it
" cycle through list
" multi select with <Tab>
let s:options = ' --cycle --multi '

" #f-keys
" Not sure if these are working -- function keys. In FZF 0.15.7 it used to
" read the escape code (^[ and then the function keysym) so it would be the
" same as hitting escape to close FZF (and the garbage characters), but
" in 0.15.8 it stopped working.
" @see https://github.com/neovim/neovim/issues/4343
" @see https://github.com/junegunn/fzf/issues/741
" let s:bindings = join([
"       \   'f1:abort',
"       \   'f2:abort',
"       \   'f3:abort',
"       \   'f4:abort',
"       \   'f5:abort',
"       \   'f6:abort',
"       \   'f7:abort',
"       \   'f8:abort',
"       \ ], ',')
" let s:bind = ' --bind ' . s:bindings
" let s:options .= s:bind


" ----------------------------------------------------------------------------
" git modified
" ----------------------------------------------------------------------------

" Unused, see note above command
function! s:GetFzfGitModifiedRoot() abort
  return exists('b:dkoproject_root')
        \ ? dkoproject#GetRoot(b:dkoproject_root)
        \ : dkoproject#GetRoot()
endfunction

" @return {String[]} list of shortened filepaths that are modified or staged
function! s:GetFzfGitModifiedSource() abort
  let l:modified = system('git ls-files --modified --others --exclude-standard')
  let l:modified = v:shell_error ? [] : split(l:modified, '\n')

  let l:staged   = system('git diff --cached --name-only')
  let l:staged   = v:shell_error ? [] : split(l:staged, '\n')

  let l:unmerged   = system('git diff master --name-only')
  let l:unmerged   = v:shell_error ? [] : split(l:unmerged, '\n')

  let l:result  = dko#Unique(l:modified + l:staged + l:unmerged)
  return dko#ShortPaths(l:result)
endfunction

" Handle expected <c-*> bindings for :FZFModified
" This is essentially what fzf#wrap() does
"
" @TODO really support --multi
" @param {String[]} lines
function! s:FzfGitModifiedSink(lines) abort
  if len(a:lines) < 1 | return | endif

  let l:list = a:lines[1:]
  let l:file = l:list[0]

  let l:cmd = get({
        \   'ctrl-x': 'split',
        \   'ctrl-v': 'vertical split',
        \   'ctrl-t': 'tabe',
        \ }, a:lines[0], 'e')
  execute l:cmd escape(l:file, ' %#\')
endfunction

" List modified, untracked, and don't include anything .gitignored
" @FIXME ideally I'd like to use `dir`, instead of `sink` but it has problems
"         resolving the file such that it appears empty until running `:edit`
"         on the empty buffer to force a re-read.
"         Also fzf#wrap is not running on this one so can bind the --expect
"         manually.
"\   'dir':      s:GetFzfGitModifiedRoot(),
command! FZFModified call fzf#run({
      \   'source':   s:GetFzfGitModifiedSource(),
      \   'sink*':    function('s:FzfGitModifiedSink'),
      \   'options':  ' --cycle --expect=ctrl-t,ctrl-v,ctrl-x --prompt="G[+]> "',
      \   'down':     10,
      \ })

" ----------------------------------------------------------------------------
" My vim runtime
" ----------------------------------------------------------------------------

" @return {List} my files in my vim runtime
function! s:GetFzfVimSource() abort
  " Want these recomputed every time in case files are added/removed
  let l:runtime_dirs_files = globpath(g:dko#vim_dir, '{' . join([
        \   'after',
        \   'autoload',
        \   'ftplugin',
        \   'plugin',
        \   'snippets',
        \   'syntax',
        \ ], ',') . '}/**/*.vim', 0, 1)
  let l:runtime_files = globpath(g:dko#vim_dir, '*.vim', 0, 1)
  let l:rcfiles = globpath(g:dko#vim_dir, '*vimrc', 0, 1)
  return dko#ShortPaths( l:runtime_dirs_files + l:runtime_files + l:rcfiles )
endfunction

command! FZFVim
      \ call fzf#run(fzf#wrap('Vim', {
      \   'source':   s:GetFzfVimSource(),
      \   'options':  s:options . ' --prompt="Vim> "',
      \   'down':     10,
      \ }))

" ----------------------------------------------------------------------------
" Whitelisted MRU/Buffer combined
" Regular MRU doesn't blacklist files
" ----------------------------------------------------------------------------

" @return {List} recently used filenames and buffers
function! s:GetFzfMruSource() abort
  return uniq(dko#GetMru() + dko#GetBuffers())
endfunction

command! FZFMRU
      \ call fzf#run(fzf#wrap('MRU', {
      \   'source':  s:GetFzfMruSource(),
      \   'options': s:options . ' --no-sort --prompt="MRU> "',
      \   'down':    10,
      \ }))

