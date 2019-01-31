# macOS/OS X

## Full generic setup, in order

User data on encrypted volumes other than the boot volume will not mount until
login. To remedy this, see [Unlock] (forked to my GitHub for archival).

### App store

1. iCloud sign in
1. Install App store apps
    - `Display Menu` (free) - set higher/native resolutions on monitors

### Install dotfiles

1. `git clone https://github.com/davidosomething/dotfiles.git ~/.dotfiles/`
1. `~/.dotfiles/bootstrap/symlink`

### Install homebrew

1. Install according to <https://brew.sh/>
1. `brew install` programs via `~/.dotfiles/mac/brew`, or pick as desired
    - Of note are `git`, `fzf`
1. Use ZSH as default
    - Add `/usr/local/bin/zsh` to `/etc/shells`, then
      ```sh
      chsh -s /usr/local/bin/zsh
      ```
1. Restart shell

### Setup ssh keys

1. `sshkeygen` (alias to generate new ed25519 keys)
1. Add the public key to GitHub, GitLab, Bitbucket, keybasefs, etc.

### Casks

- Install fonts - `~/.dotfiles/mac/fonts` to install via cask
- spideroakone
    1. Create new backup folder `sync`
    1. Sync with existing `sync` to get iTerm profile
- iterm2
    1. Load iTerm profile from oak sync
- bettertouchtool
    - License in oak
    - Import from oak sync
    - Provide window snapping
    - Provide better trackpad swipe configs
- dropbox
- google-chrome
    - Login and sync google account for settings
    - Provides `authy`
- java
- kaleidoscope
    - Load license file
- keybase
    - Add device to keybase.io
    - Export key from keybase
    - `brew cask install gpgtools`
    - Import key into gpgtools
    - Add User ID to key
    - Update key in keybase

Install the rest of the packages from
[bootstrap/mac/cask](../bootstrap/mac/cask) as desired.

### Install development tools

Installed packages before development tools. After you start using `pyenv` it
gets annoying to remember to switch back to system python for each `brew`
operation. Use the `bi` alias for a clean room install if possible.

- Increase file limits a la
  <https://github.com/karma-runner/karma/issues/1979#issuecomment-260790451>
    - See <https://gist.github.com/abernix/a7619b07b687bb97ab573b0dc30928a0> if
      there are still file limit issues
    - REBOOT for `ulimit -n` changes to take effect
- Install `chruby`, `ruby-install`
    1. `ruby-install ruby` to install latest
    1. `chruby` to that version
    1. Install gems using [ruby/install-default-gems](../ruby/install-default-gems)
- Install [nvm](https://github.com/creationix/nvm) MANUALLY via git clone into
  `$XDG_CONFIG_HOME`, then use it to install a version of `node` (and `npm`)
    1. Use nvm managed node
    1. Install the default packages using [node/install](../node/install)
- Install `pyenv` using `pyenv-installer` (rm `~/.local/pyenv` directory for
  clean install) and make sure to use the libs provided by `brew openssl`
    1. `brew install openssl`
    1. Follow <https://github.com/yyuu/pyenv/wiki/Common-build-problems#error-the-python-ssl-extension-was-not-compiled-missing-the-openssl-lib>
    1. Set up the global pyenv as the latest stable (3.x.x)
    1. Set up python virtualenvs called `neovim{2,3}` -- the Neovim configuration expects to find those. E.g.,
        ```sh
        pyenv install 2.7.xx
        pyenv virtualenv 2.7.xx neovim2
        pyenv activate neovim2
        pip install neovim
        pyenv deactivate
        ```
- run [bootstrap/terminfo](../bootstrap/terminfo) (added terminfo for iTerm
  with italics support)
- Install `gpgtools` from `brew cask` (it provides `gpg-agent` and can store
  passphrases in the OS keychain with minimal work)
    - Import keybase public/private keys into gpg using the pref pane.
    - Setup `local/gitconfig` to sign commits

## Reduce desktop icon size

Click desktop to focus Finder, `cmd-j` use smallest sizes for everything.

## Example source order

This is an example -- see output of `dkosourced` for up-to-date version.

- zshenv
    - shell/init.bash
        - shell/{xdg,vars,os}.bash
- /etc/zprofile
- zsh/.zprofile
- zshrc
    - shell/interactive.bash
        - shell/{path,helpers,functions,aliases}.bash
        - shell/{java,node,php,python,ruby}.bash
    - prompt-{vcs,vimode}.zsh
    - prompt.zsh
    - title.zsh
    - fzf.zsh
    - zplugin
    - shell/after
    - .secret/local/shellrc


[Unlock]: https://github.com/davidosomething/Unlock
