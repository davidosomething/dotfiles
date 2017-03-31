# macOS/OS X

## Full generic setup, in order

If there is user data on encrypted volumes other than the boot volume, they
will not mount until a user has logged in. To remedy this, see
[Unlock] (forked to my GitHub for archival).

### Install App Store apps

- `Amphetamine` - better than caffeine
- `Display Menu` - for setting native resolutions on monitors
- `xcode`
    - Then run `xcode-select --install` to prompt for CLI tools.

### Install homebrew

<http://brew.sh/>

### Install git from brew

See `bootstrap/mac/brew`

### Setup ssh keys

1. `ssh-keygen` for the new system
1. Load the private key into `ssh-agent` and the macOS keychain using `keychain`
1. Add the public key to GitHub and GitLab

### Install dotfiles

1. `git clone` for `~/.dotfiles/`
1. `~/.dotfiles/bootstrap/symlink`
1. `~/.dotfiles/mac/defaults` -- set apple defaults and fix some issues like
   zsh startup
1. `git clone` for `~/.secrets` and link as needed

### Install zsh and set as default

```sh
brew install zsh
chsh -s /usr/local/bin/zsh
```

### Install Powerline patched fonts from source

1. `git clone https://github.com/powerline/fonts ~/src/fonts`
1. Run `install.sh`

### Install iterm2 from brew

1. Install `iterm2-beta`, which is technically iterm3:
    ```sh
    brew tap caskroom/versions
    brew cask install iterm2-beta
    ```
1. Set up fonts (Fura Mono for Powerline, see _Powerline patched fonts_ above)
1. Set up base16 from <https://github.com/chriskempson/base16-iterm2> or
   start app -> Preferences -> Load preferences from custom folder, point to
   existing plist exports.

### Install neovim

1. Follow <https://github.com/neovim/homebrew-neovim> for HEAD. `u neovim` can
   do this automatically.
1. Launch `nvim` and let `vim-plug` install itself

### Install keepassx from source

Some of the requirements to `brew install` first:

- cmake
- libgcrypt
- oath-toolkit

Install keepassx 2.0 with http support from the source of this fork (inspect
diff first):
<https://github.com/eugenesan/keepassx/tree/2.0-http-totp>

Run the `cmake -DCMAKE_BUILD_TYPE=Release` step until it builds (it will tell
you what dependencies are missing each time, and install dependencies with
brew).

### Install from brew

Install packages from [bootstrap/mac/brew](../bootstrap/mac/brew) as
desired.

### Install from cask

- bettertouchtool
    - License acquired
    - Provide window snapping
    - Provide better trackpad swipe configs
- google-chrome
    - Login and sync google account for settings
    - Provides `authy`
- dropbox
    - Then setup keepassx to load the key database from dropbox
- kaleidoscope
    - Load license file
- transmission
    - Load blocklist `http://john.bitsurge.net/public/biglist.p2p.gz`

Install the rest of the packages from
[bootstrap/mac/cask](../bootstrap/mac/cask) as desired.

### Install development tools

Make sure you've installed packages since after you start using `pyenv` it
gets annoying to remember to switch back to system python for each `brew`
operation. Use the `bi` alias for a clean room install if possible.

- Install `chruby`, `ruby-install`
    1. `ruby-install ruby` to install latest
    1. `chruby` to that version
    1. Install gems using
       [ruby/install-default-gems](../ruby/install-default-gems)
- Install [nvm](https://github.com/creationix/nvm) MANUALLY via git clone into
  `$XDG_CONFIG_HOME`, then use it to install a version of `node` (and `npm`)
    1. Use nvm managed node
    1. Install the default packages using [node/install](../node/install)
- Install `pyenv` using `pyenv-installer` (rm `~/.local/pyenv` directory for
  clean install) and make sure to use the libs provided by `brew openssl`
    1. `brew install openssl`
    1. Follow <https://github.com/yyuu/pyenv/wiki/Common-build-problems#error-the-python-ssl-extension-was-not-compiled-missing-the-openssl-lib>
    1. Set up the global pyenv as the latest stable (3.x.x)
    1. Set up python virtualenvs called `neovim{2,3}` -- the Neovim
       configuration expects to find those. E.g.,
        1. `pyenv install 2.7.12`
        1. `pyenv virtualenv 2.7.12 neovim2`
        1. `pyenv activate neovim2`
        1. `pip install neovim`
- run [bootstrap/terminfo](../bootstrap/terminfo) (added terminfo for iterm with italics support)
- Install `gpgtools` from `brew cask` (it provides `gpg-agent` and can store
  passphrase in keychain with minimal work)
    - Import keybase public/private keys into gpg using the pref pane.
    - Setup `local/gitconfig` to sign commits

## Reduce desktop icon size

Click desktop to focus Finder, `cmd-j` use smallest sizes for everything.

## Source order

- zshenv
    - shell/vars
        - shell/xdg
- /etc/zprofile
- zsh/.zprofile
- zshrc
    - shell/before
        - shell/path
        - shell/os
        - shell/functions
        - shell/x11
        - shell/aliases
        - shell/node
            - nvm
            - avn
        - shell/python
        - shell/ruby
            - chruby
    - zplug
        - keybindings.zsh
        - prompt.zsh
        - title.zsh
    - fzf
    - shell/after
        - travis
    - .secret/local/shellrc


[Unlock]: https://github.com/davidosomething/Unlock
