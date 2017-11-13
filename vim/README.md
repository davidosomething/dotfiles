# (g/n)vim config

> Don't use what you don't understand.

## Features

![vim screenshot][screenshot]
> Terminal Neovim

- Custom statusline with minimal junk, showing short directory
- FZF for Most Recently Used files and fuzzy file finder
- Neomake + local use of eslint, custom detection of .eslint, .scss-lint,
  etc.
- Language emphasis: JavaScript, VimL, PHP, HTML, SCSS (but not exclusive)
- Lazy loaded plugins and keybindings -- a brand new Vim instance opens in
  <200ms (without plugins Vim takes around 100ms)
- Lots more but you shouldn't use any of it unless you know what you're doing.

## Installation

Best used with rest of dotfiles. Should self-install plugins via curl and
[vim-plug] on first load.

Keep `(g)vimrc` (no dot in filename) in `.vim` -- Vim knows to look in there.

Even though [neomake] handles linting, the [syntastic] wiki still has a good
list ([Syntax-Checkers]) and shows how to set them up.

### Python Settings

- Using `pyenv`, install python 3+.
- Set up a virtualenv using `pyenv-virtualenv`: `pyenv virtualenv neovim3`
- Activate the virtualenv `pyenv activate neovim3`
- `pip install neovim` in the virtualenv
- `pip install jedi` for python completion while still in the virtualenv
- You can now switch back to whatever python (`pyenv deactivate`) you want,
  `init.vim` for Neovim startup is already configured to find the `neovim3`
  virtualenv.
- `:UpdateRemotePlugins` if installing/upgrading python-based plugins
- `:CheckHealth` to see if the python3 setup and plugins are working. iTerm
  should use xterm-256color-italic terminfo if the backspace message is there.

### Ruby Settings

- Not used for anything right now.
- Using `chruby` install and use a ruby.
- Install the `neovim` gem
- `:CheckHealth` to see if Neovim can find the gem.

### JavaScript Settings

- Using `nvm` install and use a node.
- When installing/updating plugins, [vim-plug] will automatically install the
  associated dependencies.

### Arch Linux

Comment out `runtime! archlinux.vim` from `/etc/vimrc` if you're on Arch Linux
(in spite of its pleas not to.)

## Usage

### Paths

### Plugin settings

Plugins settings are in `plugin/` and `after/*` as appropriate. There
is generally a wrapper around them that checks for
`dkoplug#IsLoaded('plugin-name')`.

#### Super-non-standard keys

- EasyClip changes behavior of pretty much all register operations (`[y]ank`,
  `[d]elete`, `[s]ubstitute`, etc.). Prefer `[y]ank` or explicitly `[m]ove` to
  populate registers.
- `<C-f>` -- Expand neosnippet. I use `<C-u>`/`<C-d>` to jump pages instead.
- `gs` no longer sleeps. It's an operator prefix for vim-operator-surround.

#### Function Keys

|                 Key | Desc                                                    |
| ------------------: | :------------------------------------------------------ |
|  `<F1>` or `<A-g>`  | :FZFGrepper! - custom, rg/ag with preview or git-grep |
|  `<F2>`             | :FZFRelevant - custom, dirty/new files vs git master |
|  `<F3>`             | :FZFProject - custom, :FZFFiles but from project root |
|  `<F4>` or `<A-m>`  | :FZFMRU - custom MRU |
|  `<F5>` or `<A-f>`  | :FZFFiles - files from Vim's cwd |
|  `<F6>`             | :Neomake  |
|  `<F7>`             | :Neomake! |
|  `<F8>`             | unused |
|  `<F9>`             | UI - :QuickfixsignsToggle (on by default) |
| `<F10>`             | do not use -- gnome-terminal menu key |
| `<F11>`             | UI - dkotabline#Toggle() |
| `<F12>`             | UI - set pastetoggle |
| `<A-b>`             | :FZFBuffers |
| `<A-c>`             | :FZFCommands |
| `<A-p>`             | :FZFProject |
| `<A-r>`             | :FZFRelevant |
| `<A-t>`             | :FZFTests - custom find test files near current path |
| `<A-v>`             | :FZFVim - ~/.vim |
|    `/`              | UI - incsearch |
|    `\`              | UI - :OverCommandLine |

See `plugin/mappings.vim` (and other `plugin/*` files) for other mappings.

### Junk defaults and unmapped keys

Plan to remap these at some point

- `n <C-b>` -- backward one screen (page)
- `n <C-f>` -- forward one screen (page)
- `n <C-g>` -- show file status (everything's already in statusline)
- `n <C-s>` -- nothing (terminal XOFF)
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

[screenshot]: https://raw.githubusercontent.com/davidosomething/dotfiles/4fb16e4a785fe81488d09af1e77a62792c55e688/meta/vim-potatopro.png
[Syntax-Checkers]: https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers
[syntastic]: https://github.com/scrooloose/syntastic
[neomake]: https://github.com/neomake/neomake
[vim-plug]: https://github.com/junegunn/vim-plug
