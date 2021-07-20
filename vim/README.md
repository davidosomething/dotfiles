# (g/n)vim config

> Don't use what you don't understand.

## Features

![vim screenshot][screenshot]
> Terminal Neovim

- Custom statusline with minimal junk, showing short directory
- FZF for Most Recently Used files and fuzzy file finder
- CoC for language server and misc utilities
- Neomake for non-language server makers/linters
- Language emphasis: JavaScript, VimL, PHP, HTML, SCSS (but not exclusive)
- Lazy loaded plugins and keybindings -- a brand new Vim instance opens in
  <200ms (without plugins Vim takes around 100ms)
- Lots more but you shouldn't use any of it unless you know what you're doing.

## Installation

`vim-plug` plugins will be installed into `$XDG_DATA_HOME/vim/vendor`! Make
sure you have XDG environment variables set up.

Best used with rest of dotfiles. `coc/extensions/dot.npmrc` will enforce using
the main npmjs package registry. Commands in `.vimrc` will auto-install
plugins if curl is available.

Keep `(g)vimrc` (no dot in filename) in `~/.vim/` -- Vim knows to look in there.

### Python Settings

See [bootstrap/pyenv] for a scripted version of this

- Using `pyenv`, install python 3+.
- Set up a virtualenv using `pyenv-virtualenv`: `pyenv virtualenv neovim3`
- Activate the virtualenv `pyenv activate neovim3`
- `python -m pip install pynvim` in the virtualenv
- You can now switch back to whatever python (`pyenv deactivate`) you want,
  `init.vim` for Neovim startup is already configured to find the `neovim3`
  virtualenv.

Finally

- `:UpdateRemotePlugins` if installing/upgrading python-based plugins
- `:checkhealth` to see if the python3 setup and plugins are working.

### JavaScript Settings

- Using `fnm` or `nvm` install and use a node.
- When installing/updating plugins, [vim-plug] will automatically install the
  associated dependencies.

### Arch Linux

Comment out `runtime! archlinux.vim` from `/etc/vimrc` if you're on Arch Linux
(despite its pleas not to.)

## Usage

### Paths

### Plugin settings

Plugins settings are in `plugin/` and `after/*` as appropriate. There
is generally a wrapper around them that checks for
`dkoplug#IsLoaded('plugin-name')`.

#### Super-non-standard keys

- `<C-f>` -- Expand snippet. I use `<C-u>`/`<C-d>` to jump pages instead.
- `gs` no longer sleeps. It's an operator prefix for vim-operator-surround.

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
| `<A-v>`  | :FZFVim - ~/.vim |
|    `\`   | UI - :OverCommandLine |

See `plugin/mappings.vim` (and other `plugin/*` files) for other mappings.

### Junk defaults and unmapped keys

Plan to remap these at some point

- `n <C-b>` -- backward one screen (page)
- `n <C-f>` -- forward one screen (page)
- `n zh/l`  -- useless wrap mode scroll

## My Vim conventions

Adhere to [vint](https://github.com/Kuniwak/vint) and
[vim-vimlint](https://github.com/syngan/vim-vimlint) linting rules.

Always try to keep as much in the main runtime as possible, using `after/`
sparingly (typically for `setlocal` ftplugin settings).

### VimL Coding

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
- Include `dkoplug#Exists()` or `dkoplug#IsLoaded()` checks if
  relying on plugins
- `<Plug>(DKOMyPlugMapping)` - Parentheses around `<Plug>` mapping names
- The `augroup` for `mine/` plugins should be `plugin-pluginname`
- The `augroup` for plugin settings should be `dkopluginname`
- Bar continuation should have a space: `\ | {{next command }}`

----

[screenshot]: https://raw.githubusercontent.com/davidosomething/dotfiles/d759d42f59b4f2be66aa6957bfd595e90096e223/meta/vim-potatonuc.png
[Syntax-Checkers]: https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers
[syntastic]: https://github.com/scrooloose/syntastic
[neomake]: https://github.com/neomake/neomake
[vim-plug]: https://github.com/junegunn/vim-plug
