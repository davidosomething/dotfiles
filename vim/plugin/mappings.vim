" plugin/mappings.vim

" KEEP IDEMPOTENT
" There is no loaded guard on top, so any recursive maps need a silent unmap
" prior to binding. This way this file can be edited and sourced at any time
" to rebind keys.
"
" @see after/plugin/search for search mappings like <Esc><Esc>
"

" cpoptions are reset but use <special> when mapping anyway
let s:cpo_save = &cpoptions
set cpoptions&vim

" ============================================================================
" Disable for reuse
" ============================================================================

" [n]gs normally waits for [n] seconds, totally useless
noremap   gs    <NOP>

" ============================================================================
" Commands
" ============================================================================

" In normal mode, jump to command mode with <CR>
" Don't map <CR>, it's a pain to unmap for various window types like quickfix
" where <CR> should jump to the entry, or NetRW or unite or fzf.
"nnoremap  <special>  <CR>  <Esc>:<C-U>

command! Q q

" vim-plug shortcut
command! PU PlugUpgrade | PlugUpdate

execute dko#MapAll({ 'key': '<F11>', 'command': 'call dkotabline#Toggle()' })

" ============================================================================
" Quick edit
" ec* - Edit closest (find upwards)
" er* - Edit from dkoproject#GetRoot()
" ============================================================================

" This executes instead of returns string so the mapping can noop when file
" not found.
" @param {String} file
function! s:EditClosest(file) abort
  let s:file = findfile(a:file, '.;')
  if empty(s:file)
    echomsg 'File not found:'  . a:file
    return
  endif
  execute 'edit ' . s:file
endfunction
nnoremap  <silent><special>  <Leader>eca
      \ :<C-U>call <SID>EditClosest('.ignore')<CR>
nnoremap  <silent><special>  <Leader>eci
      \ :<C-U>call <SID>EditClosest('.gitignore')<CR>
nnoremap  <silent><special>  <Leader>ecr
      \ :<C-U>call <SID>EditClosest('README.md')<CR>

" As above, this noops if file not found
" @param {String} file
function! s:EditRoot(file) abort
  let s:file = dkoproject#GetFile(a:file)
  if empty(s:file)
    echomsg 'File not found: '  . a:file
    return
  endif
  execute 'edit ' . s:file
endfunction
nnoremap  <silent><special>  <Leader>era  :<C-U>call <SID>EditRoot('.ignore')<CR>
nnoremap  <silent><special>  <Leader>eri  :<C-U>call <SID>EditRoot('.gitignore')<CR>
nnoremap  <silent><special>  <Leader>erg  :<C-U>call <SID>EditRoot('gulpfile.js')<CR>
nnoremap  <silent><special>  <Leader>erG  :<C-U>call <SID>EditRoot('Gruntfile.js')<CR>
nnoremap  <silent><special>  <Leader>erp  :<C-U>call <SID>EditRoot('package.json')<CR>
nnoremap  <silent><special>  <Leader>err  :<C-U>call <SID>EditRoot('README.md')<CR>

" Not using $MYVIMRC since it varies based on (n)vim
nnoremap  <silent><special>  <Leader>evi   :<C-U>edit $VDOTDIR/init.vim<CR>
nnoremap  <silent><special>  <Leader>evg   :<C-U>edit $VDOTDIR/gvimrc<CR>
nnoremap  <silent><special>  <Leader>evl   :<C-U>edit ~/.secret/vim/vimrc.vim<CR>
nnoremap  <silent><special>  <Leader>evr   :<C-U>edit $VDOTDIR/vimrc<CR>

nnoremap  <silent><special>  <Leader>em   :<C-U>edit $VDOTDIR/plugin/mappings.vim<CR>
nnoremap  <silent><special>  <Leader>ez   :<C-U>edit $ZDOTDIR/.zshrc<CR>

" ============================================================================
" Buffer manip
" ============================================================================

" ----------------------------------------------------------------------------
" Prev buffer with <BS> backspace in normal (C-^ is kinda awkward)
" ----------------------------------------------------------------------------

nnoremap  <special>   <BS>  <C-^>

" ============================================================================
" Window manipulation
" ============================================================================

" ----------------------------------------------------------------------------
" Navigate with <C+arrow> (insert mode leaves user in normal)
" ----------------------------------------------------------------------------

nnoremap  <special>   <C-Left>    <C-w>h
nnoremap  <special>   <C-Down>    <C-w>j
nnoremap  <special>   <C-Up>      <C-w>k
nnoremap  <special>   <C-Right>   <C-w>l

" ----------------------------------------------------------------------------
" Cycle window with <Tab> in normal mode
" ----------------------------------------------------------------------------

nnoremap  <special>   <Tab>       <C-w>w
nnoremap  <special>   <S-Tab>     <C-w>W

" ----------------------------------------------------------------------------
" Resize (can take a count, eg. 2<S-Left>)
" ----------------------------------------------------------------------------

silent! iunmap <S-Up>
silent! iunmap <S-Down>
silent! iunmap <S-Left>
silent! iunmap <S-Right>

nnoremap  <special>   <S-Up>      <C-W>+
imap      <special>   <S-Up>      <C-o><S-Up>
nnoremap  <special>   <S-Down>    <C-W>-
imap      <special>   <S-Down>    <C-o><S-Down>
nnoremap  <special>   <S-Left>    <C-w><
imap      <special>   <S-Left>    <C-o><S-Left>
nnoremap  <special>   <S-Right>   <C-w>>
imap      <special>   <S-Right>   <C-o><S-Right>

" ============================================================================
" Mode and env
" ============================================================================

" ----------------------------------------------------------------------------
" Toggle visual/normal mode with space-space
" ----------------------------------------------------------------------------

nnoremap  <special> <Leader><Leader>  V
vnoremap  <special> <Leader><Leader>  <Esc>

" ----------------------------------------------------------------------------
" Back to normal mode
" ----------------------------------------------------------------------------

silent! iunmap jj
silent! cunmap jj

imap jj <Esc>
cmap jj <Esc>

" ----------------------------------------------------------------------------
" Unfuck my screen
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-444
" ----------------------------------------------------------------------------

nnoremap U :<C-U>syntax sync fromstart<CR>:redraw!<CR>

" ----------------------------------------------------------------------------
" cd to current buffer's git root
" ----------------------------------------------------------------------------

nnoremap <silent><special>   <Leader>cr
      \ :<C-U>execute 'cd! ' . get(b:, 'dkoproject_root', getcwd())<CR>

" ----------------------------------------------------------------------------
" cd to current buffer path
" ----------------------------------------------------------------------------

nnoremap <silent><special>   <Leader>cd
      \ :<C-U>cd! %:h<CR>

" ----------------------------------------------------------------------------
" go up a level
" ----------------------------------------------------------------------------

nnoremap <silent><special>   <Leader>..
      \ :<C-U>cd! ..<CR>

" ============================================================================
" Editing
" ============================================================================

" ----------------------------------------------------------------------------
" Quickly apply macro q
" ----------------------------------------------------------------------------

nnoremap  <special> <Leader>q   @q

" ----------------------------------------------------------------------------
" Use gm to set a mark (since easyclip is using m for "move")
" ----------------------------------------------------------------------------

nnoremap  gm   m
vnoremap  gm   m

" ----------------------------------------------------------------------------
" Map the arrow keys to be based on display lines, not physical lines
" ----------------------------------------------------------------------------

vnoremap  <special>   <Down>      gj
vnoremap  <special>   <Up>        gk

" ----------------------------------------------------------------------------
" Replace PgUp and PgDn with Ctrl-U/D
" ----------------------------------------------------------------------------

noremap   <special>   <PageUp>    <C-U>
noremap   <special>   <PageDown>  <C-D>

" same in insert mode, but stay in insert mode (needs recursive)
silent! iunmap              <PageUp>
silent! iunmap              <PageDown>
        imap    <special>   <PageUp>    <C-o><PageUp>
        imap    <special>   <PageDown>  <C-o><PageDown>

" ----------------------------------------------------------------------------
" Start/EOL
" ----------------------------------------------------------------------------

" Easier to type, and I never use the default behavior.
" From https://bitbucket.org/sjl/dotfiles/
" default is {count}from top line in visible window
noremap   H   ^
" default is {count}from last line in visible window
noremap   L   g_

" ----------------------------------------------------------------------------
" Allow [[ open,  [] close, back/forward to curly brace in any column
" see :h section
" REMOVED since some default runtimes include their own matches
" e.g. PHP has a setting in
" https://github.com/neovim/neovim/blob/master/runtime/ftplugin/php.vim
" ----------------------------------------------------------------------------

" map     [[  ?{<CR>w99[{
" map     []  k$][%?}<CR>
"map    ][  /}<CR>b99]}
"map    ]]  j0[[%/{<CR>

" ----------------------------------------------------------------------------
" Reselect visual block after indent
" ----------------------------------------------------------------------------

vnoremap  <   <gv
vnoremap  >   >gv

" ----------------------------------------------------------------------------
" <Tab> indents in visual mode (recursive map to the above)
" ----------------------------------------------------------------------------

silent! vunmap <Tab>
silent! vunmap <S-Tab>
vmap  <special>   <Tab>     >
vmap  <special>   <S-Tab>   <

" ----------------------------------------------------------------------------
" Sort lines (use unix sort)
" https://bitbucket.org/sjl/dotfiles/src/2c4aba25376c6c5cb5d4610cf80109d99b610505/vim/vimrc?at=default#cl-288
" ----------------------------------------------------------------------------

if dko#IsPlugged('vim-textobj-indent')
  " Auto select indent-level and sort
  nmap  <special> <Leader>s   vii:!sort<CR>
else
  " Auto select paragraph (bounded by blank lines) and sort
  nnoremap  <special> <Leader>s   vip:!sort<CR>
endif
" Sort selection (no clear since in visual)
vnoremap  <special> <Leader>s   :!sort<CR>

" ----------------------------------------------------------------------------
" Uppercase / lowercase word
" ----------------------------------------------------------------------------

" mark Q, visual, inner-word case, back to mark (don't change cursor position)
nnoremap  <special> <Leader>l   mQviwu`Q
nnoremap  <special> <Leader>u   mQviwU`Q

" ----------------------------------------------------------------------------
" Join lines without space (and go to first char line that was merged up)
" ----------------------------------------------------------------------------

nnoremap  <special> <Leader>j   VjgJl

" ----------------------------------------------------------------------------
" Clean up whitespace
" ----------------------------------------------------------------------------

nnoremap  <special> <Leader>ws  :<C-U>call dkowhitespace#clean()<CR>

" ============================================================================

let &cpoptions = s:cpo_save
unlet s:cpo_save
