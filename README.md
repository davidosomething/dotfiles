<img alt="dotfiles" width="200" src="https://cdn.rawgit.com/davidosomething/dotfiles/master/meta/dotfiles-logo.png">

My dotfiles. <https://github.com/davidosomething/dotfiles>  
My [/uses] post may be of interest to you!

![terminal screenshot][screenshot]

> Screenshot of my Zsh prompt

| Tool              | Link                             |
| ----------------- | -------------------------------- |
| OS support        | Arch, macOS, Debian, Ubuntu      |
| Terminal emulator | [WezTerm](./wezterm/wezterm.lua) |
| Font              | [Maple Mono]                     |
| Shell             | [Zsh](./zsh/dot.zshrc)           |
| Shell plugins     | [Zinit](./zsh/zinit.zsh)         |
| Editor            | [Neovim](./nvim/README.md)       |
| Tooling/env       | [mise]                           |

- [XDG] compliance wherever possible to keep `$HOME` clean
  - See [Arch Linux wiki for XDG Base Directory Support]
  - See [Debian DotFilesList]
  - See [grawity's notes] and [environ notes]
- RC files for Lua, markdownlint, node, PHP, python, R, and others

## Installation

See macOS specific notes in [mac/README.md](./mac/README.md)

Generally:

```sh
git clone https://github.com/davidosomething/dotfiles ~/.dotfiles
```

Then, run the [bootstrap/symlink](./bootstrap/symlink) script.

After symlinking, **restart the shell**. Aliases will be available.
The `sshkeygen` alias will help in generating a new SSH key.

Run [bootstrap/cleanup](./bootstrap/cleanup) to clean up stray dotfiles, moving
into their XDG Base Directory supported directories and deleting unnecessary
things (with confirmation).

## Updating

`u` is an alias to [dot](./bin/dot). Use `u` without arguments for usage.

## Notes

- `bin/`
  - There's a [readme](./bin/README.md) in `bin/` describing each
    script/binary. This directory is in the `$PATH`.
- `git/`
  - The comment character is `#` instead of `;` so I can use Markdown
    in my commit messages without trimming the headers as comments. This is
    also reflected in a custom Vim highlighting syntax
- `nvim/`
  - See [nvim/README.md](./nvim/README.md) for more information.
- `python/`
  - Never `sudo pip`. Set up a python virtual environment.

Local dotfiles are read from `$LDOTDIR`.

- Put files `zshrc`, `bashrc`, `npmrc`, and `gitconfig` here
  and they will be automatically sourced, LAST, by the default scripts.
  _No dots on the filenames (i.e. not `.zshrc`)._

### rc script source order

If you have node installed, the [dkosourced](./bin/dkosourced) command will show
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
- **Function bodies**
  - Never use the `fn() ( subshell body in parentheses )` format, always use
    curly braces first for consistency: `fn() { ( subshell body ); }`.
- **Variable interpolation**
  - Always use curly braces around the variable name when interpolating in
    double quotes.
- **Variable names**
  - Stick to nouns, lower camel case
- **Variable scope**
  - Use `local` and `readonly` variables as much as possible over
    global/shell-scoped variables.
- **Comparison**
  - Not strict on POSIX (e.g. assume my interactive shells are at least BASH)
  - Do NOT use BASH arrays, use Zsh or Python if need something complicated
  - Use BASH `==` for string comparison
  - Use BASH `(( A == 2 ))` for integer comparison (note not `$A`, `$` not
    needed)

## Credits

> _Logo from [jglovier/dotfiles-logo]_

[Arch Linux wiki for XDG Base Directory Support]: https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
[Debian DotFilesList]: https://wiki.debian.org/DotFilesList
[environ notes]: https://github.com/grawity/dotfiles/blob/master/.environ.notes
[grawity's notes]: https://github.com/grawity/dotfiles/blob/master/.dotfiles.notes
[jglovier/dotfiles-logo]: https://github.com/jglovier/dotfiles-logo
[mise]: https://github.com/jdx/mise
[screenshot]: https://raw.githubusercontent.com/davidosomething/dotfiles/meta/meta/terminal-potatosff.png
[/uses]: https://www.davidosomething.com/uses/
[XDG]: https://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
[Maple Mono]: https://github.com/subframe7536/maple-font
