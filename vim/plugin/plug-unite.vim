" after/plugin/plug-unite.vim
"
" This is an after plugin since it calls the unite# autoloaded functions.
" Those need to be available before calling.
"

" ============================================================================
" unite settings
" ============================================================================

if !exists("g:plugs['unite.vim']") | finish | endif

" candidates
let g:unite_source_grep_max_candidates = 300

" use ag for file_rec/async and unite grep
if executable('ag')
  let s:ag_opts =
        \ ' --vimgrep'
        " vimgrep does everything
        "\ ' --nocolor --nogroup' .
        "\ ' --numbers' .
        "\ ' --follow --smart-case --hidden'

  " Ignore wildignores too
  " https://github.com/gf3/dotfiles/blob/master/.vimrc#L564
  for s:i in split(&wildignore, ',')
    let s:i = substitute(s:i, '\*/\(.*\)/\*', '\1', 'g')
    let s:ag_opts = s:ag_opts .
          \ ' --ignore "' . substitute(s:i, '\*/\(.*\)/\*', '\1', 'g') . '"'
  endfor

  " This setting reverted so just providing --vimgrep no longer works
  " https://github.com/Shougo/unite.vim/issues/986#issuecomment-133950231
  let g:unite_source_rec_async_command  = [ 'ag',
        \ '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '' ]

  let g:unite_source_grep_command       = 'ag'
  let g:unite_source_grep_default_opts  = s:ag_opts
  let g:unite_source_grep_recursive_opt = ''
endif

" ============================================================================
" neomru settings
" ============================================================================

if exists("g:plugs['neomru.vim']")
  " Update cache every 5 minutes
  let g:neomru#update_interval = 300

  " Fewer files in mru
  let g:neomru#file_mru_limit = 200

  " A
  " Don't list directories
  let g:neomru#directory_mru_limit = 0
endif

" ============================================================================
" unite profiles
" ============================================================================

function! s:unite_profiles()

  " ----------------------------------------------------------------------
  " Default matcher settings
  " ----------------------------------------------------------------------

  " Always fuzzy (e.g. abc matches app/book/collection)
  call unite#filters#matcher_default#use([
        \   'matcher_fuzzy',
        \   'matcher_hide_current_file',
        \ ])

  " ----------------------------------------------------------------------
  " Default sorter settings
  " ----------------------------------------------------------------------

  " Rank matches (slower) but more accurate finding
  let s:default_sorter = 'sorter_rank'
  if has('python') || has('python3')
    let s:default_sorter = 'sorter_selecta'
  endif
  call unite#filters#sorter_default#use(s:default_sorter)

  " ----------------------------------------------------------------------
  " File source settings
  " ----------------------------------------------------------------------

  " In file search, display relative paths (since we do UniteWithProjectDir)
  " https://github.com/Shougo/unite.vim/blob/master/autoload/unite/filters/converter_relative_word.vim
  call unite#custom#source(
        \   'file_rec,file_rec/async,file_rec/neovim',
        \   'converters',
        \   ['converter_relative_word']
        \ )

  " ----------------------------------------------------------------------
  " Split profile: default - open in bottom pane like ctrl-p
  " ----------------------------------------------------------------------

  call unite#custom#profile('default', 'context', {
        \   'direction':          'botright',
        \   'max_candidates':     300,
        \   'no_empty':           1,
        \   'short_source_names': 1,
        \   'silent':             1,
        \   'toggle':             1,
        \   'winheight':          12,
        \ })

  " ----------------------------------------------------------------------
  " Split profile: unite-outline - open in right pane like tagbar
  " ----------------------------------------------------------------------

  call unite#custom#profile('source/outline', 'context', {
        \   'auto-highlight':     '1',
        \   'direction':          'botright',
        \   'no_empty':           1,
        \   'prompt_direction':   'top',
        \   'toggle':             1,
        \   'vertical':           1,
        \   'winwidth':           48,
        \ })

endfunction

augroup dkounite
  autocmd!
  autocmd VimEnter * call s:unite_profiles()
augroup END

" ============================================================================
" Unite buffer keybindings
" ============================================================================

function! s:unite_keybindings()
  " for unite buffers, exit immediately on <Esc> in normal
  " " https://github.com/Shougo/unite.vim/issues/693#issuecomment-67889305
  nmap <buffer>   <Esc>   <Plug>(unite_all_exit)

  " also exit on unite-bound function keys, so you can toggle open and
  " close with same key
  for l:fk in ['<F1>', '<F2>', '<F3>', '<F4>', '<F8>', '<F10>', '<F11>']
    execute 'imap <buffer> ' . l:fk . ' '
          \ . '<Plug>(unite_insert_leave)'
          \ . '<Plug>(unite_cursor_bottom)'
          \ . '<Plug>(unite_all_exit)'
    execute 'nmap <buffer> ' . l:fk . ' <Plug>(unite_all_exit)'
  endfor

  " never use unite actions on TAB
  iunmap <buffer> <Tab>
  nunmap <buffer> <Tab>
endfunction

autocmd dkounite FileType unite call s:unite_keybindings()

" ============================================================================
" Global keys to open unite
" ============================================================================

function! s:unite_mappings()
  " ============================================================================
  " Keybinding: command-t/ctrlp replacement
  " ============================================================================

  nnoremap <silent> <F1> :<C-u>Unite -start-insert file_rec/async:!<CR>
  inoremap <silent> <F1> <Esc>:<C-u>Unite -start-insert file_rec/async:!<CR>
  vnoremap <silent> <F1> <Esc>:<C-u>Unite -start-insert file_rec/async:!<CR>

  " ============================================================================
  " Keybinding: recently used
  " ============================================================================

  nnoremap <silent> <F2> :<C-u>Unite -start-insert neomru/file<CR>
  inoremap <silent> <F2> <Esc>:<C-u>Unite -start-insert neomru/file<CR>
  vnoremap <silent> <F2> <Esc>:<C-u>Unite -start-insert neomru/file<CR>

  " ============================================================================
  " Keybinding: find in files (ag.vim/ack.vim replacement)
  " ============================================================================

  nnoremap <silent> <F3> :<C-u>Unite grep:.<CR>
  inoremap <silent> <F3> <Esc>:<C-u>UniteWithProjectDir grep:.<CR>
  vnoremap <silent> <F3> <Esc>:<C-u>UniteWithProjectDir grep:.<CR>

  " ============================================================================
  " Keybinding: buffers
  " ============================================================================

  nnoremap <silent> <F4> :<C-u>Unite buffer<CR>
  inoremap <silent> <F4> <Esc>:<C-u>Unite buffer<CR>
  vnoremap <silent> <F4> <Esc>:<C-u>Unite buffer<CR>

  " ============================================================================
  " Keybinding: Command Palette
  " ============================================================================

  nnoremap <silent> <F8> :<C-u>Unite -start-insert command<CR>
  inoremap <silent> <F8> <Esc>:<C-u>Unite -start-insert command<CR>
  vnoremap <silent> <F8> <Esc>:<C-u>Unite -start-insert command<CR>

  " ============================================================================
  " Keybinding: outline
  " ============================================================================

  nnoremap <silent> <F10> :<C-u>Unite outline<CR>
  inoremap <silent> <F10> <Esc>:<C-u>Unite outline<CR>
  vnoremap <silent> <F10> <Esc>:<C-u>Unite outline<CR>

  " ============================================================================
  " Keybinding: find in yank history
  " ============================================================================

  " shougo moved this to neoyank.vim and I never used it so bye
  " nnoremap <silent> <F11> :<C-u>Unite history/yank<CR>
  " inoremap <silent> <F11> <Esc>:<C-u>Unite history/yank<CR>
  " vnoremap <silent> <F11> <Esc>:<C-u>Unite history/yank<CR>
endfunction

autocmd dkounite VimEnter * call s:unite_mappings()

