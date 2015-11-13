" candidates
let g:unite_source_grep_max_candidates = 300

" use ag for file_rec/async and unite grep
if executable('ag')
  let s:ag_opts =
        \ ' --vimgrep'
        " vimgrep does everything
        " \ ' --nocolor --nogroup' .
        " \ ' --numbers' .
        " \ ' --follow --smart-case --hidden'

  " Ignore wildignores too
  " https://github.com/gf3/dotfiles/blob/master/.vimrc#L564
  for s:i in split(&wildignore, ",")
    let s:i = substitute(s:i, '\*/\(.*\)/\*', '\1', 'g')
    let s:ag_opts = s:ag_opts .
          \ ' --ignore "' . substitute(s:i, '\*/\(.*\)/\*', '\1', 'g') . '"'
  endfor

  let g:unite_source_rec_async_command  = [ 'ag', s:ag_opts, '-g ""' ]
  let g:unite_source_grep_command       = 'ag'
  let g:unite_source_grep_default_opts  = s:ag_opts
  let g:unite_source_grep_recursive_opt = ''
endif

" ============================================================================
" Split profile - default - open in bottom pane like ctrl-p
" ============================================================================
call unite#custom#profile('default', 'context', {
      \   'direction':          'botright',
      \   'max_candidates':     300,
      \   'no_empty':           1,
      \   'short_source_names': 1,
      \   'silent':             1,
      \   'toggle':             1,
      \   'winheight':          12,
      \ })

" ============================================================================
" Split profile - unite-outline - open in right pane like tagbar
" ============================================================================

call unite#custom#profile('source/outline', 'context', {
      \   'auto-highlight':     '1',
      \   'direction':          'botright',
      \   'no_empty':           1,
      \   'prompt_direction':   'top',
      \   'toggle':             1,
      \   'vertical':           1,
      \   'winwidth':           48,
      \ })

" ============================================================================
" Matcher settings - always fuzzy (e.g. type abc to match app/book/collection)
" ============================================================================

call unite#filters#matcher_default#use(
      \   ['matcher_project_files', 'matcher_fuzzy']
      \ )

" ============================================================================
" Display settings - display relative paths in file search
" ============================================================================

" using stock filter
" https://github.com/Shougo/unite.vim/blob/master/autoload/unite/filters/converter_relative_word.vim
call unite#custom#source(
      \   'file_rec,file_rec/async,file_rec/neovim,neomru/file', 'converters',
      \   ['converter_relative_word']
      \ )

" ============================================================================
" Buffer keybindings
" ============================================================================
function! s:unite_my_settings()
  " never go to unite normal mode
  " for unite buffers, exit immediately on <Esc>
  " " https://github.com/Shougo/unite.vim/issues/693#issuecomment-67889305
  imap <buffer> <Esc>          <Plug>(unite_exit)
  nmap <buffer> <Esc>          <Plug>(unite_exit)

  " also exit on unite-bound function keys, so you can toggle open and
  " close with same key
  imap <buffer> <F1>           <Plug>(unite_exit)
  nmap <buffer> <F1>           <Plug>(unite_exit)
  imap <buffer> <F2>           <Plug>(unite_exit)
  nmap <buffer> <F2>           <Plug>(unite_exit)
  imap <buffer> <F3>           <Plug>(unite_exit)
  nmap <buffer> <F3>           <Plug>(unite_exit)
  imap <buffer> <F10>          <Plug>(unite_exit)
  nmap <buffer> <F10>          <Plug>(unite_exit)
  imap <buffer> <F11>          <Plug>(unite_exit)
  nmap <buffer> <F11>          <Plug>(unite_exit)

  " never use unite actions on TAB
  iunmap <buffer> <Tab>
  nunmap <buffer> <Tab>
endfunction
autocmd vimrc FileType unite call s:unite_my_settings()

" ============================================================================
" Keybinding - command-t/ctrlp replacement
" ============================================================================

nnoremap <silent><F1> :<C-u>Unite -start-insert file_rec/async:!<CR>
inoremap <silent><F1> <Esc>:<C-u>Unite -start-insert file_rec/async:!<CR>
vnoremap <silent><F1> <Esc>:<C-u>Unite -start-insert file_rec/async:!<CR>

" ============================================================================
" Keybinding - recently used
" ============================================================================

nnoremap <silent><F2> :<C-u>Unite -start-insert neomru/file<CR>
inoremap <silent><F2> <Esc>:<C-u>Unite -start-insert neomru/file<CR>
vnoremap <silent><F2> <Esc>:<C-u>Unite -start-insert neomru/file<CR>

" ============================================================================
" Keybinding - find in files (ag.vim/ack.vim replacement)
" ============================================================================

nnoremap <silent><F3> :<C-u>Unite grep:.<CR>
inoremap <silent><F3> <Esc>:<C-u>Unite grep:.<CR>
vnoremap <silent><F3> <Esc>:<C-u>Unite grep:.<CR>

" ============================================================================
" Keybinding - Command Palette
" ============================================================================

nnoremap <silent><F8> :<C-u>Unite -start-insert command<CR>
inoremap <silent><F8> <Esc>:<C-u>Unite -start-insert command<CR>
vnoremap <silent><F8> <Esc>:<C-u>Unite -start-insert command<CR>

" ============================================================================
" Keybinding - outline
" ============================================================================

nnoremap <silent><F10> :<C-u>Unite outline<CR>
inoremap <silent><F10> <Esc>:<C-u>Unite outline<CR>
vnoremap <silent><F10> <Esc>:<C-u>Unite outline<CR>

" ============================================================================
" Keybinding - find in yank history
" ============================================================================

" shougo moved this to neoyank.vim and I never used it so bye
" nnoremap <silent><F11> :<C-u>Unite history/yank<CR>
" inoremap <silent><F11> <Esc>:<C-u>Unite history/yank<CR>
" vnoremap <silent><F11> <Esc>:<C-u>Unite history/yank<CR>

