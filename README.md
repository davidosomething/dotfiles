<img alt="dotfiles" width="200" src="https://cdn.rawgit.com/davidosomething/dotfiles/master/meta/dotfiles-logo.png">

[![Build Status](https://travis-ci.org/davidosomething/dotfiles.svg?branch=dev)](https://travis-ci.org/davidosomething/dotfiles) [![Updates](https://pyup.io/repos/github/davidosomething/dotfiles/shield.svg)](https://pyup.io/repos/github/davidosomething/dotfiles/)

My dotfiles. <https://github.com/davidosomething/dotfiles>

- I use macOS, Manjaro, and Debian. Limited Fedora support.
- [XDG] compliance wherever possible to keep `$HOME` clean
    - See [Arch Linux wiki for XDG Base Directory Support]
    - See [Debian DotFilesList]
    - See [grawity's notes] and [environ notes]
- ZSH (preferred) and BASH configs
- Neovim (preferred) and VIM configs
- RC files for Lua, markdownlint, node, PHP, python, R, ruby, and others

![terminal screenshot][screenshot]
> Screenshot of my ZSH prompt

My [/uses] post my be of interest to you!

## Installation

See macOS specific notes in [mac/README.md](mac/README.md)

Generally:

```sh
git clone --recurse-submodules https://github.com/davidosomething/dotfiles ~/.dotfiles
```

Then, run the [bootstrap/symlink](bootstrap/symlink) script for linux or
[bootstrap/mac](bootstrap/mac) for macOS.

After symlinking, [bootstrap/cleanup](bootstrap/cleanup) can detect and move
pre-existing dotfiles that conflict with these (mac does this).

### Dev environment setup

Install these using the system package manager. For macOS/OS X there are helper
scripts.

- For user-land ruby, install [chruby] and `ruby-install`. Then, use
  `ruby-install` to install a version of ruby. Preferably install the latest
  ruby. The dotfiles alias ruby-install to use `${XDG_DATA_HOME}/rubies` as the
  installation path.

  ```sh
  ruby-install --latest ruby
  ```

- For user-land node, install [fnm] using [bootstrap/fnm](bootstrap/fnm)
- `php`, `composer`, use composer to install `wp-cli`
- For user-land python, use [pyenv-installer] to install [pyenv] and
  [pyenv-virtualenv].
    - Create virtualenvs for Neovim using [bootstrap/pyenv](bootstrap/pyenv)

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
- [node/install](node/install) install default packages, requires you set up
  [fnm] and install node first
- [ruby/install-default-gems](ruby/install-default-gems) requires you set up
  [chruby] and install a ruby first.
- [python/install](python/install) installs default pip packages. Requires
  [pyenv] already set up

## Updating

`u` is an alias to [dot](bin/dot). Use `u` without arguments for usage.

## Notes

- `bin/`
    - There's a [readme](bin/README.md) in `bin/` describing each
      script/binary. This directory is in the `$PATH`.
- `local/`
    - Unversioned folder, put `zshrc`, `bashrc`, `npmrc`, and `gitconfig` here
      and they will be automatically sourced, LAST, by the default scripts. _No
      dots on the filenames._
- `git/`
    - The comment character is `#` instead of `;` so I can use Markdown
      in my commit messages without trimming the headers as comments. This is
      also reflected in a custom Vim highlighting syntax in
      `vim/after/syntax/gitcommit.vim`.
- `python/`
    - Never `sudo pip`. Set up a [pyenv], and use a [pyenv-virtualenv].
- `ruby/`
    - Never `sudo gem`. Set up a [chruby] env first, and then you can install
      gems into the userspace local to the active ruby env.
- `vim/`
    - If `curl` and `git` are available,
      [vim-plug](https://github.com/junegunn/vim-plug) can automatically
      download and install itself on first run. See
      [vim/README.md](vim/README.md) for more information.

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

[Arch Linux wiki for XDG Base Directory Support]: https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
[Debian DotFilesList]: https://wiki.debian.org/DotFilesList
[Fira (Fura) Mono for Powerline]: https://github.com/powerline/fonts
[XDG]: https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
[chruby]: https://github.com/postmodern/chruby
[environ notes]: https://github.com/grawity/dotfiles/blob/master/.environ.notes
[google shell style]: https://google.github.io/styleguide/shell.xml
[grawity's notes]: https://github.com/grawity/dotfiles/blob/master/.dotfiles.notes
[jglovier/dotfiles-logo]: https://github.com/jglovier/dotfiles-logo
[fnm]: https://github.com/Schniz/fnm
[pyenv-installer]: https://github.com/yyuu/pyenv-installer
[pyenv-virtualenv]: https://github.com/pyenv/pyenv-virtualenv
[pyenv]: https://github.com/pyenv/pyenv
[screenshot]: https://raw.githubusercontent.com/davidosomething/dotfiles/8fa3d6a738ed39ff2b8ba7a5d9126b59d895b538/meta/terminal-potatopro.png
[/uses]: https://www.davidosomething.com/uses/

