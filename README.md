<img alt="dotfiles" width="200" src="https://cdn.rawgit.com/davidosomething/dotfiles/master/meta/dotfiles-logo.png">

[![Build Status](https://travis-ci.org/davidosomething/dotfiles.svg?branch=master)](https://travis-ci.org/davidosomething/dotfiles) [![Updates](https://pyup.io/repos/github/davidosomething/dotfiles/shield.svg)](https://pyup.io/repos/github/davidosomething/dotfiles/)

My dotfiles. <https://github.com/davidosomething/dotfiles>

- macOS/OS X, Arch Linux, and Debian compatible
- [XDG] compliance wherever possible to keep `$HOME` clean
    - See [Archlinux wiki for XDG Base Directory Support]
    - See [Debian DotFilesList]
    - See [grawity's dotfile notes] and [environ notes]
- ZSH and BASH configs
- VIM and Neovim configs
- RC files for Lua, markdown, node, PHP, python, R, ruby, and others

![terminal screenshot][screenshot]
> Screenshot of my ZSH prompt

## Installation

_For mac, see full install details in [mac/README.md](mac/README.md)._

Clone and run the symlink script:

```sh
git clone --recurse-submodules https://github.com/davidosomething/dotfiles ~/.dotfiles
~/.dotfiles/bootstrap/symlink
```

After symlinking, `~/.dotfiles/bootstrap/cleanup` can detect and move
pre-existing dotfiles that might conflict with these.

### Post-Installation

#### Recommended steps

- Create XDG child directories (run `bootstrap/xdg`). The base directories
  are probably already initialized by
  `/etc/xdg/autostart/user-dirs-update-gtk.desktop`.
- Install and use [Fira (Fura) Mono for Powerline] font (install
  to `${XDG_DATA_HOME}/fonts` on \*nix)
- Install ZSH and set it as the default (ensure its presence in
  `/etc/shells`); restart the terminal and zplugin will self-install
- See OS specific notes in [mac/README.md](mac/README.md) and
  [linux/README.md](linux/README.md) and [linux/arch.md](linux/arch.md)
- Useful Chrome extensions are in [chromium/README.md](chromium/README.md)
- Install node and the default npm packages; `rm` will then alias to the
  [trash-cli] script.

#### Dev environment setup

Install these using the system package manager. For macOS/OS X there are helper
scripts.

- `chruby`, `ruby-install`, then use `ruby-install` to install a version of
  ruby (preferably latest)
- Install [nvm](https://github.com/creationix/nvm) MANUALLY via git clone into
  `$XDG_CONFIG_HOME`, then use it to install a version of `node` (and
  `npm install --global npm@latest`)
- `php`, `composer`, use composer to install `wp-cli`
- Use [pyenv-installer] for [pyenv], [pyenv-virtualenv], then create a new env
  with a new python/pip.
    - Create virtualenvs for Neovim.

### Provisioning scripts

These will assist in installing packages and dotfiles. Best to have the
Environment set up first.

- `bootstrap/cleanup` moves some dotfiles into their XDG Base Directory
  supported directories
- `bootstrap/symlink` symlinks rc files for bash, ZSH, ack, (Neo)vim, etc.
- `bootstrap/terminfo` will copy/compile terminfo files for user to
  `~/.terminfo/*`
- `bootstrap/x11` symlinks `.xbindkeysrc`, `.xprofile`
- `npm/install` install default packages, requires you set up nvm and
  install node first
- `ruby/install-default-gems` requires you set up chruby and install a ruby
  first.
- `python/install` installs default pip packages. Requires [pyenv] already set
  up,

## Updating

The sourced `dko.dotfiles.main()` function is available as the alias `u`.
Use `u` without arguments for usage.

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
    - Never `sudo pip`. Set up a [pyenv], and use a [pyenv-virtualenv] (which
      will delegate to `pyvenv`) if doing project specific work, and
      `pip install` into that userspace [pyenv] or virtualenv.
- `ruby/`
    - Never `sudo gem`. Set up a [chruby] env first, and then you can install
      gems into the userspace local to the active ruby env.
- `vim/`
    - If `curl` is available, [vim-plug](https://github.com/junegunn/vim-plug)
      can automatically download and install itself on first run. See
      [vim/README.md](vim/README.md) for more information.

### rc script source order

If you have node installed, the `dko-sourced`
([bin/dko-sourced](bin/dko-sourced)) command will show you (not exhaustively)
the order scripts get sourced. Without node `echo $DKO_SOURCE` works.

For X apps (no terminal) the value is probably:

    /etc/profile
    .xprofile
      shell/vars
        shell/xdg

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
      These function names are safe to reuse after script execution. When
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

[Archlinux wiki for XDG Base Directory Support]: https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
[Debian DotFilesList]: https://wiki.debian.org/DotFilesList
[Fira (Fura) Mono for Powerline]: https://github.com/powerline/fonts
[XDG]: https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
[chruby]: https://github.com/postmodern/chruby
[environ notes]: https://github.com/grawity/dotfiles/blob/master/.environ.notes
[google shell style]: https://google.github.io/styleguide/shell.xml
[grawity's dotfile notes]: https://github.com/grawity/dotfiles/blob/master/.dotfiles.notes
[jglovier/dotfiles-logo]: https://github.com/jglovier/dotfiles-logo
[pyenv-installer]: https://github.com/yyuu/pyenv-installer
[pyenv-virtualenv]: https://github.com/pyenv/pyenv-virtualenv
[pyenv]: https://github.com/pyenv/pyenv
[screenshot]: https://raw.githubusercontent.com/davidosomething/dotfiles/0f8a58661c3a3c111d9cc1332d5ab3962aaf1dd9/meta/terminal-potatopro.png
[trash-cli]: https://github.com/sindresorhus/trash-cli
