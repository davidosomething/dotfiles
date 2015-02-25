# vim config

Keep `(g)vimrc` (no dot in filename) in `.vim` -- vim knows to look in there.

## Under consideration

'osyo-manga/vim-anzu' instead of 'haya14busa/incsearch.vim'

### tern for vim

Provides intellisense-like autocompletion for JS in vim

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
" }}}autocmdFT javascript setlocal omnifunc=tern#Complete
```

## Plugins I intentionally don't use

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
" if executable("ctags")
"   NeoBundle 'majutsushi/tagbar'
"     let g:tagbar_compact = 1
"     let g:tagbar_show_linenumbers = 1     " Show absolute line numbers
"     nnoremap <F4> :TagbarToggle<CR>
" endif

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

