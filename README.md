<img alt="dotfiles" width="200" src="https://cdn.rawgit.com/davidosomething/dotfiles/master/meta/dotfiles-logo.png">

My dotfiles. <https://github.com/davidosomething/dotfiles>

- I use macOS, Manjaro, and Debian. Limited Fedora support.
- [XDG] compliance wherever possible to keep `$HOME` clean
    - See [Arch Linux wiki for XDG Base Directory Support]
    - See [Debian DotFilesList]
    - See [grawity's notes] and [environ notes]
- ZSH (preferred) and BASH configs
- Neovim (preferred) and VIM configs
- RC files for Lua, markdownlint, node, PHP, python, R, and others

![terminal screenshot][screenshot]
> Screenshot of my ZSH prompt

My [/uses] post my be of interest to you!

## Installation

See macOS specific notes in [mac/README.md](mac/README.md)

Generally:

```sh
git clone https://github.com/davidosomething/dotfiles ~/.dotfiles
```

Then, run the [bootstrap/symlink](bootstrap/symlink) script for linux or
[bootstrap/mac](bootstrap/mac) for macOS.

After symlinking, [bootstrap/cleanup](bootstrap/cleanup) can detect and move
pre-existing dotfiles that conflict with these (mac does this).

### Dev environment setup

After symlinking and restarting shell, aliases will be available.
The `sshkeygen` alias will help in generating a new SSH key.

#### ruby

For user-land ruby, install [ruby-build], [its dependencies], and [asdf] and
[asdf-ruby]. Use `asdf` to install ruby.

#### node

For user-land node, install [fnm] using [bootstrap/fnm](bootstrap/fnm)

### python

For user-land python, use [pyenv-installer] to install [pyenv] and
[pyenv-virtualenv].

Create virtualenvs for Neovim using [bootstrap/pyenv](bootstrap/pyenv)

### Provisioning scripts

These will assist in installing packages and dotfiles. Best to have the
environment set up first.

- [bootstrap/cleanup](bootstrap/cleanup) moves some dotfiles into their XDG
  Base Directory supported directories and deletes unnecessary things (with
  confirmation).
- [bootstrap/mac](bootstrap/mac) provision macOS. Runs other bootstrappers.
- [bootstrap/pipx](bootstrap/pipx) installs python CLI tools using `pipx`
- [bootstrap/pyenv](bootstrap/pyenv) creates a Neovim pyenv and installs
  `pynvim`
- [bootstrap/symlink](bootstrap/symlink) symlinks rc files for bash, ZSH,
  ack, (Neo)vim, etc.

## Updating

`u` is an alias to [dot](bin/dot). Use `u` without arguments for usage.

## Notes

- `bin/`
    - There's a [readme](bin/README.md) in `bin/` describing each
      script/binary. This directory is in the `$PATH`.
- `git/`
    - The comment character is `#` instead of `;` so I can use Markdown
      in my commit messages without trimming the headers as comments. This is
      also reflected in a custom Vim highlighting syntax in
      `vim/after/syntax/gitcommit.vim`.
- `local/`
    - Unversioned folder, put `zshrc`, `bashrc`, `npmrc`, and `gitconfig` here
      and they will be automatically sourced, LAST, by the default scripts. _No
      dots on the filenames._
- `neovim/`
    - [nvim/README.md](nvim/README.md) for more information.
- `python/`
    - Never `sudo pip`. Set up a [pyenv], and use a [pyenv-virtualenv].
- `vim/`
    - If `curl` and `git` are available,
      [vim-plug](https://github.com/junegunn/vim-plug) can automatically
      download and install itself on first run.
    - See [vim/README.md](vim/README.md) for more information.

### rc script source order

If you have node installed, the [dkosourced](bin/dkosourced) command will show
you (not exhaustively) the order scripts get sourced. Without node `echo
$DKO_SOURCE` works.

For X apps (no terminal) the value may be:

```text
/etc/profile
.xprofile
  shell/vars
    shell/xdg
```

## Shell script code style

- **Script architecture**
    - Use the `#!/usr/bin/env bash` shebang and write with bash compatibility
    - Create a private main function with the same name as the shell script.
      E.g. for a script called `fun`, there should be a `__fun()` that gets
      called with the original arguments `__fun $@`
    - Two space indents
    - Prefer `.` over `source`
- **Function names**
    - For private functions in a script, use two underscores `__private_func()`
      These function names are safe to reuse after running the script once. When
      namespaced, they are in the form of `__dko_function_name()`.
- **Variable interpolation**
    - Always use curly braces around the variable name when interpolating in
      double quotes.
- **Variable names**
    - Stick to nouns, lower camel case
- **Variable scope**
    - Use `local` and `readonly` variables as much as possible over
      global/shell-scoped variables.
- **Comparison**
    - Not strict on POSIX, but portability
    - Do NOT use BASH arrays, use ZSH or Python if need something complicated
    - Use BASH `==` for string comparison
    - Use BASH `(( A == 2 ))` for integer comparison (note not `$A`, `$` not
      needed)

## Credits

> _Logo from [jglovier/dotfiles-logo]_

[asdf]: https://github.com/asdf-vm/asdf
[asdf-ruby]: https://github.com/asdf-vm/asdf-ruby
[Arch Linux wiki for XDG Base Directory Support]: https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
[Debian DotFilesList]: https://wiki.debian.org/DotFilesList
[XDG]: https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
[environ notes]: https://github.com/grawity/dotfiles/blob/master/.environ.notes
[grawity's notes]: https://github.com/grawity/dotfiles/blob/master/.dotfiles.notes
[its dependencies]: https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
[jglovier/dotfiles-logo]: https://github.com/jglovier/dotfiles-logo
[fnm]: https://github.com/Schniz/fnm
[pyenv-installer]: https://github.com/yyuu/pyenv-installer
[pyenv-virtualenv]: https://github.com/pyenv/pyenv-virtualenv
[pyenv]: https://github.com/pyenv/pyenv
[ruby-build]: https://github.com/rbenv/ruby-build
[screenshot]: https://raw.githubusercontent.com/davidosomething/dotfiles/8fa3d6a738ed39ff2b8ba7a5d9126b59d895b538/meta/terminal-potatopro.png
[/uses]: https://www.davidosomething.com/uses/
