# (g/n)vim config

Keep `(g)vimrc` (no dot in filename) in `.vim` -- vim knows to look in there.

See https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers for getting
various linter support in
[syntastic](https://github.com/scrooloose/syntastic/).

## Standards

Adhere to [vint](https://github.com/Kuniwak/vint) linting rules as much as
possible. Not using [vim-lint](https://github.com/syngan/vim-vimlint) for now
because it is slow to load.

Always try to keep as much in the main runtime as possible, using `after/`
sparingly.

## Setup

Comment out `runtime! archlinux.vim` from `/etc/vimrc` if you're on ArchLinux!

After starting vim with this setup,
[vim-plug](https://github.com/junegunn/vim-plug) will install itself. Run
`:PlugInstall` from within vim, and then restart vim.

## Paths

The default `&runtimepath` has been modified from what vim comes with since I
find it to be insane to have system configs override user configs. See the end
of the `vimrc` file.

The `~/.dotfiles/vim` and `~/.dotfiles/vim/after` paths now come after system
config paths. See the runtimepath path section in `vimrc` for more comments.

### /

This is a vim runtimepath that will load after the user and system runtimepaths
but before the vim-plug ones. So `plugin/xyz.vim` will load before
`plug/vim/pluginname/plugin/name.vim`. Neovim plugins will be in `plug/nvim/`.

Use this for settings that must be set before a plugin is loaded (i.e. the
plugin does not check for the existence of a setting on init). The global
variable `g:plugs`, which is a dictionary of plugin names and settings from
vim-plug, is available to before since it is created in the main `vimrc` file
by the `Plug` calls.

### after/

This is a runtimepath that will load after the system runtimepath but before
the vim-plug one. So `after/plugin/xyz.vim` will load after
`plug/vim/pluginname/plugin/name.vim`.

Use this for settings that should override or extend system or plugin settings.
This will take precedence over everything but local vimrc files.

### local vimrc

All local settings are loaded LAST (after all of the system, user, plugin, and
`*/after` runtimes).

They are expected to be in `~/.secret/vim/` and follow the standard vim
directory layout (`plugin/`, `syntax/`, `indent/`, etc.). A base (g)vimrc file
there is probably enough.

## Plugin settings

Settings for various plugins have been interspersed into `plugin/`, and a few
in `after/ftplugin/` as needed. There is generally a wrapper around them that
checks for `exists('g:plugs["plugin"])` so grepping for `g:plugs` is an easy
way to find them.

### Function Keys

Unite keys are arranged by search context from big to small

- `<F1>` unite fuzzy search files (filesystem)
- `<F2>` unite fuzzy search most recently used files (limited filesystem)
- `<F3>` unite grep via ag (project)
- `<F4>` unite buffers (current vim)
- `<F5>` unite outline (current buffer)
- `<F6>` unite gtags for queried word (project)
- `<F7>` unite gtags for word under cursor (project)
- `<F8>` unite command palette
- `<F9>` toggle indent guides
- `<F10>` left pane: vimfiler
- `<F11>` OverCommandLine for subst
- `<F12>` toggle paste mode

See `plugin/mappings.vim` for mappings not associated to vim-plug-managed
plugins.

## Junk defaults and unmapped keys

Plan to map these at some point

- n <C-b> -- back one screen (page)
- n <C-f> -- fore one screen (page)
- n <C-g> -- status
- n <C-s>

