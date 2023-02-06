# nvim config

Neovim-specific config.

> Don't use what you don't understand.

## Some features

![vim screenshot][screenshot]
> Terminal Neovim

- Configured in lua. Using built-in LSP, diagnostic.
- Plugins installed via [folke/lazy.nvim](https://github.com/folke/lazy.nvim)
- Language servers managed via [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)
- Custom statusline with minimal junk, showing short directory (lua conversion WIP)
- FZF for Most Recently Used files and fuzzy file finder (lua conversion WIP)

### Python settings

See [bootstrap/pyenv] for a scripted version of this

- Using `pyenv`, install python 3+.
- Set up a virtualenv using `pyenv-virtualenv`: `pyenv virtualenv neovim3`
- Activate the virtualenv `pyenv activate neovim3`
- `python -m pip install pynvim` in the virtualenv
- You can now switch back to whatever python (`pyenv deactivate`) you want,
  `lua/dko/providers.lua` for Neovim startup is already configured to find the
  `neovim3` virtualenv.

### Arch Linux

Comment out `runtime! archlinux.vim` from `/etc/vimrc` if you're on Arch Linux
(despite its pleas not to.)

## Usage

#### Super-non-standard keys

- `<C-f>` -- Expand snippet. I use `<C-u>`/`<C-d>` to jump pages instead.

|      Key | Desc                                                    |
| -------- | :------------------------------------------------------ |
| `<A-b>`  | :FZFBuffers |
| `<A-c>`  | :FZFCommands |
| `<A-f>`  | :FZFFiles - files from Vim's cwd |
| `<A-g>`  | :FZFGrepper - custom, rg/ag with preview or git-grep |
| `<A-m>`  | :FZFMRU - custom MRU |
| `<A-p>`  | :FZFProject |
| `<A-p>`  | :FZFProject - custom, :FZFFiles but from project root |
| `<A-r>`  | :FZFRelevant |
| `<A-r>`  | :FZFRelevant - custom, dirty/new files vs git master |
| `<A-t>`  | :FZFTests - custom find test files near current path |
| `<A-v>`  | :FZFVim - ~/.config/nvim |
| `<BS>`   | Switch to alternate file |

### Junk defaults and unmapped keys

Plan to remap these at some point

- `n <C-b>` -- backward one screen (page)
- `n <C-f>` -- forward one screen (page)
- `n zh/l`  -- useless wrap mode scroll

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
