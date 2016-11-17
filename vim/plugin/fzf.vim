" plugin/fzf.vim
scriptencoding utf-8
if !dko#IsPlugged('fzf.vim') | finish | endif

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

" ansi colors even though I'm not using any right now...
" cycle through list
" multi select with <Tab>
let s:options = '--ansi --cycle --multi'

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

  let l:result  = l:modified + l:staged + l:unmerged
  let l:dedupe  = filter( copy(l:result),
        \ 'index(l:result, v:val, v:key + 1) == -1' )

  return dko#ShortPaths(l:dedupe)
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
      \   'options':  '--cycle --expect=ctrl-t,ctrl-v,ctrl-x --prompt="G[+]> "',
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

