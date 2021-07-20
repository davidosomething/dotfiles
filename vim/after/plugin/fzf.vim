" after/plugin/fzf.vim

augroup dkofzf
  autocmd!
augroup END

if !dkoplug#IsLoaded('fzf.vim') | finish | endif

autocmd dkofzf FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd dkofzf BufLeave <buffer> set laststatus=2 showmode ruler

" ============================================================================
" Local Helpers
" ============================================================================

" fzf#run() can't use autoload function in options so wrap it with
" a script-local
"
" @return {String} project root
function! s:GetRoot() abort
  return dko#project#GetRoot()
endfunction

" @return {String} tests dir
function! s:GetTests() abort
  return dko#project#GetDir('tests')
endfunction

" ============================================================================
" Custom sources for junegunn/fzf
" ============================================================================

" Notes:
" - Use fzf#wrap() instead of 'sink' option to get the <C-T/V/X> keybindings
"   when the source is to open files

" Some default options.
" --cycle through list
" --multi select with <Tab>
let s:options = ' --tiebreak=index --cycle --multi --keep-right '

function s:WithLayout(opts) abort
  return extend(copy(a:opts), g:fzf_layout)
endfunction

" ----------------------------------------------------------------------------
" git relevant
" ----------------------------------------------------------------------------

function! s:FzfRelevant(...) abort
  let l:path = dko#git#GetRoot(expand('%:p:h'))
  if empty(l:path)
    echo 'Not a git repository'
    return
  endif

  let l:base_index = index(a:000, '--branch')
  let l:base = l:base_index >= 0 ? a:000[l:base_index + 1] : 'master'
  let l:prompt = l:base . '::' . dko#git#GetBranch(l:path)

  let l:filepaths = dko#git#GetRelevant(l:path, a:000)
  let l:source =  filter(
        \   l:filepaths,
        \   "filereadable(l:path . '/' .v:val)"
        \ )
  if !len(l:source)
    echo 'No files changed compared to ' . l:base
    return
  endif
  call fzf#run(fzf#wrap('Relevant',
        \   fzf#vim#with_preview(s:WithLayout({
        \     'dir':      l:path,
        \     'source':   l:source,
        \     'options':  s:options . ' --prompt="' . l:prompt . '> "',
        \   }), 'right:50%')
        \ ))
endfunction

" List relevant and don't include anything .gitignored
" Accepts args for `git-relevant`
command! -nargs=* FZFRelevant call s:FzfRelevant(<f-args>)

" ----------------------------------------------------------------------------
" My vim runtime files
" ----------------------------------------------------------------------------

" @return {List} my files in my vim runtime
function! s:GetFzfVimSource() abort
  " Want these recomputed every time in case files are added/removed
  let l:runtime_dirs_files = globpath(g:dko#vim_dir, '{' . join([
        \   'after',
        \   'autoload',
        \   'colors',
        \   'ftplugin',
        \   'mine',
        \   'plugin',
        \   'snippets',
        \   'syntax',
        \ ], ',') . '}/**/*.vim', 0, 1)
  let l:runtime_files = globpath(g:dko#vim_dir, '*.vim', 0, 1)
  let l:rcfiles = globpath(g:dko#vim_dir, '*vimrc', 0, 1)
  return l:runtime_dirs_files + l:runtime_files + l:rcfiles
endfunction

command! FZFVim
      \ call fzf#run(fzf#wrap('Vim',
      \   fzf#vim#with_preview(s:WithLayout({
      \     'dir':      s:GetRoot(),
      \     'source':   s:GetFzfVimSource(),
      \     'options':  s:options . ' --prompt="Vim> "',
      \   }), 'right:50%')
      \ ))

" ----------------------------------------------------------------------------
" Whitelisted MRU/Buffer combined.
" Regular :FZFHistory doesn't blacklist files
" ----------------------------------------------------------------------------

" @return {String} project root
command! FZFMRU
      \ call fzf#run(fzf#wrap('MRU',
      \   fzf#vim#with_preview(s:WithLayout({
      \     'source':  dko#files#GetMru(),
      \     'options': s:options . ' --no-sort --prompt="MRU> "',
      \   }), 'right:50%')
      \ ))

" ----------------------------------------------------------------------------
" Test specs
" ----------------------------------------------------------------------------

command! FZFTests
      \ call fzf#run(fzf#wrap('Tests',
      \   fzf#vim#with_preview(s:WithLayout({
      \     'source':   dko#tests#FindTests(),
      \     'options':  s:options . ' --prompt="Tests> "',
      \   }), 'right:50%')
      \ ))

" ============================================================================
" Custom commands for fzf.vim
" ============================================================================

" ----------------------------------------------------------------------------
" FZFGrepper
" fzf.vim ripgrep or ag with preview
" Fallback to git-grep if rg and ag not installed (e.g. I'm ssh'ed somewhere)
" https://github.com/junegunn/fzf.vim#advanced-customization
" ----------------------------------------------------------------------------

" FZFGrepper! settings
let s:grepper_full = fzf#vim#with_preview(
      \   { 'dir': s:GetRoot() },
      \   'up:60%'
      \ )

" FZFGrepper settings
let s:grepper_half = fzf#vim#with_preview(
      \   { 'dir': s:GetRoot() },
      \   'right:50%',
      \   '?'
      \ )

if dko#grepper#Get().command ==# 'rg'
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'rg --color=always --column --line-number --no-heading '
        \     . '--hidden --smart-case '
        \     . '--no-ignore-vcs '
        \     . '--ignore-file "${DOTFILES}/ag/dot.ignore" '
        \     . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
elseif dko#grepper#Get().command ==# 'ag'
  " https://github.com/junegunn/fzf.vim/blob/abdf894edf5dbbe8eaa734a6a4dce39c9f174e33/autoload/fzf/vim.vim#L614
  " Default options are --nogroup --column --color
  let s:ag_options = ' --skip-vcs-ignores --smart-case '

  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#ag(
        \   <q-args>,
        \   s:ag_options,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
else
  command! -bang -nargs=* FZFGrepper
        \ call fzf#vim#grep(
        \   'git grep --line-number ' . shellescape(<q-args>),
        \   1,
        \   <bang>0 ? s:grepper_full : s:grepper_half,
        \   <bang>0
        \ )
endif

" ----------------------------------------------------------------------------
" Files from project root
" ----------------------------------------------------------------------------

" FZFProject! settings
let s:project_full = fzf#vim#with_preview(
      \   {},
      \   'up:60%'
      \ )

" FZFProject settings
let s:project_half = fzf#vim#with_preview(
      \   {},
      \   'right:50%',
      \   '?'
      \ )

command! -bang FZFProject
      \ call fzf#vim#files(
      \   s:GetRoot(),
      \   <bang>0 ? s:project_full : s:project_half,
      \   <bang>0
      \ )

" ============================================================================
" Mappings
" ============================================================================

let s:cpo_save = &cpoptions
set cpoptions&vim

nnoremap  <silent><special>   <A-b>   :<C-U>FZFBuffers<CR>
nnoremap  <silent><special>   <A-c>   :<C-U>FZFCommands<CR>
nnoremap  <silent><special>   <A-f>   :<C-U>FZFFiles<CR>
nnoremap  <silent><special>   <A-g>   :<C-U>FZFGrepper<CR>
nnoremap  <silent><special>   <A-m>   :<C-U>FZFMRU<CR>
nnoremap  <silent><special>   <A-p>   :<C-U>FZFProject<CR>
nnoremap  <silent><special>   <A-r>   :<C-U>FZFRelevant<CR>
nnoremap  <silent><special>   <A-t>   :<C-U>FZFTests<CR>
nnoremap  <silent><special>   <A-v>   :<C-U>FZFVim<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
