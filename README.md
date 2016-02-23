<img alt="dotfiles" width="200" src="https://cdn.rawgit.com/davidosomething/dotfiles/master/meta/dotfiles-logo.png">

My dotfiles. <https://github.com/davidosomething/dotfiles>

- OSX and Arch Linux compatible
- XDG compliance wherever possible to keep `$HOME` clean
    - See [Archlinux wiki for XDG Base Directory Support]
    - See [Debian DotFilesList]
    - See [grawity's dotfile notes] and [environ notes]
- ZSH and BASH configs
- VIM and Neovim configs
- RC files for lua, markdown, node, php, python, r, ruby, shell

![terminal screenshot][screenshot]
> Screenshot of the zsh prompt in tmux in termite on Arch Linux

## Installation

Clone and run the symlink script.

```bash
git clone --recurse-submodules https://git.io/vg0hV ~/.dotfiles
~/.dotfiles/bootstrap/symlink.sh
```

### Post-Installation

#### Recommended steps

- Create XDG child directories (run `bootstrap/xdg.sh`). The base directories
  are probably already initialized by
  `/etc/xdg/autostart/user-dirs-update-gtk.desktop`.

- Install and use [Fira (Fura) Mono for Powerline] font (install
  to `$XDG_DATA_HOME/fonts` on \*nix)

- Change default shell to zsh (ensure listed in `/etc/shells`) and
  restart shell (zplug will self-install)

- See OS specific notes in [osx/README.md](osx/README.md) and for linux
  [linux/README.md](linux/README.md) and [linux/arch.md](linux/arch.md)

#### Dev environment setup

Install these using the system package manager. For OSX there are helper
scripts.

- `chruby`, `ruby-install`, then use ruby-install to install a version of ruby
    - `bootstrap/osx/ruby.sh`
- Install [nvm](https://github.com/creationix/nvm) MANUALLY via git clone into
  `$XDG_CONFIG_HOME`, then use it to install a version of `node` (and
  consequently `npm`)
- `php`, `composer`, use composer to install `wp-cli`
    - `bootstrap/osx/php.sh`
- `pyenv`, `virtualenv`, then create a new env with a new python/pip
    - `bootstrap/osx/python.sh`

### Provisioning scripts

These will assist in installing things. Best to have the Environment set up
first.

- `bootstrap/cleanup.sh`
    - Moves some things into their XDG Base Directory supported directories
- `bootstrap/symlink.sh`
    - bash, zsh, ack, screen, (n)vim
- `npm/install.sh`
    - requires you set up nvm and install node first
    - install default packages
- `ruby/install-default-gems.sh`
    - requires you set up chruby and install a ruby first
- `bootstrap/osx/*.sh`
    - `alfred.sh` - Install alfred via brew cask -- requires cask.sh first
    - `brew.sh` - Install common brews
    - `cask.sh` - Install common casks
    - `dnsmasq.sh` - Install and setup dnsmasq for .dev domains (optional)
    - `install.sh` - symlink `.hushlogin`
    - `macvim.sh` - Install macvim via brew
    - `quicklook.sh` - Install quicklook plugins via brew cask
- `bootstrap/terminfo.sh`
    - copy/compile terminfo files for user to `~/.terminfo/*`
- `bootstrap/x11.sh`
    - symlink `.xbindkeysrc`, `.xprofile`

## Updating

The sourced `__dotfiles_main()` function is available as the alias `u`.
Use `u` without arguments for usage.

## Notes

- `bin/`
    - There's a [readme](bin/README.md) in `bin/` describing each
      script/binary. This directory is added to the `$PATH`.
- `local/`
    - Unversioned folder, put `zshrc`, `bashrc`, `npmrc`, and `gitconfig` here
      and they will automatically be sourced LAST by the default scripts.
- `git/`
    - The comment character was changed from `#` to `;` so I can use Markdown
      in my commit messages without trimming the headers as comments. This is
      also reflected in a custom vim highlighting syntax in
      `vim/after/syntax/gitcommit.vim`.
- `python/`
    - Just remember to never `sudo pip` anything. Set up a phpenv and pip
      install the [python/requirements.txt](python/requirements.txt) file.
- `vim/`
    - If `curl` is installed, [vim-plug](https://github.com/junegunn/vim-plug)
      will be downloaded and plugins will install on run. See
      [vim/README.md](vim/README.md) for more information.

### rc script source order

`echo $DKO_SOURCE` to see what files were loaded to get to the current shell
state. If you have node installed, the `dko-sourced`
([bin/dko-sourced](bin/dko-sourced)) command has better output formatting.

For X apps (no terminal) the value is probably:

    /etc/profile
    .xprofile
      shell/vars
        shell/xdg

---

#### Credits

> _Logo from [jglovier/dotfiles-logo]_

[screenshot]: https://cdn.rawgit.com/davidosomething/dotfiles/2016-02-22/meta/terminal.png
[Archlinux wiki for XDG Base Directory Support]: https://wiki.archlinux.org/index.php/XDG_Base_Directory_support
[grawity's dotfile notes]: https://github.com/grawity/dotfiles/blob/master/.dotfiles.notes
[environ notes]: https://github.com/grawity/dotfiles/blob/master/.environ.notes
[Debian DotFilesList]: https://wiki.debian.org/DotFilesList
[Fira (Fura) Mono for Powerline]: https://github.com/powerline/fonts
[jglovier/dotfiles-logo]: https://github.com/jglovier/dotfiles-logo

