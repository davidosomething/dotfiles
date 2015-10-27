" track yanks
let g:unite_source_history_yank_enable = 1
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
  for i in split(&wildignore, ",")
    let i = substitute(i, '\*/\(.*\)/\*', '\1', 'g')
    let s:ag_opts = s:ag_opts .
          \ ' --ignore "' . substitute(i, '\*/\(.*\)/\*', '\1', 'g') . '"'
  endfor

  let g:unite_source_rec_async_command = [ 'ag', s:ag_opts, '-g ""' ]
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = s:ag_opts
  let g:unite_source_grep_recursive_opt = ''
endif

" ========================================
" open in bottom pane like ctrl-p
call unite#custom#profile('default', 'context', {
      \   'direction':          'botright',
      \   'max_candidates':     300,
      \   'short_source_names': 1,
      \   'silent':             1,
      \   'winheight':          12,
      \ })

" ========================================
" always use fuzzy match (e.g. type abc to match app/book/collection)
call unite#filters#matcher_default#use(
      \   ['matcher_project_files', 'matcher_fuzzy']
      \ )

" ========================================
" display relative paths in file search
" using stock filter
" https://github.com/Shougo/unite.vim/blob/master/autoload/unite/filters/converter_relative_word.vim
call unite#custom#source(
      \   'file_rec,file_rec/async,neomru/file', 'converters',
      \   ['converter_relative_word']
      \ )

" ========================================
" Unite buffer keybindings
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
  imap <buffer> <F11>          <Plug>(unite_exit)
  nmap <buffer> <F11>          <Plug>(unite_exit)

  " never use unite actions on TAB
  iunmap <buffer> <Tab>
  nunmap <buffer> <Tab>
endfunction
autocmd vimrc FileType unite call s:unite_my_settings()

" ========================================
" command-t/ctrlp replacement
nnoremap <silent><F1> :<C-u>Unite -start-insert file_rec/async:!<CR>
inoremap <silent><F1> <Esc>:<C-u>Unite -start-insert file_rec/async:!<CR>
vnoremap <silent><F1> <Esc>:<C-u>Unite -start-insert file_rec/async:!<CR>

" ========================================
" recently used
nnoremap <silent><F2> :<C-u>Unite -start-insert neomru/file<CR>
inoremap <silent><F2> <Esc>:<C-u>Unite -start-insert neomru/file<CR>
vnoremap <silent><F2> <Esc>:<C-u>Unite -start-insert neomru/file<CR>

" ========================================
" find in files (ag.vim/ack.vim replacement)
nnoremap <silent><F3> :<C-u>Unite grep:.<CR>
inoremap <silent><F3> <Esc>:<C-u>Unite grep:.<CR>
vnoremap <silent><F3> <Esc>:<C-u>Unite grep:.<CR>

" ========================================
" find in yank history
" shougo moved this to neoyank.vim and I never used it so bye
" nnoremap <silent><F11> :<C-u>Unite history/yank<CR>
" inoremap <silent><F11> <Esc>:<C-u>Unite history/yank<CR>
" vnoremap <silent><F11> <Esc>:<C-u>Unite history/yank<CR>

" ========================================
" Command Palette
" nnoremap <C-e> :<C-u>Unite -start-insert command<CR>
" inoremap <C-e> <Esc>:<C-u>Unite -start-insert command<CR>
" vnoremap <C-e> <Esc>:<C-u>Unite -start-insert command<CR>

