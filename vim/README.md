# vim config

Keep `(g)vimrc` (no dot in filename) in `.vim` -- vim knows to look in there.

See [https://github.com/majutsushi/tagbar/wiki](https://github.com/majutsushi/tagbar/wiki)
for getting ctag support in various languages for tagbar.

See [https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers](https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers)
for getting various linter support in syntastic.

## Keys

- `<F1>` unite fuzzy search files
- `<F2>` unite fuzzy search most recently used files
- `<F3>` unite grep via ag

- `<F5>` toggle solarized bg
- `<F6>` toggle indent guides
- `<F7>` OverCommandLine for subst
- `<F8>` Cmd2 for command auto suggestions/completions

- `<F9>` left pane: vimfiler
- `<F10>` right pane: tagbar
- `<F11>` unite yank history
- `<F12>` toggle paste mode

- `<A-dir>` Move around splits
- `<S-dir>` Resize splits
- `<C-left/right>` tabn/tabp

- `<C-up/down>` swap lines

See `vim/plugins/mappings.vim` for the leader key bindings and more.
See `vim/neobundle.vim` for plugin specific bindings.

## Under consideration

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

- vim-coloresque

 ```
NeoBundleLazy 'gorodinskiy/vim-coloresque'
```

- Colorizer

 ```
NeoBundle 'chrisbra/Colorizer', {
```

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

- 'xolox/vim-easytags' generates a _tags_ file automatically (unlike tagbar which
only generates on the fly)

 ```
NeoBundle 'xolox/vim-easytags', {
      \   'depends' : 'xolox/vim-misc',
      \   'disabled': !executable("ctags"),
      \ }
if neobundle#tap('vim-easytags')
  let g:easytags_file = '~/.vim/.tags/tags'
endif

NeoBundle 'xolox/vim-misc', {
      \   'disabled': !executable("ctags"),
      \ }
```

- echodoc -- works with neocomplete to show function signatures in bottom of
  command line instead of in scratch buffer. Useful but don't really want it
  popping up all the time. It's like tern

 ```
" NeoBundle 'Shougo/echodoc', '', 'default'
" call neobundle#config('echodoc', {
"       \   'lazy': 1,
"       \   'autoload': { 'insert': 1, },
"       \ })
" if neobundle#tap('echodoc')
"   set cmdheight=2
"   let g:echodoc_enable_at_startup = 1
"   call neobundle#untap()
" endif
```

- vim-bufkill to keep splits open after bd

 ```
"NeoBundle 'dbarsam/vim-bufkill'         " :bd keeps window open
```

- vim-rails - i don't do rails enough to make this worthwhile

 ```
" don't lazy load -- see https://github.com/Shougo/neobundle.vim/issues/114
NeoBundle 'tpope/vim-rails'
```

- vim-flavored-markdown and vim-markdown -- no longer needed, bundled
  vim-markdown in 7.4 supports everything now

 ```
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

"NeoBundle 'tpope/vim-markdown'          " creates markdown filetype
```

- clickable links - Don't want for now until I can turn off the highlighting:

 ```
" NeoBundle 'Rykka/clickable.vim', {
"       \   'depends': 'vimproc',
"       \ }
"   let g:clickable_browser = 'chrome'
```

- supertab -- not needed, bound PUM via neocomplete keys

 ```
NeoBundle 'ervandew/supertab'
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-n>"
```

- investigate

 ```
" NeoBundle 'Keithbsmiley/investigate.vim'
" nnoremap <leader>K :call investigate#Investigate()<CR>
" if g:is_macvim
"   let g:investigate_use_dash=1
" endif
```

- tab settings

 ```
"NeoBundle 'vim-scripts/Smart-Tabs'
"NeoBundle 'vim-scripts/IndentTab'
```

