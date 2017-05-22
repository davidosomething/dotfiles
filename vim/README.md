# (g/n)vim config

> Don't use what you don't understand.

## Features

![vim screenshot][screenshot]
> Screenshot in terminal vim with a function signature in tabline

- Custom statusline with minimal junk, showing short cwd - much faster than
  airline
- Custom tabline used to show function signature (PHP, Python, Ruby, VimL,
  and others supported via [tyru/current-func-info.vim], and I added regexps
  for JavaScript/es6.
- FZF for Most Recently Used files and fuzzy file finder
- Neomake + local use of eslint, custom detection of .eslint, .scss-lint,
  etc.
- Language emphasis: JavaScript, VimL, PHP, HTML, SCSS (but not exclusive)
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
  `init.vim` for neovim startup is already configured to find the `neovim3`
  virtualenv.
- `:UpdateRemotePlugins` if installing/upgrading python-based plugins like
  deoplete.
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

#### / (dotfiles/vim root)

This is a Vim runtimepath that will load after the user and system runtimepaths
but before the [vim-plug] ones. I.e., `plugin/xyz.vim` will load before
`plug/vim/pluginname/plugin/name.vim`. Neovim plugins will be in `plug/nvim/`.

#### after/

This is a runtimepath that will load after the system runtimepath but before
the [vim-plug] one. I.e., `after/plugin/xyz.vim` will load after
`plug/vim/pluginname/plugin/name.vim`.

Use this for settings that should override or extend system or plugin settings.
This will take precedence over everything but local vimrc files.

### local vimrc

Store local `vimrc`s in `~/.secret/vim/` and follow the standard Vim directory
layout (`plugin/`, `syntax/`, `indent/`, etc.). A base `(g)vimrc` file there is
probably enough.

All local settings load LAST (after all the system, user, plugin, and
`*/after` runtimes).

### Plugin settings

Plugins settings are in `plugin/` and `after/ftplugin/` as appropriate. There
is generally a wrapper around them that checks for
`exists('g:plugs["plugin"])` so grepping for `g:plugs` is an easy way to find
them.

#### Super-non-standard keys

- EasyClip changes behavior of pretty much all register operations (`[y]ank`,
  `[d]elete`, `[s]ubstitute`, etc.). Prefer `[y]ank` or explicitly `[m]ove` to
  populate registers.
- `<C-f>` -- Expand neosnippet. I use `<C-u>`/`<C-d>` to jump pages instead.
- `gs` no longer sleeps. It's an operator prefix for vim-operator-surround.

#### Function Keys

|     Key | Desc                                                               |
| ------: | :----------------------------------------------------------------- |
|  `<F1>` | :FZFGrepper - custom, rg/ag with preview or git-grep |
|  `<F2>` | :FZFRelevant - custom, dirty/new files vs git master |
|  `<F3>` | :FZFProject - custom, :FZFFiles but from project root |
|  `<F4>` | :FZFMRU - custom, whitelisted recently used + buffers |
|  `<F5>` | :FZFFiles - files from Vim's cwd |
|  `<F6>` | :Neomake |
|  `<F7>` | :Neomake! |
|  `<F8>` | UI - :FZFColors |
|  `<F9>` | UI - :QuickfixsignsToggle (on by default) |
| `<F10>` | do not use -- gnome-terminal menu key |
| `<F11>` | UI - dkotabline#Toggle() |
| `<F12>` | UI - set pastetoggle |
|    `/`  | UI - incsearch |
|    `\`  | UI - :OverCommandLine |

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

- Include `dko#IsPlugged()` check if relying on plugins
- Include `&cpoptions` guard if there are mappings
- Use `<special>` if the mapping key is special (irrespective of `&cpoptions`)
- `g:DKO_FunctionName` - DKO_PascalCase
- `s:FunctionName` - PascalCase
- `g:dko_variable_name` - dko_snake_case for my global variables
- `l:local_variable` - snake_case function-local variables
- `s:variable_name` - snake_case for script-local variables
- `g:dko#variable_name` - prefixed autoload-provided global variable
- `dkoautocommandgroup` - lowercasealphanumer1cnospaces
- `<Plug>(DKOMyPlugMapping)` - Parentheses around `<Plug>` mapping names

----

[screenshot]: https://cloud.githubusercontent.com/assets/609213/19456070/cd2eeeec-948d-11e6-8fda-dad580c17c0a.png
[Syntax-Checkers]: https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers
[syntastic]: https://github.com/scrooloose/syntastic
[neomake]: https://github.com/neomake/neomake
[vim-plug]: https://github.com/junegunn/vim-plug
[tyru/current-func-info.vim]: https://github.com/tyru/current-func-info.vim
[jeetsukumaran/vim-gazetteer]: https://github.com/jeetsukumaran/vim-gazetteer
