# macOS/OS X

## Full generic setup, in order

User data on encrypted volumes other than the boot volume will not mount until
login. To remedy this, see [Unlock] (forked to my GitHub for archival).

### Install headers

Mojave no longer installs SDK headers for building certain things. It is
included with the OS, just run:

```sh
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
```

### App store

1. iCloud sign in
1. Install App store apps
    - `Display Menu` (free) - set higher/native resolutions on monitors

### Install dotfiles

1. `git clone https://github.com/davidosomething/dotfiles.git ~/.dotfiles/`
1. `~/.dotfiles/bootstrap/symlink`
1. `~/.dotfiles/bootstrap/cleanup`
1. `~/.dotfiles/bootstrap/terminfo`

### Install GPGTools and import key

1. Follow these instructions
   <https://gist.github.com/danieleggert/b029d44d4a54b328c0bac65d46ba4c65>

### Install homebrew

1. Install according to <https://brew.sh/>
1. `brew install` programs via `~/.dotfiles/mac/brew`, or pick as desired
    - Of note are `git`, `fzf`
1. Use ZSH as default
    - `brew install zsh`
    - `sudo -e /etc/shells` and add `/usr/local/bin/zsh`
    - `chsh -s /usr/local/bin/zsh`

1. Restart shell

### Setup ssh keys

1. `sshkeygen` (alias to generate new ed25519 keys)
1. Add the public key to GitHub, GitLab, Bitbucket, keybasefs, etc.

### Casks

- Install fonts - `~/.dotfiles/mac/fonts` to install via cask
- dropbox
    1. Has app settings sync so wait for it to finish syncing.
- iterm2
    - Load iTerm profile from synology drive
    - Or load colors from `~/.dotfiles/mac/iterm2` and set the TERM to
      `xterm-256color-italic`
- bettertouchtool
    - License in synology drive or gmail
    - Better trackpad swipe configs
    - Synced to Dropbox
- google-chrome
    - Login and sync google account for settings
- hammerspoon
    - Disable spotlight shortcut first
    - App launcher (cmd + space)
    - Audio output device switch in menubar
    - Auto-type from clipboard (cmd-ctrl + v)
    - Caffeinate in menubar
    - Window management (cmd-ctrl-shift + f/h/l/z)
- java
    - Or download from oracle if Java 8 or specific version needed
- kaleidoscope
    - Load license file
- gpg-suite-no-mail
    - Add device to keybase.io
    - Export key from keybase
    - Import key
    - Add User ID to key

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
- Install [nvm](https://github.com/nvm-sh/nvm) MANUALLY via git clone into
  `$XDG_CONFIG_HOME`, then use it to install a version of `node` (and `npm`)
    1. Use nvm managed node
    1. Install the default packages using [node/install](../node/install)
- Install [pyenv](https://github.com/pyenv/pyenv) using `pyenv-installer`
  (rm `~/.local/pyenv` directory for clean install) and make sure to use the
  libs provided by `brew openssl`
    1. `brew install openssl`
    1. Follow <https://github.com/yyuu/pyenv/wiki/Common-build-problems#error-the-python-ssl-extension-was-not-compiled-missing-the-openssl-lib>
    1. Set up the global pyenv as the latest stable (3.x)
    1. Set up python virtualenvs using [bootstrap/pyenv](../bootstrap/pyenv)

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
