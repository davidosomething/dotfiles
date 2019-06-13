# macOS/OS X

## Full generic setup, in order

User data on encrypted volumes other than the boot volume will not mount until
login. To remedy this, see [Unlock] (forked to my GitHub for archival).

### Disable some keyboard shortcuts

Remove these using System Preferences:

- `Mission Control` owns Control-left and Control-right
- `Spotlight` owns Command-space

### Reduce desktop icon size

Click desktop to focus Finder, `cmd-j` use smallest sizes for everything.

### App store

1. iCloud sign in
1. Install App store apps
   - `Display Menu` (free) - set higher/native resolutions on monitors
   - `Xcode` - select CLI tools in prefs

### Install homebrew

1. Install according to <https://brew.sh/>. Install bundles in a later step.

### Install dotfiles

```sh
git clone https://github.com/davidosomething/dotfiles.git ~/.dotfiles/
```

### Install headers and run bootstrap

This will run other bootstrappers too:

```sh
~/.dotfiles/bootstrap/mac
```

Mojave no longer installs SDK headers for building certain things. It comes
with mac OS but requires manual execution. The
[bootstrap/mac](../bootstrap/mac) script will install it and run the rest of
the mac bootstrapper including `brew bundle` for the default packages.
Bundle dumps for specific systems are in my `~/.secret` (not public).

`./compile dotfiles.plist.json` generates the `dotfiles.plist` file in the
`mac/LaunchAgents` directory. It depends on the `plist` package from npm.

See homebrew notes in `~/.dotfiles/mac/brew.md` for other things I install.

### ZSH

1. Use ZSH as the default shell (default in Catalina)

  ```sh
  sudo -e /etc/shells # add /usr/local/bin/zsh (the brewed zsh)
  chsh -s /usr/local/bin/zsh
  ```

1. Restart shell

### Setup ssh keys

1. `sshkeygen` (alias to generate new ed25519 keys)
1. Add the public key to GitHub, GitLab, Bitbucket, keybasefs, etc.

### Install GPGTools and import key

1. Install the [dotfiles.plist](LaunchAgents/dotfiles.plist) first! It sets
   `GNUPGHOME` in the env for all apps. See the bootstrapping section above.
1. Follow these instructions
   <https://gist.github.com/danieleggert/b029d44d4a54b328c0bac65d46ba4c65>  
   then
    - Export key from keybase
    - Import key
    - Add User ID to key

### Casks

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

Install the rest of the packages from
[bootstrap/mac/cask](../bootstrap/mac/cask) as desired.

### Install development tools

Installed packages before development tools. After you start using `pyenv` it
gets annoying to remember to switch back to system python for each `brew`
operation. Use the `bi` alias for a clean room install if possible.

- Increase file limits a la
  <https://github.com/karma-runner/karma/issues/1979#issuecomment-260790451>
    - See <https://gist.github.com/abernix/a7619b07b687bb97ab573b0dc30928a0>
      if there are still file limit issues
    - REBOOT for `ulimit -n` changes to take effect
- Install `chruby`, `ruby-install`
  1. `ruby-install ruby` to install latest
  1. `chruby` to that version
  1. Install gems using [ruby/install-default-gems](../ruby/install-default-gems)
- Install [nvm] MANUALLY via git clone into `$XDG_CONFIG_HOME`, then use it to
  install a version of `node` (and `npm`)
  1. Use nvm managed node
  1. Install the default packages using [node/install](../node/install)
- Install [pyenv] using `pyenv-installer` (rm `~/.local/pyenv` directory for
  clean install) and make sure to use the libs provided by `brew openssl`
  1. `brew install openssl`
  1. Follow <https://github.com/yyuu/pyenv/wiki/Common-build-problems#error-the-python-ssl-extension-was-not-compiled-missing-the-openssl-lib>
  1. Set up the global pyenv as the latest stable (3.x)
  1. Set up python virtualenvs using [bootstrap/pyenv](../bootstrap/pyenv)

[nvm]: https://github.com/nvm-sh/nvm
[pyenv]: https://github.com/pyenv/pyenv
[unlock]: https://github.com/davidosomething/Unlock
