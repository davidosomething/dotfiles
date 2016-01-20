# (g/n)vim config

Keep `(g)vimrc` (no dot in filename) in `.vim` -- vim knows to look in there.

See https://github.com/scrooloose/syntastic/wiki/Syntax-Checkers for getting
various linter support in syntastic.

## Setup

Comment out `runtime! archlinux.vim` from `/etc/vimrc` if you're on ArchLinux!

After starting vim with this setup, vim-plug will install itself. Run
`:PlugInstall` from within vim, and then restart vim.

## Paths

The default `runtimepath` has been modified from what vim comes with since I
find it to be insane to have system configs override user configs.

The `~/.dotfiles/vim` and `~/.dotfiles/vim/after` paths now come after system
config paths. See the runtimepath path section in `vimrc` for more comments.

### /

This is a vim runtimepath that will load after the user and system runtimepaths
but before the vim-plug ones. So `plugin/xyz.vim` will load before
`plug/vim/pluginname/plugin/name.vim`. Neovim plugins will be in `plug/nvim/`.

Use this for settings that must be set before a plugin is loaded. The global
variable `g:plugs`, which is a dictionary of plugin names and settings from
vim-plug, is available to before since it is created in the main `vimrc` file by
the `Plug` calls.

### after/

This is a vim runtimepath that will load after the system runtimepath but
before the vim-plug one. So `after/plugin/xyz.vim` will load after
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

Settings for various plugins have been interspersed into `plugin/`,
`after/plugin/plug-*.vim`, and `after/ftplugin/` as needed. There is generally
a wrapper around them that checks for `exists('g:plugs["plugin"])` so that is
an easy way to grep for them.

### Function Keys

- `<F1>` unite fuzzy search files
- `<F2>` unite fuzzy search most recently used files
- `<F3>` unite grep via ag
- `<F4>` --
- `<F5>` toggle solarized bg
- `<F6>` toggle indent guides
- `<F7>` OverCommandLine for subst
- `<F8>` unite command palette
- `<F9>` left pane: vimfiler
- `<F10>` unite outline
- `<F11>` --
- `<F12>` toggle paste mode

See `plugin/mappings.vim` for mappings not associated to vim-plug-managed
plugins.

