" plugin/fzf.vim

augroup dkofzf
  autocmd!
augroup END

if !dkoplug#IsLoaded('fzf.vim') | finish | endif

autocmd dkofzf FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd dkofzf BufLeave <buffer> set laststatus=2 showmode ruler

" ============================================================================
" fzf.vim settings
" ============================================================================

" iTerm can pipe from a spawned FZF back to Vim
if !has('nvim') && $TERM_PROGRAM ==# 'iTerm.app'
  let g:fzf_launcher = g:dko#vim_dir . '/bin/vim-fzf'
endif

let g:fzf_command_prefix = 'FZF'

let g:fzf_layout = { 'down': '~40%' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
" [Files]
"let g:fzf_files_options = '--something...'
" [Commands]

" ============================================================================
" Mappings
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions&vim

" junegunn/fzf mappings for the neovim :term
" Bind <fx> to abort FZF (<C-g> is one of the default abort keys in FZF)
" @see #f-keys
function! s:MapCloseFzf() abort
  if !has('nvim') | return | endif

  tnoremap <buffer><special> <F1> <C-g>
  tnoremap <buffer><special> <F2> <C-g>
  tnoremap <buffer><special> <F3> <C-g>
  tnoremap <buffer><special> <F4> <C-g>
  tnoremap <buffer><special> <F5> <C-g>
  tnoremap <buffer><special> <F6> <C-g>
  tnoremap <buffer><special> <F7> <C-g>
  tnoremap <buffer><special> <F8> <C-g>
  tnoremap <buffer><special> <F9> <C-g>
  tnoremap <buffer><special> <F10> <C-g>
  tnoremap <buffer><special> <F11> <C-g>
  tnoremap <buffer><special> <F12> <C-g>
endfunction
autocmd dkofzf FileType fzf call s:MapCloseFzf()

" Map the commands -- the actual plugin is loaded by a vim-plug 'on' hook when
" a command is run for the first time
execute dko#MapAll({ 'key': '<F1>', 'command': 'FZFGrepper' })
nnoremap  <silent><special>   <A-g>   :<C-U>FZFGrepper<CR>

execute dko#MapAll({ 'key': '<F2>', 'command': 'FZFRelevant' })
nnoremap  <silent><special>   <A-r>   :<C-U>FZFRelevant<CR>

execute dko#MapAll({ 'key': '<F3>', 'command': 'FZFProject' })
nnoremap  <silent><special>   <A-p>   :<C-U>FZFProject<CR>

execute dko#MapAll({ 'key': '<F4>', 'command': 'FZFMRU' })
nnoremap  <silent><special>   <A-m>   :<C-U>FZFMRU<CR>
" autocmd dkofzf VimEnter *
"      \   if dkoplug#IsLoaded('redismru.vim')
"      \|    execute dko#MapAll({ 'key': '<F4>', 'command': 'FZFRedisMRU' })
"      \|    nnoremap  <silent><special>   <A-m>   :<C-U>FZFRedisMRU<CR>
"      \|  endif

execute dko#MapAll({ 'key': '<F5>', 'command': 'FZFFiles' })
nnoremap  <silent><special>   <A-f>   :<C-U>FZFFiles<CR>

" Start using meta mappings since I hate the Macbook touchbar
nnoremap  <silent><special>   <A-b>   :<C-U>FZFBuffers<CR>
nnoremap  <silent><special>   <A-c>   :<C-U>FZFCommands<CR>
nnoremap  <silent><special>   <A-t>   :<C-U>FZFTests<CR>
nnoremap  <silent><special>   <A-v>   :<C-U>FZFVim<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
