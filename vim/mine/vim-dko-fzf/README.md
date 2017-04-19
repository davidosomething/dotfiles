# vim-dko-fzf

My FZF commands for Neovim. Not for general use since it relies on my `autoload`
and shell scripts; but check out my dotfiles repo if you want to
de-construct it for yourself.

The plugin itself should be lazy loaded upon command execution if using
`vim-plug` or `dein`.

## vim-plug configuration example

```vim
" vim-plug creates wrapper commands that lazy load the heavyweight scripting
" the first time you run them.
Plug 'davidosomething/vim-dko-fzf', {
  \     'on': [
  \       'FZFGrepper',
  \       'FZFRelevant',
  \       'FZFProject',
  \       'FZFMRU',
  \       'FZFFiles',
  \       'FZFColors',
  \       'FZFSpecs',
  \       'FZFBuffers',
  \     ]
  \   }

" An optional mapping
map   <special>   <Leader>b   :<C-U>FZFBuffers<CR>
```
