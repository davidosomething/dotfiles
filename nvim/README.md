# nvim config

nvim config, crafted for nightly builds only!

> Don't use what you don't understand.

## Some features

![vim screenshot][screenshot]
> Terminal Neovim

- Configured in lua. Using built-in LSP, diagnostic.
- Plugins installed via [folke/lazy.nvim](https://github.com/folke/lazy.nvim)
- Language servers managed via
  [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- Additional formatters and linters provided as pseudo-LSPs using
  [jose-elias-alvarez/null-ls.nvim](https://github.com/jose-elias-alvarez/null-ls.nvim)
- Telescope pickers, custom heirline.nvim tab/statuslines

### Installation

1. `lazy.nvim` will auto-install itself
1. `mason.nvim` is configured to auto-install linters
1. `mason-lspconfig.nvim` is configured to tell `mason.nvim` to auto-install
   some LSPs
1. run `:checkhealth` to see if you are missing anything

### Arch Linux

Comment out `runtime! archlinux.vim` from `/etc/vimrc` if you're on Arch Linux
(despite its pleas not to.)

## Conventions

- Prefer lua where possible.
- Adhere to [vint](https://github.com/Kuniwak/vint) and
  [vim-vimlint](https://github.com/syngan/vim-vimlint) linting rules.
- Always try to keep as much in the main runtime as possible, using `after/`
  sparingly (typically for `setlocal` ftplugin settings).
- Include `&cpoptions` guard if there are mappings
- Use `<special>` if the mapping key is special (irrespective of `&cpoptions`)
- Use `<A-` instead of `<M-` for alt/meta mappings
- `g:DKO_FunctionName` - DKO_PascalCase
- `s:FunctionName` - PascalCase
- `autoload#FunctionName` - PascalCase
- `g:dko_variable_name` - dko_snake_case for my global variables
- `l:local_variable` - snake_case function-local variables
- `s:variable_name` - snake_case for script-local variables
- `g:dko#variable_name` - prefixed autoload-provided global variable
- `dkoautocommandgroup` - lowercasealphanumer1cnospaces
- `<Plug>(DKOMyPlugMapping)` - Parentheses around `<Plug>` mapping names
- The `augroup` for `mine/` plugins should be `plugin-pluginname`
- The `augroup` for plugin settings should be `dkopluginname`
- Bar continuation should have a space: `\ | {{next command }}`

----

[screenshot]: https://raw.githubusercontent.com/davidosomething/dotfiles/d759d42f59b4f2be66aa6957bfd595e90096e223/meta/vim-potatonuc.png
