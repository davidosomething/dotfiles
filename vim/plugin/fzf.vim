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

function! s:FzfGitModified()
  let l:root = exists('b:dkoproject_root')
        \ ? dkoproject#GetRoot(b:dkoproject_root)
        \ : dkoproject#GetRoot()
    call fzf#run(fzf#wrap({
          \     'source':   'git ls-files -m',
          \     'dir':      l:root,
          \     'options':  s:options . ' --prompt="Git[+]> "',
          \     'down':     10,
          \   }))
endfunction
command! FZFModified call s:FzfGitModified()

" ----------------------------------------------------------------------------
" My vim runtime
" ----------------------------------------------------------------------------

command! FZFVim
      \ call fzf#run(fzf#wrap({
      \   'source':   split(globpath(dko#vim_dir, "{after,autoload,ftplugin,plugin,syntax}/**/*.vim"), "\n"),
      \   'options':  s:options . ' --prompt="Vim> "',
      \   'down':     10,
      \ }))

" ----------------------------------------------------------------------------
" Whitelisted MRU/Buffer combined
" Regular MRU doesn't blacklist files
" ----------------------------------------------------------------------------

function! s:GetFzmSource() abort
  return extend(dko#GetMru(), dko#GetBuffers())
endfunction

command! FZFMRU
      \ call fzf#run(fzf#wrap({
      \   'source':  s:GetFzmSource(),
      \   'options': s:options . ' --no-sort --prompt="MRU> "',
      \   'down':    10,
      \ }))

