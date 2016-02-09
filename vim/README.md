# (g/n)vim config

> Don't use what you don't understand.

## Installation

Best used with rest of dotfiles. Should self-install plugins via curl and
[vim-plug] on first load.

Keep `(g)vimrc` (no dot in filename) in `.vim` -- Vim knows to look in there.

See [Syntax-Checkers] in the [syntastic] wiki for getting
various linter support in [syntastic].

### Arch Linux

Comment out `runtime! archlinux.vim` from `/etc/vimrc` if you're on Arch Linux!

## Usage

### Paths

#### / (dotfiles/vim root)

This is a Vim runtimepath that will load after the user and system runtimepaths
but before the vim-plug ones. So `plugin/xyz.vim` will load before
`plug/vim/pluginname/plugin/name.vim`. Neovim plugins will be in `plug/nvim/`.

Use this for settings that must be set before a plugin is loaded (i.e. the
plugin does not check for the existence of a setting on init). The global
variable `g:plugs`, which is a dictionary of plugin names and settings from
vim-plug, is available to before since it is created in the main `vimrc` file
by the `Plug` calls.

#### after/

This is a runtimepath that will load after the system runtimepath but before
the vim-plug one. So `after/plugin/xyz.vim` will load after
`plug/vim/pluginname/plugin/name.vim`.

Use this for settings that should override or extend system or plugin settings.
This will take precedence over everything but local vimrc files.

### local vimrc

Local `vimrc`s are expected to be in `~/.secret/vim/` and follow the standard
Vim directory layout (`plugin/`, `syntax/`, `indent/`, etc.). A base (g)vimrc
file there is probably enough.

All local settings are loaded LAST (after all of the system, user, plugin, and
`*/after` runtimes).

### Plugin settings

Settings for various plugins have been interspersed into `plugin/`, and a few
in `after/ftplugin/` as needed. There is generally a wrapper around them that
checks for `exists('g:plugs["plugin"])` so grepping for `g:plugs` is an easy
way to find them.

#### Super-non-standard keys

- EasyClip changes behavior of pretty much all register operations (`[y]ank`,
  `[d]elete`, `[s]ubstitute`, etc.). Prefer `[y]ank` or explicitly `[m]ove` to
  populate registers.
- `[s]ubstitute` has been remapped to vim-operator-surround
- A bunch of `c` mappings are now operators that toggle camelcase (e.g., `cc`
  which was previously equivalent to `C`). See `plugin/operator.vim`
- normal `<C-g>` -- gitgutter toggle (originally file status)

#### Function Keys

Unite keys are arranged by search context from small (current buf) to big
(filesystem). I use the `<F4>` for MRU the most.

|     Key | Desc |
| ------: | :--- |
| `<F1>`  | left pane: vimfiler |
| `<F2>`  | right pane: unite outline (current buffer) |
| `<F3>`  | unite buffers (current instance) |
| `<F4>`  | unite most recently used files (limited filesystem) |
| `<F5>`  | unite fuzzy search files (filesystem) |
| `<F6>`  | unite grep via ag (from PWD) |
| `<F7>`  | unite tag/gtags for queried word (project) |
| `<F8>`  | unite tag/gtags for word under cursor (project) |
| `<F9>`  | unite command palette |
| `<F10>` | OverCommandLine for subst |
| `<F11>` | toggle indent guides |
| `<F12>` | toggle paste mode |

See `plugin/mappings.vim` (and other plugin/* files) for mappings not
associated to vim-plug-managed plugins.

### Junk defaults and unmapped keys

Plan to map these at some point

- n <C-b> -- back one screen (page)
- n <C-f> -- fore one screen (page)
- n <C-s>
- n zh/l  -- useless wrap mode scroll

## My Vim conventions

Adhere to [vint](https://github.com/Kuniwak/vint) linting rules as much as
possible. Not using [vim-lint](https://github.com/syngan/vim-vimlint) for now
because it is slow to load (syntastic is synchronous).

Always try to keep as much in the main runtime as possible, using `after/`
sparingly (mostly for `setlocal` ftplugin settings).

### VimL Coding

- `s:FunctionName`
- `l:local_variable`
- `dkoautocommandgroup`



[Syntax-Checkers]: https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers
[syntastic]: https://github.com/scrooloose/syntastic/
[vim-plug]: https://github.com/junegunn/vim-plug

