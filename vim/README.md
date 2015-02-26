# vim config

Keep `(g)vimrc` (no dot in filename) in `.vim` -- vim knows to look in there.

See [https://github.com/majutsushi/tagbar/wiki](https://github.com/majutsushi/tagbar/wiki)
for getting ctag support in various languages for tagbar.

See [https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers](https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers)
for getting various linter support in syntastic.

## Under consideration

'osyo-manga/vim-anzu' instead of 'haya14busa/incsearch.vim'

'xolox/vim-easytags' generates a _tags_ file automatically (unlike tagbar which
only generates on the fly)

```
Don't need this for now
"NeoBundleLazy 'dsawardekar/wordpress.vim', {
      "\   'depends': [
      "\     'kien/ctrlp.vim',
      "\     'shawncplus/phpcomplete.vim',
      "\   ],
      "\   'autoload': { 'filetypes': ['php'] }
      "\ }
```

### Alternate CSS colorizing plugins
`
NeoBundleLazy 'gorodinskiy/vim-coloresque', {
NeoBundle 'chrisbra/Colorizer', {
`

### tern for vim

Provides intellisense-like autocompletion for JS in vim
Doesn't work all the time...

```
" marijnh/tern_for_vim {{{
if neobundle#tap('tern_for_vim')
  " Config {{{
  call neobundle#config({
  \   'build' : {
  \     'others' : 'npm install'
  \   },
  \   'autoload' : {
  \       'functions' : ['tern#Complete', 'tern#Enable'],
  \       'filetypes' : ['javascript']
  \     },
  \   'commands' : ['TernDef', 'TernDoc', 'TernType',
  \                 'TernRefs', 'TernRename'],
  \ })
  " }}}
  call neobundle#untap()
endif
" }}}
autocmdFT javascript setlocal omnifunc=tern#Complete

" autocomplete/typehints engine, also used by tagbar
" NeoBundle 'marijnh/tern_for_vim', {
"       \   'autoload': { 'filetypes': ['javascript'] },
"       \   'build': {
"       \     'mac':     'npm install',
"       \     'unix':    'npm install',
"       \     'cygwin':  'npm install',
"       \     'windows': 'npm install',
"       \   }
"       \ }
" if neobundle#tap('tern_for_vim')
"   function! neobundle#tapped.hooks.on_source(bundle)
"     " let g:tern_show_signature_in_pum = 'on_move'
"     " let g:tern_show_argument_hints = 1
"   endfunction
"   call neobundle#untap()
" endif
```


## Plugins I intentionally don't use

```
no longer needed, bundled vim-markdown in 7.4 supports everything now
NeoBundle 'jtratner/vim-flavored-markdown'
if neobundle#tap('vim-flavored-markdown')
  function! neobundle#tapped.hooks.on_source(bundle)
    if has("autocmd")
      augroup markdown
          " remove other autocmds for markdown first
          au!
          au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
      augroup END
    endif
  endfunction
  call neobundle#untap()
endif
```

```
Comes bundled with vim7.4 now
"NeoBundle 'tpope/vim-markdown'          " creates markdown filetype
```


```
library for vim-operator-replace
NeoBundle 'kana/vim-operator-user', {
      \   'autoload' : { 'functions' : 'operator#user#define' },
      \ }
```

```
snipmate uses this
NeoBundle 'tomtom/tlib_vim'
NeoBundle 'MarcWeber/vim-addon-mw-utils'
```

- ctrlpvim/ctrlp.vim
    - I always just `ag` from a terminal or open an exact filename in vim
    - Extras
      ```
      " NeoBundle 'tacahiroy/ctrlp-funky'
      "   nnoremap <F8> :CtrlPFunky<Cr>
      ```
- jeetsukumaran/vim-buffergator
    - Using vim-airline to show buffers all the time, unimpaired switches
    - alternatively, CtrlP has a buffer mode if I wanted it
- kien/tabman.vim
    - vim-airline could show tabs, custom mappings to switch
    - alternatively, CtrlP does the same thing if I wanted it
- nathanaelkane/vim-command-w
    - doesn't work, macvim specific
- scrooloose/nerdtree
- shougo/neosnippet.vim
    - UltiSnips has WordPress.vim integration
- shougo/unite.vim
    - CtrlP has auto WordPress.vim integration
- techlivezheng/vim-plugin-minibufexpl
    - vim-airline does this
    - don't like the double status line
- vim-scripts/kwbdi.vim
    - Bufkill is newer

```
" Don't want for now until I can turn off the highlighting:
" NeoBundle 'Rykka/clickable.vim', {
"       \   'depends': 'vimproc',
"       \ }
"   let g:clickable_browser = 'chrome'
```

```
NeoBundle 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"
```

```
" conflicts with easyclip M mapping
"NeoBundle 'gorkunov/smartpairs.vim'
```


```
" NeoBundle 'osyo-manga/vim-over'
"   nnoremap <c-s> :OverCommandLine<CR>
```

```
" NeoBundle 'Keithbsmiley/investigate.vim'
" nnoremap <leader>K :call investigate#Investigate()<CR>
" if g:is_macvim
"   let g:investigate_use_dash=1
" endif

" NeoBundle 'mileszs/ack.vim'
```

```
"NeoBundle 'vim-scripts/Smart-Tabs'
"NeoBundle 'vim-scripts/IndentTab'
```

