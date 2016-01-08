<img alt="dotfiles" width="200"
src="https://raw.githubusercontent.com/davidosomething/dotfiles/master/bootstrap/dotfiles-logo.png">

My dotfiles. https://github.com/davidosomething/dotfiles

- OSX and ArchLinux compatible
- XDG compliance
- ZSH and BASH configs
- VIM and neovim configs (planning to split repo, though)
- Dev setup for lua, markdown, node, php, python, r, ruby, shell

# Installation

- Clone with submodules, and symlink:

```shell
git clone --recurse-submodules https://github.com/davidosomething/dotfiles.git ~/.dotfiles
~/.dotfiles/bootstrap/symlink.sh
```

- (OPTIONAL) Change default shell to zsh and restart now
- (OPTIONAL) Run the other scripts in the next section

## Working scripts

These will assist in installing things

- `bin/update`
    - Update various things. Aliased to `u`. Run `u` for usage.

- `bootstrap/cleanup.sh`
    - Moves some things into their XDG Base Directory suppored dirs

- `bootstrap/symlink.sh`
    - bash, zsh, ack, screen, (n)vim

- `npm/install.sh`
    - requires you set up nvm and install node first
    - install default packages

- `ruby/install-default-gems.sh`
  - requires you set up chruby and install a ruby first

- `bootstrap/osx/*.sh`
    - `install.sh` - symlink `.hushlogin`
    - `alfred.sh` - Install alfred via brew cask -- requires cask.sh first
    - `brew.sh` - Install common brews
    - `cask.sh` - Install common casks
    - `dnsmasq.sh` - Install and setup dnsmasq for .dev domains (optional)
    - `macvim.sh` - Install macvim via brew
    - `php.sh` - Install php56 via brew
    - `python.sh` - Install python3 via brew
    - `quicklook.sh` - Install quicklook plugins via brew cask
    - `ruby.sh` - Install chruby, ruby-install via brew, install latest ruby

- `linux/x11.sh`
    - symlink `.xbindkeysrc`, `.xinitrc`, `.xprofile`

## Notes

### bin/

There's a readme in `bin/` describing things.

### fonts/

Install these manually, either into `$XDG_DATA_HOME/fonts` or `~/Library/Fonts`

### git/

The comment character was changed from `#` to `;` so I can use Markdown in my
commit messages without trimming the headers as comments.  
This is also reflected in a custom vim highlighting syntax in
`vim/after/syntax/gitcommit.vim`.

### local/

Unversioned folder, put `zshrc`, `bashrc`, `npmrc`, and `gitconfig` here and
they will automatically be sourced LAST by the default scripts.

### Not included

You might want from your system package manager:

- chruby + ruby-install + a version of ruby
- nvm + a version of node + npm
- php/composer/wp-cli
- python/pip
- virtualenv + a version of python

### Source order

If you have node already, run `dko-sourced` (`bin/dko-sourced`) or just
`echo $DKO_SOURCE` to see what files are loaded.

For X apps (no terminal) the value is probably:

    /etc/profile
    .xprofile
      shell/vars
        shell/xdg

### node

Install via nvm, installed via `bin/update npm`, which uses latest git tag
instead of using your system package manager.

#### node-gyp

On arch use python 2 when installing node-gyp:

```shell
npm config set python /usr/bin/python2.7 -g
```

### python

Just remember to never `sudo pip` anything. Set up a virtualenv and pip install
the `python/requirements.txt` file.

### vim

See [vim/README.md](https://github.com/davidosomething/dotfiles/blob/master/vim/README.md)

---

> Logo from [jglovier/dotfiles-logo](https://github.com/jglovier/dotfiles-logo)

